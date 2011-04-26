//
//  JKChatView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatView.h"


@implementation JKChatView

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor whiteColor] set];
	NSRectFill(dirtyRect);
}

@end
