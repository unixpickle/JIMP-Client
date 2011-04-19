//
//  BuddyTitleCell.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyTitleCell.h"
#import "BuddyOutline.h"


@implementation BuddyTitleCell

@synthesize outlineView;
@synthesize item;

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

- (void)highlightSelectionInClipRect:(NSRect)clipRect {
	return;
}

- (void)setSelectable:(BOOL)flag {
	[super setSelectable:NO];
}

- (void)setHighlighted:(BOOL)flag {
	[super setHighlighted:NO];
}

- (void)setState:(NSInteger)value {
	NSLog(@"State: %d", (int)value);
}

- (void)setRefusesFirstResponder:(BOOL)flag {
	[super setRefusesFirstResponder:YES];
}

- (void)setBackgroundStyle:(NSBackgroundStyle)style {
	[super setBackgroundStyle:NSBackgroundStyleLight];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	// create a new rect that covers the bounds
	// of the entire cell.
	[[NSColor blackColor] set];
	NSRectFill(cellFrame);
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
		
	NSImage * disclosure = nil;
	if ([outlineView isExpanded:item]) {
		disclosure = [NSImage imageNamed:@"expand2.png"];
	} else {
		disclosure = [NSImage imageNamed:@"expand1.png"];
	}
	
	NSSize boxSize = [disclosure size];
	CGFloat topY = (cellFrame.origin.y + (cellFrame.size.height / 2)) - (boxSize.height / 2);
	NSRect disclosureRect = NSMakeRect(cellFrame.origin.x - boxSize.width, topY, [disclosure size].width, [disclosure size].height);
	[disclosure drawInRect:disclosureRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	
	cellFrame.origin.x += 1;
	cellFrame.origin.y -= 0;
	NSFont * font = [NSFont boldSystemFontOfSize:12];
	NSShadow * shadow = [[NSShadow alloc] init];
	NSColor * color = [NSColor colorWithCalibratedWhite:45.5/100.0 alpha:1];
	
	[shadow setShadowOffset:NSMakeSize(0,-1)];
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.9 alpha:1]];
	
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
								 color, NSForegroundColorAttributeName, 
								 shadow, NSShadowAttributeName, nil];
	[shadow release];
	NSAttributedString * string = [[NSAttributedString alloc] initWithString:[self stringValue] attributes:attributes];
	
	[string drawInRect:cellFrame];
	[string release];
}

- (NSView *)controlView {
	return [super controlView];
}

- (void)dealloc {
	self.item = nil;
	[super dealloc];
}

@end
