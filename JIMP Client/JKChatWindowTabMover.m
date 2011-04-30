//
//  JKChatWindowTabMover.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatWindowTabMover.h"


@implementation JKChatWindowTabMover

@synthesize direction;
@synthesize moverDelegate;

- (id)initWithFrame:(NSRect)theFrame direction:(JKChatWindowTabMoverDirection)theDirection {
	if ((self = [super initWithFrame:theFrame])) {
		direction = theDirection;
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)mouseDragged:(NSEvent *)theEvent {
	// override to prevent tab dragging.
}

- (void)mouseDown:(NSEvent *)theEvent {
	[moverDelegate chatWindowTabMoverClicked:self];
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRectUnclosable:dirtyRect];
	NSBezierPath * path = [NSBezierPath bezierPath];
	if (direction == JKChatWindowTabMoverDirectionLeft) {
		[path moveToPoint:NSMakePoint(self.frame.size.width / 2 - 5, self.frame.size.height / 2)];
		[path lineToPoint:NSMakePoint(self.frame.size.width / 2 + 3, self.frame.size.height / 2 - 5)];
		[path lineToPoint:NSMakePoint(self.frame.size.width / 2 + 3, self.frame.size.height / 2 + 5)];
	} else if (direction == JKChatWindowTabMoverDirectionRight) {
		[path moveToPoint:NSMakePoint(self.frame.size.width / 2 + 5, self.frame.size.height / 2)];
		[path lineToPoint:NSMakePoint(self.frame.size.width / 2 - 3, self.frame.size.height / 2 - 5)];
		[path lineToPoint:NSMakePoint(self.frame.size.width / 2 - 3, self.frame.size.height / 2 + 5)];
	}
	[[NSColor blackColor] setFill];
	[path fill];
}

@end
