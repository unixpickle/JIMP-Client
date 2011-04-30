//
//  JKChatWindowTitleWinState.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct {
	NSPoint mouseClickPoint;
	BOOL isMouseDown;
	BOOL isZoomed;
	NSRect unzoomedFrame;
} JKChatWindowTitleWinState;
