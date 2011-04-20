//
//  JIMP_ClientAppDelegate.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JIMP_ClientAppDelegate.h"

@implementation JIMP_ClientAppDelegate

@synthesize window;
@synthesize menuItemAddBuddy;
@synthesize menuItemAddGroup;
@synthesize menuItemRemoveBuddy;

- (void)awakeFromNib { 
	
} 

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	// [[JIMPSessionManager sharedInstance] openConnection];
	[[self window] setAcceptsMouseMovedEvents:YES];
	[[self window] makeMainWindow];
	ANViewControllerView * windowView = [[ANViewControllerView alloc] initWithFrame:[[window contentView] frame]];
	[window setContentView:windowView];
	NSLog(@"%d", [windowView canBecomeKeyView]);
	[window makeFirstResponder:windowView];
	[windowView release];
	
	signon = [[SignonViewController alloc] initWithWindow:window];
	[ANViewController displayViewControllerInWindow:signon];
	
	[window makeFirstResponder:signon.view];
}

- (void)dealloc {
	[signon release];
}

@end
