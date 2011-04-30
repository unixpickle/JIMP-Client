//
//  JKChatWindowTitle.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatWindowTitle.h"


@implementation JKChatWindowTitle

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
		bzero((void *)&uiState, sizeof(uiState));
		background = [[NSImage imageNamed:@"titlebar2.png"] retain];
		closeButton = [[JKChatWindowTitleButton alloc] initWithPrefix:@"close"];
		minimizeButton = [[JKChatWindowTitleButton alloc] initWithPrefix:@"minimize"];
		zoomButton = [[JKChatWindowTitleButton alloc] initWithPrefix:@"zoom"];
		[closeButton setButtonFrame:NSMakeRect(5, 2, 14, 16)];
		[minimizeButton setButtonFrame:NSMakeRect(9 + 16, 2, 14, 16)];
		[zoomButton setButtonFrame:NSMakeRect(29 + 16, 2, 14, 16)];
		state = JKChatWindowTitleStateActive;
	}
    return self;
}

- (JKChatWindowTitleState)state {
	return state;
}

- (void)setState:(JKChatWindowTitleState)theState {
	state = theState;
	uiState.isMouseDown = NO;
	[self setNeedsDisplay:YES];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)canBecomeKeyView {
	return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
	[super mouseDown:theEvent];
	NSPoint p = [theEvent locationInWindow];
	uiState.isMouseDown = YES;
	uiState.mouseClickPoint = NSMakePoint(p.x - self.frame.origin.x, p.y - self.frame.origin.y);
	[self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
	if (uiState.isMouseDown) {
		CGPoint p = NSPointToCGPoint(uiState.mouseClickPoint);
		if (CGRectContainsPoint(NSRectToCGRect([zoomButton buttonFrame]), p)) {
			if (!uiState.isZoomed) {
				uiState.unzoomedFrame = [[self window] frame];
				NSRect visible = [[[self window] screen] visibleFrame];
				[[self window] setFrame:visible display:YES];
			} else {
				[[self window] setFrame:uiState.unzoomedFrame display:YES];
			}
			uiState.isZoomed = uiState.isZoomed ^ 1;
		} else if (CGRectContainsPoint(NSRectToCGRect([closeButton buttonFrame]), p)) {
			[[self window] orderOut:self];
		} else if (CGRectContainsPoint(NSRectToCGRect([minimizeButton buttonFrame]), p)) {
			[[self window] miniaturize:self];
		}
	}
	uiState.isMouseDown = NO;
	[self setNeedsDisplay:YES];
}

- (BOOL)hasButtonDown {
	return [self isPointButton:uiState.mouseClickPoint];
}

- (BOOL)isPointButton:(NSPoint)aPoint {
	if (uiState.isMouseDown) {
		CGPoint p = NSPointToCGPoint(aPoint);
		if (CGRectContainsPoint(NSRectToCGRect([zoomButton buttonFrame]), p)) {
			return YES;
		} else if (CGRectContainsPoint(NSRectToCGRect([closeButton buttonFrame]), p)) {
			return YES;
		} else if (CGRectContainsPoint(NSRectToCGRect([minimizeButton buttonFrame]), p)) {
			return YES;
		}
	}
	return NO;
}

- (void)dealloc {
	[background release];
	[closeButton release];
	[minimizeButton release];
	[zoomButton release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
	[background drawInRect:NSMakeRect(0, 0, background.size.width, background.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	NSImage * close = nil;
	NSImage * minimize = nil;
	NSImage * zoom = nil;
	if (state == JKChatWindowTitleStateActive) {
		close = [closeButton imageWithState:JKChatWindowTitleButtonStateActive];
		minimize = [minimizeButton imageWithState:JKChatWindowTitleButtonStateActive];
		zoom = [zoomButton imageWithState:JKChatWindowTitleButtonStateActive];
	} else if (state == JKChatWindowTitleStateHighlighted) {
		close = [closeButton imageWithState:JKChatWindowTitleButtonStateRollover];
		minimize = [minimizeButton imageWithState:JKChatWindowTitleButtonStateRollover];
		zoom = [zoomButton imageWithState:JKChatWindowTitleButtonStateRollover];
	} else if (state == JKChatWindowTitleStateUnfocused) {
		close = [closeButton imageWithState:JKChatWindowTitleButtonStateActiveNokey];
		minimize = [minimizeButton imageWithState:JKChatWindowTitleButtonStateActiveNokey];
		zoom = [zoomButton imageWithState:JKChatWindowTitleButtonStateActiveNokey];
	}
	
	if (uiState.isMouseDown) {
		CGPoint p = NSPointToCGPoint(uiState.mouseClickPoint);
		if (CGRectContainsPoint(NSRectToCGRect([zoomButton buttonFrame]), p)) {
			zoom = [zoomButton imageWithState:JKChatWindowTitleButtonStatePress];
		} else if (CGRectContainsPoint(NSRectToCGRect([closeButton buttonFrame]), p)) {
			close = [closeButton imageWithState:JKChatWindowTitleButtonStatePress];
		} else if (CGRectContainsPoint(NSRectToCGRect([minimizeButton buttonFrame]), p)) {
			minimize = [minimizeButton imageWithState:JKChatWindowTitleButtonStatePress];
		}
	}
	
	[close drawInRect:closeButton.buttonFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	[minimize drawInRect:minimizeButton.buttonFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	[zoom drawInRect:zoomButton.buttonFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

@end
