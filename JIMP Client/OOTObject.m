//
//  OOTObject.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTObject.h"


@implementation OOTObject

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super init])) {
		const char * header = [buffer getBytes:12];
		NSString * classLength = [[[NSString alloc] initWithBytes:header 
														  length:8 encoding:NSASCIIStringEncoding] autorelease];
		
		long long number = [classLength longLongValue];
		int length = (int)number;
		
		const char * contents = [buffer getBytes:length];
		classData = [(NSData *)[NSData alloc] initWithBytes:contents length:length];
		className = [[NSString alloc] initWithBytes:&header[8] length:4 encoding:NSASCIIStringEncoding];
	}
	return self;
}
- (id)initWithData:(NSData *)data {
	if ((self = [super init])) {
		if ([data length] < 12) {
			@throw [NSException exceptionWithName:@"BufferUnderflowException" reason:@"The offset was greater than the number of bytes requested." userInfo:nil];
		}
		const char * header = (const char *)[data bytes];
		NSString * classLength = [[[NSString alloc] initWithBytes:header 
														   length:8 encoding:NSASCIIStringEncoding] autorelease];
		
		long long number = [classLength longLongValue];
		int length = (int)number;
		
		if (length + 12 > [data length]) {
			@throw [NSException exceptionWithName:@"BufferUnderflowException" reason:@"The offset was greater than the number of bytes requested." userInfo:nil];
		}
		
		const char * contents = &header[12];
		classData = [(NSData *)[NSData alloc] initWithBytes:contents length:length];
		className = [[NSString alloc] initWithBytes:&header[8] length:4 encoding:NSASCIIStringEncoding];
	}
	return self;
}
- (id)initWithHeader:(NSData *)header fromSocket:(int)fileDescriptor {
	if ((self = [super init])) {
		const char * headerBytes = (const char *)[header bytes];
		NSString * classLength = [[[NSString alloc] initWithBytes:headerBytes 
														   length:8 encoding:NSASCIIStringEncoding] autorelease];
		
		long long number = [classLength longLongValue];
		int length = (int)number;
		int has = 0;
		char * bytes = (char *)malloc(length);
		while (has < length) {
			int add = (int)read(fileDescriptor, &bytes[has], (length - has));
			if (add < 0) {
				free(bytes);
				[super dealloc];
				return nil;
			}
			length += add;
		}
		
		classData = [[NSData alloc] initWithBytesNoCopy:bytes length:length freeWhenDone:YES];
		className = [[NSString alloc] initWithBytes:&headerBytes[8] length:4 encoding:NSASCIIStringEncoding];
	}
	return self;
}
- (id)initWithName:(NSString *)_className data:(NSData *)_classData {
	if ((self = [super init])) {
		className = [_className retain];
		classData = [_classData retain];
	}
	return self;
}

+ (OOTObject *)objectWithName:(NSString *)_className data:(NSData *)_classData {
	return [[[OOTObject alloc] initWithName:_className data:_classData] autorelease];
}

- (NSString *)className {
	return className;
}
- (NSData *)classData {
	return classData;
}

- (NSData *)encodeClass {
	NSMutableData * encoded = [[NSMutableData alloc] init];
	NSString * classLength = [NSString stringWithFormat:@"%d", [classData length]];
	
	// llllllllnnnndddddd... 
	for (int i = 0; i < 8 - [classLength length]; i++) {
		char c = '0';
		[encoded appendBytes:&c length:1];
	}
	[encoded appendBytes:[classLength UTF8String] length:[classLength length]];
	[encoded appendBytes:[className UTF8String] length:4];
	[encoded appendData:classData];
	
	NSData * immutable = [NSData dataWithData:encoded];
	[encoded release];
	return immutable;
}

- (void)dealloc {
	[className release];
	[classData release];
    [super dealloc];
}

@end
