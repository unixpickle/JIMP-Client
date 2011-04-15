//
//  OOTConnection.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTConnection.h"

#define kOOTConnectionWriteBuffer 65536

@interface OOTConnection (Private)

- (void)readThread:(NSThread *)mainThread;
- (void)writeThread:(NSThread *)mainThread;
- (void)connectionClosed;
- (void)hasData:(id)anObject;
- (void)setIsOpen:(BOOL)flag;

@end

@implementation OOTConnection

- (id)initWithHost:(NSString *)host port:(int)port {
	if ((self = [super init])) {
		_host = [host retain];
		_port = port;
		isOpenLock = [[NSLock alloc] init];
	}
	return self;
}

- (NSString *)host {
	return _host;
}
- (int)port {
	return _port;
}

- (OOTObject *)readObject:(BOOL)block {
	// wait for data on the buffer.
	while (true) {
		@synchronized (bufferedReads) {
			if ([bufferedReads count] > 0) {
				OOTObject * object = [[[bufferedReads objectAtIndex:0] retain] autorelease];
				return object;
			}
		}
		if (!block) break;
	}
	return nil;
}
- (BOOL)writeObject:(OOTObject *)object {
	// push object to buffer.
	if (![self isOpen]) return NO;
	@synchronized (bufferedWrites) {
		[bufferedWrites addObject:object];
	}
	return YES;
}

- (BOOL)isOpen {
	BOOL isOpenL = NO;
	[isOpenLock lock];
	isOpenL = isOpen;
	[isOpenLock unlock];
	return isOpenL;
}
- (void)close {
	if (socketfd != -1) {
		close(socketfd);
		socketfd = -1;
	}
}
- (BOOL)connect:(NSError **)error {
	if ([self isOpen] || [readThread isExecuting] || [writeThread isExecuting]) {
		if (error)
			*error = [NSError errorWithDomain:@"Connection Already Open" code:199 userInfo:nil];
		return NO;
	}
	[bufferedReads release];
	[bufferedWrites release];
	[readThread release];
	[writeThread release];
	
	// open a new socket connection
	struct sockaddr_in serv_addr;
	struct hostent * server;
	socketfd = socket(AF_INET, SOCK_STREAM, 0);
	if (socketfd < 0) {
		if (error)
			*error = [NSError errorWithDomain:@"Socket creation failed" code:200 userInfo:nil];
		return NO;
	}
	
	server = gethostbyname([_host UTF8String]);
	if (!server) {
		if (error) 
			*error = [NSError errorWithDomain:@"No host" code:201 userInfo:nil];
		return NO;
	}
	
	bzero(&serv_addr, sizeof(struct sockaddr_in));
	serv_addr.sin_family = AF_INET;
	// copy the address to our sockadd_in.
	bcopy(server->h_addr, &serv_addr.sin_addr.s_addr, server->h_length);
	serv_addr.sin_port = htons(_port);
	
	if (connect(socketfd, (const struct sockaddr *)&serv_addr, sizeof(struct sockaddr_in)) < 0) {
		if (error)
			*error = [NSError errorWithDomain:@"Connect failed" code:202 userInfo:nil];
		return NO;
	}
	
	[self setIsOpen:YES];
	
	bufferedReads = [[NSMutableArray alloc] init];
	bufferedWrites = [[NSMutableArray alloc] init];
	writeThread = [[NSThread alloc] initWithTarget:self selector:@selector(writeThread:) object:[NSThread currentThread]];
	readThread = [[NSThread alloc] initWithTarget:self selector:@selector(readThread:) object:[NSThread currentThread]];
	[writeThread start];
	[readThread start];
	if (error) *error = nil;
	return YES;
}

#pragma mark -
#pragma mark Private
#pragma mark -

- (void)setIsOpen:(BOOL)flag {
	[isOpenLock lock];
	isOpen = flag;
	[isOpenLock unlock];
}

- (void)connectionClosed {
	[[NSNotificationCenter defaultCenter] postNotificationName:OOTConnectionClosedNotification object:self];
	[self setIsOpen:NO];
}

- (void)hasData:(id)anObject {
	NSDictionary * info = [NSDictionary dictionaryWithObject:anObject forKey:@"object"];
	[[NSNotificationCenter defaultCenter] postNotificationName:OOTConnectionHasObjectNotification object:self userInfo:info];
}

