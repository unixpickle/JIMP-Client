//
//  JKChatWindowTitle.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChatWindowTitleButton.h"
#import "JKChatWindowTitleWinState.h"

#define JKChatWindowTitleWidth 95
#define JKChatWindowTitleHeight 22

typedef enum {
	JKChatWindowTitleStateActive,
	JKChatWindowTitleStateHighlighted,
	JKChatWindowTitleStateUnfocused
} JKChatWindowTitleState;

@interface JKChatWindowTitle : NSView {
	NSImage * background;
	JKChatWindowTitleButton * closeButton;
	JKChatWindowTitleButton * minimizeButton;
	JKChatWindowTitleButton * zoomButton;
	JKChatWindowTitleState state;
	JKChatWindowTitleWinState uiState;
}

- (BOOL)hasButtonDown;
- (BOOL)isPointButton:(NSPoint)aPoint;

@property (readwrite) JKChatWindowTitleState state;

@end
