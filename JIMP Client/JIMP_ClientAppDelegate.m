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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	signon = [[SignonViewController alloc] initWithWindow:window];
	[ANViewController displayViewControllerInWindow:signon];
}

- (void)dealloc {
	[signon release];
}

@end
