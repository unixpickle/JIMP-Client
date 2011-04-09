//
//  JIMP_ClientAppDelegate.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SignonViewController.h"

@interface JIMP_ClientAppDelegate : NSObject <NSApplicationDelegate> {
@private
	NSWindow * window;
	SignonViewController * signon;
}

@property (assign) IBOutlet NSWindow * window;

@end
