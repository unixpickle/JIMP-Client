//
//  JKChatWindowTap.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatWindowTab.h"
#import "JKChatWindow.h"


@implementation JKChatWindowTab

@synthesize chat;
@synthesize chatWindow;
@synthesize tabWidth;
@synthesize buddyTitle;
@synthesize isSelected;
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
		images.regularLeft = [[NSImage imageNamed:@"tab_left.png"] retain];
		images.regularCenter = [[NSImage imageNamed:@"tab_center.png"] retain];
		images.regularRight = [[NSImage imageNamed:@"tab_right.png"] retain];
		
		NSShadow * shadow = [[NSShadow alloc] init];
		[shadow setShadowColor:[NSColor whiteColor]];
		[shadow setShadowOffset:NSMakeSize(0, -1)];
		[shadow setShadowBlurRadius:1];
		self.buddyTitle = [NSTextField labelTextFieldWithFont:[NSFont systemFontOfSize:12]];
		[buddyTitle setFrame:NSMakeRect(22, 0, frame.size.width - 62, frame.size.height - 2)];
		[buddyTitle setAlignment:NSCenterTextAlignment];
		[buddyTitle setShadow:[shadow autorelease]];
		[self addSubview:buddyTitle];
    }
    return self;
}

- (void)setFrame:(NSRect)frameRect {
	[buddyTitle setFrame:NSMakeRect(22, 0, frameRect.size.width - 62, frameRect.size.height - 2)];
	[super setFrame:frameRect];
}

- (BOOL)sizeToFit:(float)_suggestedWidth {
	float suggestedWidth = _suggestedWidth;
	if (suggestedWidth > JKChatWindowTabWidth) {
		suggestedWidth = JKChatWindowTabWidth;
	}
	[buddyTitle setStringValue:[chat buddyName]];
	NSRect frame = self.frame;
	frame.size.width = suggestedWidth;
	frame.size.height = JKChatWindowTabHeight;
	[self setFrame:frame];
	return YES;
}

- (void)setSelected:(BOOL)flag {
	if (flag == isSelected) return;
	if (flag) {
		[buddyTitle setTextColor:[NSColor whiteColor]];
	} else {
		[buddyTitle setTextColor:[NSColor blackColor]];
	}
	isSelected = flag;
}

- (void)mouseDown:(NSEvent *)theEvent {
	[super mouseDown:theEvent];
	NSRect closeFrame = NSMakeRect(self.frame.size.width - 34, self.frame.size.height / 2 - 8, 16, 16);
	closeFrame.origin.x += [self translateBoundsToWindow].origin.x;
	closeFrame.origin.y += [self translateBoundsToWindow].origin.y;
	if (CGRectContainsPoint(NSRectToCGRect(closeFrame), NSPointToCGPoint([theEvent locationInWindow]))) {
		if ([delegate respondsToSelector:@selector(chatWindowTabClosed:)]) {
			[delegate chatWindowTabClosed:self];
		}
		return;
	}
	if ([delegate respondsToSelector:@selector(chatWindowTabClicked:)]) {
		[delegate chatWindowTabClicked:self];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent {
	[super mouseDragged:theEvent];
}

- (void)drawRectUnclosable:(NSRect)aRect {
	NSSize leftSize = images.regularLeft.size;
	NSSize rightSize = images.regularRight.size;
	[images.regularLeft drawInRect:NSMakeRect(0, 0, leftSize.width, leftSize.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	[images.regularCenter drawInRect:NSMakeRect(leftSize.width, 0, self.frame.size.width - (leftSize.width + rightSize.width), images.regularCenter.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	[images.regularRight drawInRect:NSMakeRect(self.frame.size.width - rightSize.width, 0, rightSize.width, rightSize.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	[self drawRectUnclosable:dirtyRect];
	
	[[NSColor colorWithCalibratedWhite:0.781 alpha:1] set];
	[[NSColor colorWithCalibratedWhite:0.9 alpha:1] setStroke];
	
	NSRect closeFrame = NSMakeRect(self.frame.size.width - 34, self.frame.size.height / 2 - 8, 16, 16);
	NSBezierPath * path = [NSBezierPath bezierPathWithOvalInRect:closeFrame];
	NSBezierPath * line1 = [NSBezierPath bezierPath];
	NSBezierPath * line2 = [NSBezierPath bezierPath];
	[line1 moveToPoint:NSMakePoint(closeFrame.origin.x + 4, closeFrame.origin.y + 4)];
	[line1 lineToPoint:NSMakePoint(closeFrame.origin.x + closeFrame.size.width - 4, closeFrame.origin.y + closeFrame.size.height - 4)];
	[line2 moveToPoint:NSMakePoint(closeFrame.origin.x + 4, closeFrame.origin.y + closeFrame.size.height - 4)];
	[line2 lineToPoint:NSMakePoint(closeFrame.origin.x + closeFrame.size.width - 4, closeFrame.origin.y + 4)];
	[path fill];
	[line1 stroke];
	[line2 stroke];
}

- (void)dealloc {
	NSLog(@"Tab dealloc.");
	self.chat = nil;
	self.buddyTitle = nil;
	JKChatWindowTabImagesRelease(images);
    [super dealloc];
}

@end
