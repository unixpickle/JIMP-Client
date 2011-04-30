//
//  JKChatWindowTitleButton.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatWindowTitleButton.h"


@implementation JKChatWindowTitleButton

@synthesize buttonFrame;

- (void)loadState:(NSString *)state buttonName:(NSString *)name {
	NSString * imageNamed = [name stringByAppendingString:state];
	NSImage * image = [NSImage imageNamed:imageNamed];
	[buttonImages setObject:image forKey:state];
}

- (id)initWithPrefix:(NSString *)buttonName {
	if ((self = [super init])) {
		buttonFrame = NSMakeRect(0, 0, 14, 16);
		buttonImages = [[NSMutableDictionary alloc] init];
		[self loadState:JKChatWindowTitleButtonStateActive buttonName:buttonName];
		[self loadState:JKChatWindowTitleButtonStateActiveNokey buttonName:buttonName];
		[self loadState:JKChatWindowTitleButtonStateRollover buttonName:buttonName];
		[self loadState:JKChatWindowTitleButtonStatePress buttonName:buttonName];
	}
	return self;
}

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (NSImage *)imageWithState:(NSString *)buttonState {
	return [buttonImages objectForKey:buttonState];
}

- (void)dealloc {
	[buttonImages release];
    [super dealloc];
}

@end
