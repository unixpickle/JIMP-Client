//
//  BuddyListCell.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyListCell.h"


@implementation BuddyListCell

@synthesize backgroundColor;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSRect backgroundFrame = cellFrame;
	NSRect newFrame = cellFrame;
	
	backgroundFrame.origin.x -= 33;
	backgroundFrame.origin.y -= 1;
	backgroundFrame.size.width += 33;
	backgroundFrame.size.height += 1;
	
	newFrame.origin.x -= 15;
	newFrame.origin.y += 8;
	newFrame.size.height -= 8;
	newFrame.size.width += 15;
	[backgroundColor set];
	if (![self isHighlighted])
		if (backgroundColor) NSRectFill(backgroundFrame);
	[super drawWithFrame:newFrame inView:controlView];
}

- (void)dealloc {
    [super dealloc];
}

@end
