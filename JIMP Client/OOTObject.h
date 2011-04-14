//
//  OOTObject.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANByteBuffer.h"

// creation of this object may result in exceptions being thrown.
// basic datatype subclasses such as array, text, error, and others
// might not catch these exceptions.  Higher level classes may catch exceptions,
// returning nil.

@interface OOTObject : NSObject {
	NSString * className;
	NSData * classData;
}

- (id)initWithObject:(OOTObject *)object;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (id)initWithData:(NSData *)data;
- (id)initWithHeader:(NSData *)header fromSocket:(int)fileDescriptor;
- (id)initWithName:(NSString *)_className data:(NSData *)_classData;

+ (OOTObject *)objectWithName:(NSString *)_className data:(NSData *)_classData;

- (NSString *)className;
- (NSData *)classData;
- (NSData *)encodeClass;

@end
