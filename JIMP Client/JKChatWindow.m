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
- (void)enableShadow;
- (void)_setTabMovers:(BOOL)showMovers;
- (void)_getTabWidth:(float *)tabW count:(int *)count;

@end


@implementation JKChatWindow

@synthesize content;

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
	NSWindow * oldWindow = [aChat currentWindow];
	NSRect contentFrame = NSMakeRect(0, 0, [[oldWindow contentView] frame].size.width + 100, [[oldWindow contentView] frame].size.height + 100);
	if (!oldWindow) {
		contentFrame = NSMakeRect(200, 200, 500, 400);
	}
	if ((self = [super initWithContentRect:contentFrame styleMask:(NSBorderlessWindowMask) backing:NSBackingStoreBuffered defer:NO])) {
		bzero((void *)&dragState, sizeof(dragState));
		[self setAcceptsMouseMovedEvents:YES];
		[self setOpaque:NO];
		[self setBackgroundColor:[NSColor clearColor]];
		[self setHasShadow:YES];
		// TODO: add logic
		JKChatWindowContentView * aView = [[JKChatWindowContentView alloc] initWithFrame:contentFrame];
		[self setContentView:aView];
		[aView becomeFirstResponder];
		*[JKChatWindow currentChatWindowPtr] = self;
		chatTabs = [[NSMutableArray alloc] init];
		windowControls = [[JKChatWindowTitle alloc] initWithFrame:NSMakeRect(0, [[self contentView] frame].size.height - JKChatWindowTitleHeight, JKChatWindowTitleWidth, JKChatWindowTitleHeight)];
		content = [[JKChatWindowContent alloc] initWithFrame:NSMakeRect(0, 0, [[self contentView] frame].size.width, [[self contentView] frame].size.height - JKChatWindowTitleHeight)];
		[self addChat:aChat];
		[aView addSubview:windowControls];
		[aView addSubview:content];
		[aView release];
	}
	return self;
}

#pragma mark UI Overrides

- (void)setFrame:(NSRect)frameRect display:(BOOL)flag {
	[super setFrame:frameRect display:NO];
	[windowControls setFrame:NSMakeRect(0, [[self contentView] frame].size.height - JKChatWindowTitleHeight, JKChatWindowTitleWidth, JKChatWindowTitleHeight)];
	[content setFrame:NSMakeRect(0, 0, [[self contentView] frame].size.width, [[self contentView] frame].size.height - JKChatWindowTitleHeight)];
	for (JKChatWindowTab * tab in chatTabs) {
		NSRect frame = NSMakeRect(tab.frame.origin.x, [[self contentView] frame].size.height - JKChatWindowTitleHeight, tab.frame.size.width, tab.frame.size.height);
		[tab setFrame:frame];
	}
	
	float start = windowControls.frame.size.width - 19;
	[leftMover setFrame:NSMakeRect(start, [[self contentView] frame].size.height - JKChatWindowTitleHeight, JKChatWindowTabMoverWidth, JKChatWindowTabHeight)];
	
	[rightMover setFrame:NSMakeRect(self.frame.size.width - JKChatWindowTabMoverWidth, [[self contentView] frame].size.height - JKChatWindowTitleHeight, JKChatWindowTabMoverWidth, JKChatWindowTabHeight)];
	
	
	[[NSAnimationContext currentContext] setDuration:0.01];
	[NSAnimationContext beginGrouping];
	[self layoutTabs];
	[NSAnimationContext endGrouping];
	
	[self invalidateShadow];
	[self setHasShadow:NO];
	[self performSelector:@selector(enableShadow) withObject:nil afterDelay:0.1];
}

