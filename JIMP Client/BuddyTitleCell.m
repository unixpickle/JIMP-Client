//
//  BuddyTitleCell.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyTitleCell.h"


@implementation BuddyTitleCell

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initImageCell:(NSImage *)anImage {
	if ((self = [super initImageCell:anImage])) {
		
	}
	return self;
}

- (id)initTextCell:(NSString *)aString {
	if ((self = [super initTextCell:aString])) {
		[self setSelectable:NO];
	}
	return self;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}

- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	return [NSColor whiteColor];
}

- (void)setSelectable:(BOOL)flag {
	[super setSelectable:NO];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	// create a new rect that covers the bounds
	// of the entire cell.
	NSRect newRect = cellFrame;
	newRect.origin.x -= 20;
	newRect.origin.y -= 1;
	newRect.size.height += 2;
	newRect.size.width += 20;
	
	// draw a gradient
	NSGradient * gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed:90.6/100.0 green:90.6/100.0 blue:90.6/100.0 alpha:1] endingColor:[NSColor colorWithDeviceRed:82.0/100.0 green:82.0/100.0 blue:82.0/100.0 alpha:1]];
	[gradient drawInRect:newRect angle:90];
	[gradient release];
	
	[[NSColor colorWithDeviceRed:0.957 green:0.957 blue:0.957 alpha:1] set];
	NSRectFill(NSMakeRect(newRect.origin.x, newRect.origin.y, newRect.size.width, 1));
	[[NSColor colorWithDeviceRed:0.741 green:0.741 blue:0.741 alpha:1] set];
	NSRectFill(NSMakeRect(newRect.origin.x, newRect.origin.y + newRect.size.height - 1, newRect.size.width, 1));
	
	[super drawWithFrame:cellFrame inView:controlView];
}

- (NSView *)controlView {
	return [super controlView];
}

- (void)dealloc {
    [super dealloc];
}

@end
