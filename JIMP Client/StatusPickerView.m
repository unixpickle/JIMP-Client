//
//  StatusPickerView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StatusPickerView.h"


@implementation StatusPickerView

@synthesize delegate;

/* methods for testing height of text,
   and drawing it.
 */

static void drawText (NSAttributedString * myString, NSRect frame) {
	NSTextStorage * textStorage = [[[NSTextStorage alloc]
									initWithAttributedString:myString] autorelease];
	NSTextContainer * textContainer = [[[NSTextContainer alloc]
										initWithContainerSize:frame.size] autorelease];
	NSLayoutManager * layoutManager = [[[NSLayoutManager alloc] init]
									   autorelease];
	[layoutManager addTextContainer:textContainer];
	[textStorage addLayoutManager:layoutManager];
	[textContainer setLineFragmentPadding:0.0];
	[layoutManager glyphRangeForTextContainer:textContainer];
	NSPoint newOrigin = NSMakePoint(frame.origin.x + 7, frame.origin.y - 7);
	[layoutManager drawGlyphsForGlyphRange:NSMakeRange(0, [layoutManager numberOfGlyphs]) 
								   atPoint:newOrigin];
}

static float textWidth (NSAttributedString * myString, float height) {
	NSTextStorage * textStorage = [[[NSTextStorage alloc]
									initWithAttributedString:myString] autorelease];
	NSTextContainer * textContainer = [[[NSTextContainer alloc]
										initWithContainerSize:NSMakeSize(FLT_MAX, height)] autorelease];
	NSLayoutManager * layoutManager = [[[NSLayoutManager alloc] init]
									   autorelease];
	[layoutManager addTextContainer:textContainer];
	[textStorage addLayoutManager:layoutManager];
	[textContainer setLineFragmentPadding:0.0];
	[layoutManager glyphRangeForTextContainer:textContainer];
	return [layoutManager
			usedRectForTextContainer:textContainer].size.width;
}

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
		statusHandler = *[JIMPStatusHandler firstStatusHandler];
		statusPulldown = [[NSPopUpButton alloc] initWithFrame:self.bounds];
		statusTextPicker = [[NSTextField alloc] initWithFrame:self.bounds];
		
		[statusTextPicker setBordered:YES];
		[statusTextPicker setSelectable:YES];
		[statusTextPicker setHidden:YES];
		
		currentState = StatusPickerViewStateUnselected;
		
		[statusPulldown setHidden:YES];
    }
    return self;
}

- (OOTStatus *)currentStatus {
	return [[currentStatus retain] autorelease];
}

- (void)setCurrentStatus:(OOTStatus *)aStatus {
	[currentStatus autorelease];
	currentStatus = [aStatus retain];
	[self setNeedsDisplay:YES];
}

- (void)setHovering {
	currentState = StatusPickerViewStateHover;
	[self setNeedsDisplay:YES];
}
- (void)setUnhovering {
	currentState = StatusPickerViewStateUnselected;
	[self setNeedsDisplay:YES];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	NSLog(@"Accepts First Mouse 2");
	return YES;
}

- (void)dealloc {
	[currentStatus release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	NSColor * textColor = [NSColor blackColor];
	NSFont * font = [NSFont systemFontOfSize:11];
	switch (currentState) {
		case StatusPickerViewStateHover:
			textColor = [NSColor whiteColor];
			CGFloat radius = self.frame.size.height / 2;
			NSColor * color = [NSColor colorWithDeviceRed:0.549 green:0.549 blue:0.549 alpha:1];
			[color set];
			NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:radius yRadius:radius];

			[path fill];
			break;
		case StatusPickerViewStateMenuDown:
			textColor = [NSColor whiteColor];
			break;
		case StatusPickerViewStateEnteringText:
			textColor = [NSColor clearColor];
		default:
			break;
	}
	
	NSString * myString = [[[NSString alloc] initWithFormat:@"%@", [currentStatus statusMessage]] autorelease];
	if ([myString isEqual:@""] || [currentStatus statusMessage] == nil) {
		if ([currentStatus statusType] == 'n') {
			myString = @"Offline";
		} else if ([currentStatus statusType] == 'a') {
			myString = @"Away";
		} else if ([currentStatus statusType] == 'o') {
			myString = @"Available";
		} else if ([currentStatus statusType] == 'i') {
			myString = [NSString stringWithFormat:@"Idle %d minutes", [currentStatus idleTime] / 60];
		}
	}
	
	NSMutableParagraphStyle * pSt = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								 font, NSFontAttributeName,
								 textColor, NSForegroundColorAttributeName,
								 pSt, NSParagraphStyleAttributeName, nil];
	NSAttributedString * as = [[NSAttributedString alloc] initWithString:myString
															  attributes:attributes];
	[pSt release];
	
	float width = textWidth(as, self.frame.size.height);
	if (![delegate statusPicker:self requestResize:width + 14]) {
		// we cannot resize ourselves
		while ([myString length] != 0) {
			myString = [myString substringToIndex:[myString length] - 1];
			width = textWidth(as, self.frame.size.height);
			if ([delegate statusPicker:self requestResize:width + 14]) break;
		}
	}
	
	NSRect frame = self.frame;
	frame.size.width = width + 14;
	[self setFrame:frame];
	drawText(as, self.bounds);
	[as release];
}

@end
