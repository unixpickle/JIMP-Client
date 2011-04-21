//
//  NSView+Translate.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSView+Translate.h"


@implementation NSView (Translate)

- (NSRect)translateBoundsToWindow {
	NSRect selfLocation = self.frame;
	if (!self.superview) return selfLocation;
	if ([self.superview isFlipped]) {
		selfLocation.origin.y = [self.superview frame].size.height - selfLocation.origin.y;
		selfLocation.origin.y -= selfLocation.size.height;
	}
	NSView * superview = self;
	while ((superview = [superview superview])) {
		NSRect superFrame = [superview frame];
		if ([[superview superview] isFlipped]) {
			superFrame.origin.y = [superview.superview frame].size.height - superFrame.origin.y;
			superFrame.origin.y -= superFrame.size.height;
		}
		selfLocation.origin.x += superFrame.origin.x;
		selfLocation.origin.y += superFrame.origin.y;
	}
	return selfLocation;
}

@end
