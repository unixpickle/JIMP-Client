//
//  OOTArray.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"
#import "ANByteBuffer.h"
#import "OOTUtil.h"
#import "OOTObjectCreator.h"


@interface OOTArray : OOTObject {
	NSArray * objects;
}

- (id)initWithArray:(NSArray *)objectsArray;
- (id)initWithObject:(OOTObject *)object;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (id)initWithData:(NSData *)data;

@property (nonatomic, readonly) NSArray * objects;

@end
