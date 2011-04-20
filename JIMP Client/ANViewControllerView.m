//
//  ANViewControllerView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANViewControllerView.h"


@implementation ANViewControllerView

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
    }
    return self;
}

- (BOOL)isFlipped {
	return YES;
}

- (BOOL)canBecomeKeyView {
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

- (void)mouseMoved:(NSEvent *)theEvent {
	NSDictionary * dict = [NSDictionary dictionaryWithObject:theEvent forKey:@"event"];
	[[NSNotificationCenter defaultCenter] postNotificationName:ANViewControllerViewMouseMovedNotification object:self userInfo:dict];
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	[[NSColor colorWithDeviceRed:92.9/100.0 green:92.9/100.0 blue:92.9/100.0 alpha:1] set];
	NSRectFill(dirtyRect);
}

@end
