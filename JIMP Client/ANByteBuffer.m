//
//  ANByteBuffer.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANByteBuffer.h"


@implementation ANByteBuffer

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
		buffer = [[NSMutableData alloc] init];
		offset = 0;
    }
    return self;
}

- (id)initWithData:(NSData *)data {
	if ((self = [self init])) {
		//buffer = [[NSMutableData alloc] init];
		[buffer appendData:data];
	}
	return self;
}
- (id)initWithBytes:(const char *)bytes length:(int)length {
	if ((self = [self init])) {
		//buffer = [[NSMutableData alloc] init];
		[buffer appendBytes:bytes length:length];
	}
	return self;
}
+ (id)byteBufferWithData:(NSData *)data {
	return [[[ANByteBuffer alloc] initWithData:data] autorelease];
}

- (char)getByte {
	if (offset >= [buffer length]) {
		@throw [NSException exceptionWithName:@"BufferUnderflowException" reason:@"The offset was greater than the number of bytes requested." userInfo:nil];
	}
	char byte = ((const char *)[buffer bytes])[offset];
	offset++;
	return byte;
}
- (const char *)getBytes:(int)length {
	const char * bufferBytes = (const char *)[buffer bytes];
	if (length + offset > [buffer length]) {
		@throw [NSException exceptionWithName:@"BufferUnderflowException" reason:@"The offset was greater than the number of bytes requested." userInfo:nil];
	}
	const char * newBytes = &bufferBytes[offset];
	offset += length;
	return newBytes;
}

- (int)currentOffset {
	return offset;
}
- (void)setCurrentOffset:(int)newOffset {
	offset = newOffset;
}
- (int)remaining {
	return (int)[buffer length] - offset;
}

- (void)dealloc {
	[buffer release];
    [super dealloc];
}

@end
