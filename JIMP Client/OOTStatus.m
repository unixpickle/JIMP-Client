//
//  OOTStatus.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTStatus.h"

@interface OOTStatus (private)

- (BOOL)initializeFromContents;

@end

@implementation OOTStatus

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithObject:(OOTObject *)object {
	if ((self = [super initWithObject:object])) {
		if (![self initializeFromContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithData:(NSData *)data {
	if ((self = [super initWithData:data])) {
		if (![self initializeFromContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super initWithByteBuffer:buffer])) {
		if (![self initializeFromContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithMessage:(NSString *)message owner:(NSString *)anOwner type:(char)type idle:(long)idle {
	NSMutableData * encoded = [[NSMutableData alloc] init];
	statusMessage = [[OOTText alloc] initWithText:message];
	owner = [[OOTText alloc] initWithText:anOwner];
	statusType = type;
	idleTime = idle;
	[encoded appendBytes:&statusType length:1];
	[encoded appendData:[[OOTUtil paddLong:idleTime toLength:8] dataUsingEncoding:NSASCIIStringEncoding]];
	[encoded appendData:[statusMessage encodeClass]];
	[encoded appendData:[owner encodeClass]];
	if ((self = [super initWithName:@"stts" data:encoded])) {
	}
	[encoded release];
	return self;
}
- (id)initWithMessage:(NSString *)message owner:(NSString *)anOwner type:(char)type {
	if ((self = [self initWithMessage:message owner:anOwner type:type idle:0])) {
		
	}
	return self;
}

- (NSString *)statusMessage {
	return [[[statusMessage textValue] retain] autorelease];
}
- (NSString *)owner {
	return [[[owner textValue] retain] autorelease];
}
- (char)statusType {
	return statusType;
}
- (long)idleTime {
	return idleTime;
}

- (BOOL)initializeFromContents {
	ANByteBuffer * buffer = [ANByteBuffer byteBufferWithData:[self classData]];
	const char * idleTimeData = NULL;
	@try {
		statusType = [buffer getByte];
		idleTimeData = [buffer getBytes:8];
	} @catch (NSException * ex) {
		return NO;
	}
	@try {
		statusMessage = [[OOTText alloc] initWithByteBuffer:buffer];
		owner = [[OOTText alloc] initWithByteBuffer:buffer];
	} @catch (NSException * ex) {
		[statusMessage release];
		[owner release];
		return NO;
	}
	NSString * idleString = [[NSString alloc] initWithBytes:idleTimeData length:8 encoding:NSASCIIStringEncoding];
	idleTime = (long)[idleString intValue];
	[idleString release];
	return YES;
}

- (void)dealloc {
	[statusMessage release];
	[owner release];
    [super dealloc];
}

@end
