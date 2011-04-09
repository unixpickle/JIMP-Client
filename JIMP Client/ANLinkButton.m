//
//  ANLinkButton.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANLinkButton.h"


@implementation ANLinkButton

@synthesize target;
@synthesize action;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setButtonText:(NSString *)text {
	if (!label) {
		label = [[NSTextField labelTextFieldWithFont:[NSFont systemFontOfSize:12]] retain];
		[label setFrame:self.bounds];
		[self addSubview:label];
	}
	[label setStringValue:text];
	[label setTextColor:[NSColor blueColor]];
}

- (void)mouseUp:(NSEvent *)theEvent {
	NSPoint point = [theEvent locationInWindow];
	NSRect selfLocation = self.frame;
	if ([[self superview] isFlipped]) {
		selfLocation.origin.y = [[self superview] frame].size.height - selfLocation.origin.y;
		selfLocation.origin.y -= selfLocation.size.height;
	}
	NSView * superview = self;
	while ((superview = [superview superview])) {
		NSRect superFrame = [superview frame];
		if ([[superview superview] isFlipped]) {
			superFrame.origin.y = [[self superview] frame].size.height - selfLocation.origin.y;
		}
		selfLocation.origin.x += superFrame.origin.x;
		selfLocation.origin.y += superFrame.origin.y;
	}
	if (NSPointInRect(point, selfLocation)) {
		if (target) {
			[target performSelector:action withObject:self];
		}
	}
}

- (void)dealloc {
	self.target = nil;
    [super dealloc];
}

@end
