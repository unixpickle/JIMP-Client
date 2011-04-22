//
//  BuddyOutline.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JKBuddyOutlineDelegate

- (void)buddyOutlineDeleteBuddy:(NSString *)buddy;
- (void)buddyOutlineDeleteGroup:(NSString *)group;

@end

@interface JKBuddyOutline : NSOutlineView {
	id<JKBuddyOutlineDelegate> buddyDelegate;
	BOOL hasReloaded;
}

@property (assign) id<JKBuddyOutlineDelegate> buddyDelegate;

- (BOOL)isExpanded:(id)item;

- (void)deleteClick:(id)sender;
- (void)newChat:(id)sender;

@end
