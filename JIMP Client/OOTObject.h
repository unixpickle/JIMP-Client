//
//  OOTObject.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANByteBuffer.h"

@interface OOTObject : NSObject {
	NSString * className;
	NSData * classData;
}

- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (id)initWithData:(NSData *)data;
- (id)initWithHeader:(NSData *)header fromSocket:(int)fileDescriptor;
- (id)initWithName:(NSString *)_className data:(NSData *)_classData;

+ (OOTObject *)objectWithName:(NSString *)_className data:(NSData *)_classData;

- (NSString *)className;
- (NSData *)classData;
- (NSData *)encodeClass;

@end
