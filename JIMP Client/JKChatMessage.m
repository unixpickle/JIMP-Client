//
//  JKChatMessage.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatMessage.h"


@implementation JKChatMessage

@synthesize messageSource;
@synthesize message;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithSource:(JKChatMessageSource)theSource message:(OOTMessage *)theMessage {
	if ((self = [super init])) {
		messageSource = theSource;
		message = [theMessage retain];
	}
	return self;
}

+ (JKChatMessage *)messageWithSource:(JKChatMessageSource)theSource message:(OOTMessage *)theMessage {
	return [[[JKChatMessage alloc] initWithSource:theSource message:theMessage] autorelease];
}

- (void)dealloc {
	[message release];
    [super dealloc];
}

@end
