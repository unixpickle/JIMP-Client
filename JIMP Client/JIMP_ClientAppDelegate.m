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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	[[JIMPSessionManager sharedInstance] openConnection];
	signon = [[SignonViewController alloc] initWithWindow:window];
	[ANViewController displayViewControllerInWindow:signon];
	[signon release];
}

- (void)dealloc {
	[signon release];
}

@end
