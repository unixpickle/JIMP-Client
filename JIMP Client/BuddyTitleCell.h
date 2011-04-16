//
//  BuddyTitleCell.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BuddyOutline;

@interface BuddyTitleCell : NSCell {
    BuddyOutline * outlineView;
	id item;
}

@property (nonatomic, assign) BuddyOutline * outlineView;
@property (nonatomic, retain) id item;

@end
