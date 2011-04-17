//
//  OOTDeleteGroup.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"
#import "ANByteBuffer.h"


@interface OOTDeleteGroup : OOTObject {
	NSString * groupName;
}

- (id)initWithGroupName:(NSString *)aGroupName;
- (id)initWithObject:(OOTObject *)object;
- (id)initWithData:(NSData *)data;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (NSString *)groupName;

@end
