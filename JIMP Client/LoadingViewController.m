//
//  LoadingViewController.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingViewController.h"


@implementation LoadingViewController

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)loadView {
	[super loadView];
	NSView * mainView = self.view;
	spinner = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(mainView.frame.size.width / 2 - 15,
																	mainView.frame.size.height / 2 - 15, 30, 30)];
	[spinner setStyle:NSProgressIndicatorSpinningStyle];
	[mainView addSubview:spinner];
	[spinner startAnimation:self];
}

- (void)dealloc {
	[spinner stopAnimation:self];
	[spinner release];
    [super dealloc];
}

@end
