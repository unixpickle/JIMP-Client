//
//  BlankCell.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlankCell.h"


@implementation BlankCell

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[[NSColor blackColor] set];
	NSRectFill(cellFrame);
}

- (NSSize)cellSize {
	return NSMakeSize(0, 0);
}

- (void)dealloc {
    [super dealloc];
}

@end
