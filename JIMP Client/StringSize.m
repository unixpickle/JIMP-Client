//
//  StringSize.c
//  JIMP Client
//
//  Created by Alex Nichol on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "StringSize.h"

void drawText (NSAttributedString * myString, NSRect frame) {
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

float textWidth (NSAttributedString * myString, float height) {
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
	return ceil([layoutManager
				 usedRectForTextContainer:textContainer].size.width);
}