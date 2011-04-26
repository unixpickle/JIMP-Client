//
//  JKChatBottom.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatBottom.h"


@implementation JKChatBottom

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (BOOL)isFlipped {
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	float radius = 5;
	
	CGContextBeginPath(context);
	CGContextSetGrayFillColor(context, 0.1, 0.5);
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, self.frame.size.width, 0);
	CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - radius);
	CGContextAddArcToPoint(context, self.frame.size.width, self.frame.size.height, self.frame.size.width - radius, self.frame.size.height, radius);
	CGContextAddArcToPoint(context, 0, self.frame.size.height, 0, self.frame.size.height - radius, radius);
	CGContextAddLineToPoint(context, 0, 0);
	
	CGContextClosePath(context);
	CGContextSaveGState(context);
	CGContextClip(context);
	
	// drawing gradient
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
	
	size_t num_locations = 2;
	CGFloat locations[2] = {0.0, 1};
	CGFloat components[8] = {0.796, 0.796, 0.796, 1, 0.655, 0.655, 0.655, 1};
	
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);
	
	CGPoint myStartPoint, myEndPoint;
	myStartPoint.x = 0.0;
	myStartPoint.y = 0.0;
	myEndPoint.x = 0;
	myEndPoint.y = self.frame.size.height;
	CGContextDrawLinearGradient(context, myGradient, myStartPoint, myEndPoint, 0);
	CGContextRestoreGState(context);
	
	CFRelease(myGradient);
	CGColorSpaceRelease(myColorspace);
	
	[[NSColor colorWithCalibratedWhite:(31.8 / 100.0) alpha:1] set];
	NSRectFill(NSMakeRect(0, 0, self.frame.size.width, 1));
}

@end