#pragma mark Background

- (void)readThread:(NSThread *)mainThread {
	int newsockfd = socketfd;
	while (true) {
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
		// read the header
		
		int error;
		fd_set readDetector;
		struct timeval myVar;
		do {
			FD_ZERO(&readDetector);
			FD_SET(newsockfd, &readDetector);
			myVar.tv_sec = 10;
			myVar.tv_usec = 0;
			error = select(newsockfd + 1, &readDetector,
						   NULL, NULL, NULL);
			if (error < 0) {
				if ([self isOpen]) { // it thinks we are still open.
					[self performSelector:@selector(connectionClosed) onThread:mainThread withObject:nil waitUntilDone:YES];
				}
				[pool drain];
				return;
			}
		} while (!FD_ISSET(socketfd, &readDetector) && error <= 0);
				
		char header[12];
		int headerHas = 0;
		while (headerHas < 12) {
			int justGot = (int)read(newsockfd, &header[headerHas], 12 - headerHas);
			if (justGot <= 0 && [self isOpen]) { // it thinks we are still open.
				[self performSelector:@selector(connectionClosed) onThread:mainThread withObject:nil waitUntilDone:YES];
				headerHas = 0;
				break;
			}
			headerHas += justGot;
		}
		
		if (headerHas != 12) {
			[pool drain];
			break;
		}
		
		@try {
			NSData * headerData = [NSData dataWithBytes:header length:12];
			OOTObject * object = [[OOTObject alloc] initWithHeader:headerData fromSocket:newsockfd];
			if (object) {
				@synchronized (bufferedReads) {
					[bufferedReads addObject:object];
					[object release];
				}
				[self performSelector:@selector(hasData:) onThread:mainThread withObject:object waitUntilDone:YES];
			} else {
				if ([self isOpen]) { // it thinks we are still open.
					[self performSelector:@selector(connectionClosed) onThread:mainThread withObject:nil waitUntilDone:YES];
					break;
				}
			}
		} @catch (NSException * e) {
			NSLog(@"Got read exception: %@", e);
			if ([self isOpen]) { // it thinks we are still open.
				[self performSelector:@selector(connectionClosed) onThread:mainThread withObject:nil waitUntilDone:YES];
				break;
			}
			[pool drain];
			break;
		}
		
		[pool drain];
	}
	NSAutoreleasePool * outer = [[NSAutoreleasePool alloc] init];
	[readThread release];
	readThread = nil;
	[outer drain];
}
- (void)writeThread:(NSThread *)mainThread {
	int newsockfd = socketfd;
	while (true) {
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
		if (![self isOpen]) {
			[pool drain];
			break;
		}
		
		OOTObject * writeObject = nil;
		@synchronized (bufferedWrites) {
			if ([bufferedWrites count] > 0) {
				writeObject = [[[bufferedWrites objectAtIndex:0] retain] autorelease];
				[bufferedWrites removeObjectAtIndex:0];
			}
		}
		
		if (writeObject) {
			NSData * encoded = [writeObject encodeClass];
			const char * pointer = (const char *)[encoded bytes];
			int hasWritten = 0;
			int totalSize = (int)[encoded length];
			while (hasWritten < totalSize) {
				long toWrite = totalSize - hasWritten;
				if (toWrite > kOOTConnectionWriteBuffer) {
					toWrite = kOOTConnectionWriteBuffer;
				}
				int wrote = (int)write(newsockfd, &pointer[hasWritten], (int)toWrite);
				if (wrote <= 0) {
					if ([self isOpen]) { // it thinks we are still open.
						[self performSelector:@selector(connectionClosed) onThread:mainThread withObject:nil waitUntilDone:YES];
						break;
					}
				}
				hasWritten += wrote;
			}
		}
		
		[NSThread sleepForTimeInterval:0.2];
		
		[pool drain];
	}
	NSAutoreleasePool * outer = [[NSAutoreleasePool alloc] init];
	[writeThread release];
	writeThread = nil;
	[outer drain];
}

- (void)dealloc {
	[bufferedReads release];
	[bufferedWrites release];
	[readThread release];
	[writeThread release];
	[isOpenLock release];
}

@end
