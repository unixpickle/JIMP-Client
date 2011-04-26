//
//  JKMessageWaitingView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKMessageWaitingView.h"


@implementation JKMessageWaitingView

@synthesize aBackgroundColor;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
	if (!aBackgroundColor) {
		self.aBackgroundColor = [NSColor colorWithCalibratedWhite:1 alpha:0.90];
	}
	[aBackgroundColor set];
	NSBezierPath * roundedRect = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:10 yRadius:10];
	[roundedRect fill];
}

- (void)dealloc {
	self.aBackgroundColor = nil;
    [super dealloc];
}

@end