- (void)enableShadow {
	[self invalidateShadow];
	[self setHasShadow:YES];
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

- (void)orderOut:(id)sender {
	*[JKChatWindow currentChatWindowPtr] = nil;
	for (JKChatWindowTab * tab in chatTabs) {
		[[tab chat] endChat];
	}
	for (id anObject in chatTabs) {
		if ([anObject isKindOfClass:[NSView class]]) {
			[anObject removeFromSuperview];
		}
	}
	[chatTabs release];
	chatTabs = nil;
	[super orderOut:sender];
	[self autorelease];
}

- (void)becomeKeyWindow {
	[super becomeKeyWindow];
	dragState.isFocused = YES;
	[windowControls setState:JKChatWindowTitleStateActive];
	[windowControls setNeedsDisplay:YES];
	[[content messageField] selectText:self];
}

- (void)resignKeyWindow {
	[super resignKeyWindow];
	dragState.isFocused = NO;
	[windowControls setState:JKChatWindowTitleStateUnfocused];
	[windowControls setNeedsDisplay:YES];
}

#pragma mark Chat Management

- (NSArray *)chatTabs {
	return (NSArray *)chatTabs;
}
- (void)addChat:(JKChat *)chat {
	[chat setChatState:JKChatStateTwoWay];
	[chat setCurrentWindow:self];
	JKChatWindowTab * aTab = [[JKChatWindowTab alloc] initWithFrame:NSMakeRect(0, [[self contentView] frame].size.height - JKChatWindowTitleHeight, 0, 0)];
	[aTab setChat:chat];
	[aTab setChatWindow:self];
	[aTab setDelegate:self];
	[chatTabs addObject:aTab];
	// pretend that the user clicked the tab.
	[self chatWindowTabClicked:aTab]; 
	[aTab release];
	[[NSAnimationContext currentContext] setDuration:0.2];
	[NSAnimationContext beginGrouping];
	[self layoutTabs];
	[NSAnimationContext endGrouping];
	[self performSelector:@selector(enableShadow) withObject:nil afterDelay:0.4];
}

#pragma mark Tabs

- (void)_setTabMovers:(BOOL)showMovers {
	if (showMovers) {
		if (!dragState.tabOverflow) {
			dragState.tabOverflow = YES;
		}
		float start = windowControls.frame.size.width - 19;
		if (!leftMover) {
			leftMover = [[JKChatWindowTabMover alloc] initWithFrame:NSMakeRect(start, [[self contentView] frame].size.height - JKChatWindowTitleHeight, JKChatWindowTabMoverWidth, JKChatWindowTabHeight) direction:JKChatWindowTabMoverDirectionLeft];
			[leftMover setMoverDelegate:self];
		}
		if (!rightMover) {
			rightMover = [[JKChatWindowTabMover alloc] initWithFrame:NSMakeRect(self.frame.size.width - JKChatWindowTabMoverWidth, [[self contentView] frame].size.height - JKChatWindowTitleHeight, JKChatWindowTabMoverWidth, JKChatWindowTabHeight) direction:JKChatWindowTabMoverDirectionRight];
			[rightMover setMoverDelegate:self];
		}
		if (![leftMover superview]) [[self contentView] addSubview:leftMover];
		if (![rightMover superview]) [[self contentView] addSubview:rightMover];
	} else {
		if ([rightMover superview]) [rightMover removeFromSuperview];
		if ([leftMover superview]) [leftMover removeFromSuperview];
	}
}

- (void)_getTabWidth:(float *)tabW count:(int *)count {	
	float start = leftMover.frame.origin.x + leftMover.frame.size.width - 16;
	float end = rightMover.frame.origin.y;
	float length = (end - start) + 30;
	float myCount = floor(length / JKChatWindowTabMinWidth);
	float tabWidth = round((length / myCount) + (15.0f / myCount));
	
	*count = (int)myCount;
	*tabW = tabWidth;
}

- (void)layoutTabs {
	float start = windowControls.frame.size.width - 19;
	float remaining = [[self contentView] frame].size.width - start - 16;
	float tabWidth = remaining / [chatTabs count];
	int toShow = (int)[chatTabs count];
	if (tabWidth + 15 < JKChatWindowTabMinWidth) {
		tabWidth = JKChatWindowTabMinWidth;
		[self _setTabMovers:YES];
		[self _getTabWidth:&tabWidth count:&toShow];
		start = leftMover.frame.origin.x + leftMover.frame.size.width - 16;
		if (dragState.currentTabIndex + toShow > [chatTabs count]) {
			dragState.currentTabIndex = (int)[chatTabs count] - toShow;
		}
		for (int i = 0; i < [chatTabs count]; i++) {
			JKChatWindowTab * tab = [chatTabs objectAtIndex:i];
			if (i < dragState.currentTabIndex || i >= dragState.currentTabIndex + toShow) 
				[tab removeFromSuperview];
		}
		dragState.tabOverflow = YES;
	} else {
		dragState.currentTabIndex = 0;
		[self _setTabMovers:NO];
		dragState.tabOverflow = NO;
	}
	for (int i = dragState.currentTabIndex; i < [chatTabs count]; i++) {
		JKChatWindowTab * tab = [chatTabs objectAtIndex:i];
		if (toShow-- == 0) break;
		[tab sizeToFit:tabWidth+15];
		if (![tab superview]) {
			[tab setFrame:NSMakeRect(self.frame.size.width, tab.frame.origin.y, tab.frame.size.width, tab.frame.size.height)];
			[[tab animator] setFrame:NSMakeRect(start, tab.frame.origin.y, tab.frame.size.width, tab.frame.size.height)];
			[[self contentView] addSubview:tab];
		} else {
			[[tab animator] setFrame:NSMakeRect(start, tab.frame.origin.y, tab.frame.size.width, tab.frame.size.height)];
		}
		start += tab.frame.size.width - 16;
	}
	if ([rightMover superview]) {
		[rightMover setFrame:NSMakeRect(start, rightMover.frame.origin.y, rightMover.frame.size.width, rightMover.frame.size.height)];
	}
}

- (void)chatWindowTabClicked:(JKChatWindowTab *)tab {
	[tab setSelected:YES];
	for (JKChatWindowTab * aTab in chatTabs) {
		if (aTab != tab) [aTab setSelected:NO];
	}
	[content switchToChat:[tab chat]];
}

- (void)chatWindowTabClosed:(JKChatWindowTab *)tab {
	[[tab chat] endChat];
	[chatTabs removeObject:tab];
	if ([chatTabs count] == 0) {
		[self orderOut:self];
	} else {
		if ([tab isSelected]) {
			[[chatTabs lastObject] setSelected:YES];
		}
	}
	[tab removeFromSuperview];
	[[NSAnimationContext currentContext] setDuration:0.2];
	[NSAnimationContext beginGrouping];
	[self layoutTabs];
	[NSAnimationContext endGrouping];
	[self performSelector:@selector(enableShadow) withObject:nil afterDelay:0.4];
	[self performSelector:@selector(enableShadow) withObject:nil afterDelay:0.22];
}

- (void)chatWindowTabMoverClicked:(JKChatWindowTabMover *)sender {
	if ([sender direction] == JKChatWindowTabMoverDirectionRight) dragState.currentTabIndex += 1;
	if ([sender direction] == JKChatWindowTabMoverDirectionLeft) dragState.currentTabIndex -= 1;
	if (dragState.currentTabIndex < 0) dragState.currentTabIndex = 0;
	else {
		if ([sender direction] == JKChatWindowTabMoverDirectionLeft) {
			int currentIndex = dragState.currentTabIndex;
			NSAssert(currentIndex >= 0, @"Current index invalid for the operation that was commited.");
			JKChatWindowTab * tab = [chatTabs objectAtIndex:currentIndex];
			[tab setFrame:NSMakeRect(-tab.frame.size.width, tab.frame.origin.y, tab.frame.size.width, tab.frame.size.height)];
			[[self contentView] addSubview:tab];
		}
		[self layoutTabs];
	}
	
}

#pragma mark Mouse Events

- (void)mouseMoved:(NSEvent *)evt {
	[super mouseMoved:evt];
	NSPoint p = [evt locationInWindow];
	if (CGRectContainsPoint(NSRectToCGRect([windowControls frame]), NSPointToCGPoint(p))) {
		[windowControls setState:JKChatWindowTitleStateHighlighted];
	} else {
		[windowControls setState:JKChatWindowTitleStateActive];
	}
}

- (void)mouseUp:(NSEvent *)theEvent {
	dragState.isDragValid = YES;
	[super mouseUp:theEvent];
	NSPoint p = [theEvent locationInWindow];
	if (!CGRectContainsPoint(NSRectToCGRect([windowControls frame]), NSPointToCGPoint(p))) {
		[windowControls setState:JKChatWindowTitleStateActive];
	} else {
		[windowControls setState:JKChatWindowTitleStateHighlighted];
	}
}

- (void)mouseDown:(NSEvent *)theEvent {
    dragState.isDragValid = YES;
    dragState.initialLocation = [theEvent locationInWindow];
	[super mouseDown:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSPoint p = [theEvent locationInWindow];
	if (!CGRectContainsPoint(NSRectToCGRect([windowControls frame]), NSPointToCGPoint(p))) {
		if ([windowControls hasButtonDown])
			[windowControls setState:JKChatWindowTitleStateHighlighted];
	}
	
	if ([windowControls hasButtonDown]) {
		dragState.isDragValid = NO;
		return;
	}
	
	if (!dragState.isDragValid) return;
	
    NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect windowFrame = [self frame];
    NSPoint newOrigin = windowFrame.origin;
	
    NSPoint currentLocation = [theEvent locationInWindow];
    newOrigin.x += (currentLocation.x - dragState.initialLocation.x);
    newOrigin.y += (currentLocation.y - dragState.initialLocation.y);
	
    if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)) {
        newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height);
    }
    
    [self setFrameOrigin:newOrigin];
}

- (id)retain {
	return [super retain];
}

- (void)dealloc {
	NSLog(@"JKChatWindow: -dealloc");
	if (*[JKChatWindow currentChatWindowPtr] == self) {
		*[JKChatWindow currentChatWindowPtr] = nil;
	}
	[chatTabs release];
	[windowControls release];
    [super dealloc];
}

@end
