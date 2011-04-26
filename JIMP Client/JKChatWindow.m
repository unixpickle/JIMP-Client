//
//  JKChatWindow.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatWindow.h"

@interface JKChatWindow (private)

+ (JKChatWindow **)currentChatWindowPtr;

@end


@implementation JKChatWindow

+ (JKChatWindow **)currentChatWindowPtr {
	static JKChatWindow * chat = nil;
	return &chat;
}

+ (JKChatWindow *)currentChatWindow {
	return *[JKChatWindow currentChatWindowPtr];
}

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithChat:(JKChat *)aChat {
	if ((self = [super initWithContentRect:NSMakeRect(0, 0, 710, 466) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO])) {
		// TODO: add logic
		*[JKChatWindow currentChatWindowPtr] = self;
	}
	return self;
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (NSArray *)chats {
	return (NSArray *)chats;
}
- (void)addChat:(JKChat *)chat {
	[chats addObject:chat];
	// TODO: add logic
}

- (void)orderOut:(id)sender {
	[super orderOut:self];
	*[JKChatWindow currentChatWindowPtr] = nil;
}

- (void)dealloc {
	if (*[JKChatWindow currentChatWindowPtr] == self) {
		*[JKChatWindow currentChatWindowPtr] = nil;
	}
    [super dealloc];
}

@end
