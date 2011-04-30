//
//  JKChatWindowContentView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatWindowContentView.h"


@implementation JKChatWindowContentView

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
    }
    return self;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}

@end
