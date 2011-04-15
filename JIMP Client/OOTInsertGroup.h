//
//  OOTInsertGroup.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"
#import "OOTText.h"
#import "OOTUtil.h"


@interface OOTInsertGroup : OOTObject {
    int groupIndex;
	OOTText * groupName;
}

@property (readonly) int groupIndex;
@property (readonly) OOTText * groupName;

- (id)initWithIndex:(int)index group:(NSString *)aGroupName;
- (id)initWithObject:(OOTObject *)object;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (id)initWithData:(NSData *)data;

@end
