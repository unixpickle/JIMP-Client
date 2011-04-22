//
//  BuddyListDisplayView.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKBuddyList.h"
#import "BuddyTitleCell.h"
#import "BuddyListCell.h"
#import "BlankCell.h"
#import "JKBuddyOutline.h"
#import "JKBuddyListItem.h"

@interface JKBuddyListDisplayView : NSView <NSOutlineViewDataSource, NSOutlineViewDelegate> {
    JKBuddyList * buddyList;
	JKBuddyOutline * buddyOutline;
}

- (void)setBuddyList:(JKBuddyList *)_buddyList;
- (void)deleteClick:(id)sender;

@property (nonatomic, retain) NSOutlineView * buddyOutline;

@end
