//
//  JKChatWindowTabMover.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChatWindowTab.h"

#define JKChatWindowTabMoverWidth 66

typedef enum {
	JKChatWindowTabMoverDirectionLeft,
	JKChatWindowTabMoverDirectionRight,
} JKChatWindowTabMoverDirection;

@class JKChatWindowTabMover;

@protocol JKChatWindowTabMoverDelegate

- (void)chatWindowTabMoverClicked:(JKChatWindowTabMover *)sender;

@end

@interface JKChatWindowTabMover : JKChatWindowTab {
	JKChatWindowTabMoverDirection direction;
	id<JKChatWindowTabMoverDelegate> moverDelegate;
}

@property (readonly) JKChatWindowTabMoverDirection direction;
@property (assign) id<JKChatWindowTabMoverDelegate> moverDelegate;

- (id)initWithFrame:(NSRect)theFrame direction:(JKChatWindowTabMoverDirection)theDirection;

@end
