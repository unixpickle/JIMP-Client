//
//  OOTBuddyList.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"
#import "OOTArray.h"
#import "OOTBuddy.h"


@interface OOTBuddyList : OOTObject {
    OOTArray * buddies;
	OOTArray * groups;
}

- (id)initWithObject:(OOTObject *)object;
- (id)initWithData:(NSData *)data;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;

- (NSArray *)buddies;
- (NSArray *)groups;

@end
