//
//  ANViewController.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANViewControllerView.h"


@interface ANViewController : NSObject {
	NSView * view;
	NSWindow * window;
	ANViewController * subviewController;
	ANViewController * parentViewController;
}

@property (readonly) NSView * view;
@property (readonly) NSWindow * window;
@property (nonatomic, assign) ANViewController * parentViewController;

- (id)init;
- (id)initWithWindow:(NSWindow *)window;
- (void)loadView;

- (void)presentViewController:(ANViewController *)vc;
- (void)presentViewControllerNonanimated:(ANViewController *)vc;
+ (void)displayViewControllerInWindow:(ANViewController *)controller;
- (void)dismissViewController;

@end
