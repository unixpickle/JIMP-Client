//
//  BuddyOutline.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BuddyOutlineDelegate

- (void)buddyOutlineDeleteBuddy:(NSString *)buddy;
- (void)buddyOutlineDeleteGroup:(NSString *)group;

@end

@interface BuddyOutline : NSOutlineView {
	id<BuddyOutlineDelegate> buddyDelegate;
}

@property (assign) id<BuddyOutlineDelegate> buddyDelegate;

- (BOOL)isExpanded:(id)item;

- (void)deleteClick:(id)sender;
- (void)newChat:(id)sender;

@end
