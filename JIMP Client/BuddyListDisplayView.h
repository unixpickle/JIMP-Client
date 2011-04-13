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
#import "BlankCell.h"


@interface BuddyListDisplayView : NSView <NSOutlineViewDataSource, NSOutlineViewDelegate> {
    BuddyList * buddyList;
	NSOutlineView * buddyOutline;
	NSMutableDictionary * indices;
}

- (void)setBuddyList:(BuddyList *)_buddyList;

@property (nonatomic, retain) NSOutlineView * buddyOutline;

@end
