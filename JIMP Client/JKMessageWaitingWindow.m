//
//  JKMessageWaitingWindow.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKMessageWaitingWindow.h"


@implementation JKMessageWaitingWindow

@synthesize chat;
@synthesize alertText;
@synthesize initialLocation;
@synthesize delegate;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (void)configureWindow:(NSString *)aUser {
	alertText = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 12, [[self contentView] frame].size.width - 20, [[self contentView] frame].size.height - 20)];
	[alertText setFont:[NSFont systemFontOfSize:18]];
	
	NSString * alertMessage = [NSString stringWithFormat:@"Chat request from \"%@\"", aUser];
	[alertText setStringValue:alertMessage];
	[alertText setBordered:NO];
	[alertText setSelectable:NO];
	[alertText setBackgroundColor:[NSColor clearColor]];
	
	[[self contentView] addSubview:alertText];	
	[self setHasShadow:YES];
}

- (BOOL)acceptsMouseMovedEvents {
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {    
	wasDragged = NO;
    self.initialLocation = [theEvent locationInWindow];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect windowFrame = [self frame];
    NSPoint newOrigin = windowFrame.origin;
	
    NSPoint currentLocation = [theEvent locationInWindow];
    newOrigin.x += (currentLocation.x - initialLocation.x);
    newOrigin.y += (currentLocation.y - initialLocation.y);
	
    if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)) {
        newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height);
    }
    
    [self setFrameOrigin:newOrigin];
	wasDragged = YES;
}

- (void)mouseUp:(NSEvent *)theEvent {
	if (!wasDragged) {
		[delegate messageWaitingWindowClicked:self];
	}
	wasDragged = NO;
}

- (BOOL)isFlipped {
	return YES;
}

- (void)dealloc {
	self.alertText = nil;
	self.delegate = nil;
    [super dealloc];
}

@end
