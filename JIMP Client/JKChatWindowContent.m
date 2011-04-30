//
//  JKChatWindowContent.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatWindowContent.h"
#import "JKMessageHandler.h"


@implementation JKChatWindowContent

@synthesize currentChat;
@synthesize chatView;
@synthesize messageField;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        chatView = [[JKChatView alloc] initWithFrame:NSMakeRect(10, 100, self.frame.size.width - 20, self.frame.size.height - 120)];
		messageField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, self.frame.size.width - 20, 80)];
		[self addSubview:chatView];
		[self addSubview:messageField];
		[messageField setDelegate:self];
    }
    return self;
}

- (void)switchToChat:(JKChat *)aChat {
	currentChat = aChat;
	[chatView setChat:aChat];
	[chatView initializeFromChat];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command {
	if (command == @selector(insertNewline:)) {
		[self sendMessage:textView];
		return YES;
	}
	return NO;
}

- (void)sendMessage:(id)sender {
	NSLog(@"Send msg.");
	OOTMessage * aMessage = [[OOTMessage alloc] initWithUsername:[[currentChat buddyName] lowercaseString] message:[messageField stringValue]];
	JKChatMessage * message = [[currentChat handler] sendMessage:aMessage onChat:currentChat];
	[messageField setStringValue:@""];
	[aMessage release];
	[chatView addMessage:message];
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	[messageField setFrame:NSMakeRect(10, 10, self.frame.size.width - 20, 80)];
	[chatView setFrame:NSMakeRect(10, 100, self.frame.size.width - 20, self.frame.size.height - 120)];
}

- (void)dealloc {
	self.chatView = nil;
	[messageField release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor colorWithDeviceWhite:0.85 alpha:1] set];
	NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:5];
	[path fill];
	NSRectFill(NSMakeRect(0, self.frame.size.height - 10, self.frame.size.width, 10));
    // Drawing code here.
}

@end
