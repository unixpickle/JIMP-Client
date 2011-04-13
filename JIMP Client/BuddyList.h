//
//  BuddyList.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTBuddyList.h"
#import "OOTBuddy.h"


@interface BuddyList : NSObject {
    // group = {"name": x, "buddies": [bud1, bud2, bud3, ...]};
	NSArray * groups;
}

- (id)initWithBuddyList:(OOTBuddyList *)buddyList;

- (int)numberOfGroups;
- (NSString *)groupTitle:(int)index;
- (int)numberOfItems:(int)group;
- (NSString *)itemAtIndex:(int)index ofGroup:(int)groupIndex;

@end
