//
//  JKChatWindowDragState.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct {
	BOOL isFocused;
	BOOL isDragValid;
	NSPoint initialLocation;
	BOOL tabOverflow;
	int currentTabIndex; // index of the first tab to display.
} JKChatWindowDragState;
