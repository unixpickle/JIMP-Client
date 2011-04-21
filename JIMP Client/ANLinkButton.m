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
@synthesize isEnabled;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
		isEnabled = YES;
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
	if (!isEnabled) return;
	NSPoint point = [theEvent locationInWindow];
	NSRect selfLocation = [self translateBoundsToWindow];
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
