//
//  ANViewController.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANViewController.h"


@implementation ANViewController

@synthesize window;

- (id)init {
	if ((self = [super init])) {
		// nothing to do here
	}
	return self;
}

- (void)setParentViewController:(ANViewController *)_parentViewController {
	[parentViewController autorelease];
	parentViewController = [_parentViewController retain];
	window = _parentViewController.window;
}

- (ANViewController *)parentViewController {
	return parentViewController;
}

- (NSView *)view {
	if (!view) {
		[self loadView];
	}
	return view;
}

- (id)initWithWindow:(NSWindow *)_window {
	if ((self = [super init])) {
		window = _window;
	}
	return self;
}

- (void)loadView {
	view = [[ANViewControllerView alloc] initWithFrame:[[window contentView] bounds]];
	NSLog(@"%@", NSStringFromRect([view frame]));
}

- (void)presentViewController:(ANViewController *)vc {
	// here we will get it's view, add it and such.
	vc.parentViewController = self;
	[vc loadView];
	NSView * newView = [vc view];
	NSRect frame = [newView frame];
	
	frame.origin.x = [[self view] frame].size.width;
	frame.origin.y = 0;
	[newView setFrame:frame];
	
	[[[self window] contentView] addSubview:newView];
	
	[[NSAnimationContext currentContext] setDuration:0.5];
	[NSAnimationContext beginGrouping];
	frame.origin.x = 0;
	NSRect windowFrame = [[self window] frame];
	CGFloat topBar = windowFrame.size.height - [[[self window] contentView] frame].size.height;
	if (windowFrame.size.width != newView.frame.size.width 
		|| windowFrame.size.height - topBar != newView.frame.size.height) {
		// 
		windowFrame.size.height = topBar + newView.frame.size.height;
		windowFrame.size.width = newView.frame.size.width;
		[[self window] setFrame:windowFrame display:YES animate:YES];
	}
	[[newView animator] setFrameOrigin:frame.origin];
	[NSAnimationContext endGrouping];
	
	subviewController = [vc retain];
}
+ (void)displayViewControllerInWindow:(ANViewController *)vc {
	[vc loadView];
	NSView * newView = [vc view];
	NSRect frame = [newView frame];
	
	frame.origin.x = [[[vc window] contentView] frame].size.width;
	[newView setFrame:frame];
	
	[[[vc window] contentView] addSubview:newView];
	
	[[NSAnimationContext currentContext] setDuration:0.5];
	[NSAnimationContext beginGrouping];
	frame.origin.x = 0;
	[[newView animator] setFrameOrigin:frame.origin];
	[NSAnimationContext endGrouping];
}
- (void)dismissViewController {
	[[subviewController view] removeFromSuperview];
	subviewController.parentViewController = nil;
	[subviewController release];
	subviewController = nil;
	
	NSRect windowFrame = [[self window] frame];
	CGFloat topBar = windowFrame.size.height - [[[self window] contentView] frame].size.height;
	if (windowFrame.size.width != self.view.frame.size.width 
		|| windowFrame.size.height - topBar != self.view.frame.size.height) {
		// 
		windowFrame.size.height = topBar + self.view.frame.size.height;
		windowFrame.size.width = self.view.frame.size.width;
		[[self window] setFrame:windowFrame display:YES animate:YES];
	}
}

- (void)dealloc {
	[view release];
	[subviewController release];
    [super dealloc];
}

@end
