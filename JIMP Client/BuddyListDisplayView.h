//
//  BuddyListDisplayView.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BuddyList.h"
#import "BuddyTitleCell.h"
#import "BuddyListCell.h"
#import "BlankCell.h"
#import "BuddyOutline.h"
#import "BuddyListItem.h"

@interface BuddyListDisplayView : NSView <NSOutlineViewDataSource, NSOutlineViewDelegate> {
    BuddyList * buddyList;
	BuddyOutline * buddyOutline;
}

- (void)setBuddyList:(BuddyList *)_buddyList;
- (void)deleteClick:(id)sender;

@property (nonatomic, retain) NSOutlineView * buddyOutline;

@end
