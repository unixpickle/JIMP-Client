//
//  BuddyTitleCell.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JKBuddyOutline;

@interface BuddyTitleCell : NSCell {
    JKBuddyOutline * outlineView;
	id item;
}

@property (nonatomic, assign) JKBuddyOutline * outlineView;
@property (nonatomic, retain) id item;

@end
