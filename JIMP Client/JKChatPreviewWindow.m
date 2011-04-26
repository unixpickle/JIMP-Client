//
//  JKChatWindow.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatPreviewWindow.h"

@interface JKChatPreviewWindow (private)

- (void)acceptPress:(id)sender;
- (void)declinePress:(id)sender;

@end

@implementation JKChatPreviewWindow

@synthesize chat;

@synthesize acceptButton;
@synthesize declineButton;
@synthesize chatView;
@synthesize chatBottom;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }    
    return self;
}


- (id)initPendingAcceptance:(NSRect)contentRect {
	if ((self = [super initWithContentRect:contentRect styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask)
								   backing:NSBackingStoreBuffered defer:NO])) {
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		NSRect frame = contentRect;
		NSView * view = [[NSView alloc] initWithFrame:frame];
		[self setContentView:view];
		chat = nil;
		chatView  = [[JKChatView alloc] initWithFrame:NSMakeRect(0, 35, frame.size.width, frame.size.height - 35)];
		chatBottom = [[JKChatBottom alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, 35)];
		acceptButton = [[NSButton alloc] initWithFrame:NSMakeRect(frame.size.width - 90, 5, 80, 25)];
		declineButton = [[NSButton alloc] initWithFrame:NSMakeRect(frame.size.width - 180, 5, 80, 25)];
		
		[acceptButton setButtonType:NSMomentaryLightButton];
		[acceptButton setBezelStyle:NSTexturedSquareBezelStyle];
		[acceptButton setTitle:@"Accept"];
		[acceptButton setTarget:self];
		[acceptButton setAction:@selector(acceptPress:)];
		
		[declineButton setButtonType:NSMomentaryLightButton];
		[declineButton setBezelStyle:NSTexturedSquareBezelStyle];
		[declineButton setTitle:@"Decline"];
		[declineButton setTarget:self];
		[declineButton setAction:@selector(declinePress:)];
		
		[chatBottom addSubview:acceptButton];
		[chatBottom addSubview:declineButton];
		[view addSubview:chatView];
		[view addSubview:chatBottom];
		[view release];
	}
	return self;
}

- (void)becomeMainWindow {
	[super becomeMainWindow];
	NSLog(@"Is main window.");
}

- (void)resignMainWindow {
	[super resignMainWindow];
	NSLog(@"Is background window.");
}

- (void)orderOut:(id)sender {
	[super orderOut:self];
	[chat setCurrentWindow:nil];
	[chat setChatState:JKChatStateUninitialized];
	[chat endChat];
}

#pragma mark Button Events

- (void)acceptPress:(id)sender {
	// TODO: show a new chat window, or an existing one.
}
- (void)declinePress:(id)sender {
	
}

- (void)dealloc {
	self.acceptButton = nil;
	self.declineButton = nil;
	self.chatView = nil;
	self.chatBottom = nil;
    [super dealloc];
}

@end
