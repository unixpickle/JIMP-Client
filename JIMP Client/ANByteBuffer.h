//
//  ANByteBuffer.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ANByteBuffer : NSObject {
    NSMutableData * buffer;
	int offset;
}

- (id)initWithData:(NSData *)data;
- (id)initWithBytes:(const char *)bytes length:(int)length;

+ (id)byteBufferWithData:(NSData *)data;

- (char)getByte;
- (const char *)getBytes:(int)length;

- (int)currentOffset;
- (void)setCurrentOffset:(int)newOffset;
- (int)remaining;

@end
