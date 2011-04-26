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
		backgroundColor = [[NSColor colorWithDeviceRed:92.9/100.0 green:92.9/100.0 blue:92.9/100.0 alpha:1] retain];
    }
    return self;
}

- (void)setBackgroundColor:(NSColor *)aColor {
	[backgroundColor autorelease];
	backgroundColor = [aColor retain];
}

- (BOOL)isFlipped {
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

- (void)mouseMoved:(NSEvent *)theEvent {
	[super mouseMoved:theEvent];
	NSDictionary * dict = [NSDictionary dictionaryWithObject:theEvent forKey:@"event"];
	[[NSNotificationCenter defaultCenter] postNotificationName:ANViewControllerViewMouseMovedNotification object:self userInfo:dict];
}

- (void)mouseDown:(NSEvent *)theEvent {
	[super mouseDown:theEvent];
	NSDictionary * dict = [NSDictionary dictionaryWithObject:theEvent forKey:@"event"];
	[[NSNotificationCenter defaultCenter] postNotificationName:ANViewControllerViewMouseDownNotification object:self userInfo:dict];
}

- (void)mouseUp:(NSEvent *)theEvent {
	[super mouseUp:theEvent];
	NSDictionary * dict = [NSDictionary dictionaryWithObject:theEvent forKey:@"event"];
	[[NSNotificationCenter defaultCenter] postNotificationName:ANViewControllerViewMouseUpNotification object:self userInfo:dict];
}

- (void)dealloc {
	[self setBackgroundColor:nil];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	if (!backgroundColor) {
		[super drawRect:dirtyRect];
		return;
	}
	[backgroundColor set];
	NSRectFill(dirtyRect);
}

@end
