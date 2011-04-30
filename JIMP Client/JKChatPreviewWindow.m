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
- (void)windowWillResize:(NSNotification *)notification;

@end

@implementation JKChatPreviewWindow

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
		[self setDelegate:self];
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		NSRect frame = contentRect;
		NSView * view = [[NSView alloc] initWithFrame:frame];
		[self setContentView:view];
		chat = nil;
		chatView = [[JKChatView alloc] initWithFrame:NSMakeRect(0, 35, frame.size.width, frame.size.height - 35)];
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
}

- (void)resignMainWindow {
	[super resignMainWindow];
}

- (void)orderOut:(id)sender {
	[super orderOut:sender];
	[chat setCurrentWindow:nil];
	[chat setChatState:JKChatStateUninitialized];
	[chat endChat];
	chat = nil;
	[self autorelease];
}

#pragma mark Button Events

- (void)acceptPress:(id)sender {
	if (![JKChatWindow currentChatWindow]) {
		JKChatWindow * window = [[JKChatWindow alloc] initWithChat:[self chat]];
		[window center];
		[super orderOut:self]; // super, rather than self.
		[window makeKeyAndOrderFront:self];
		[window setReleasedWhenClosed:YES];
	} else {
		JKChatWindow * window = [JKChatWindow currentChatWindow];
		[window addChat:[self chat]];
		[super orderOut:self]; // super, rather than self.
		[window makeKeyAndOrderFront:self];
	}
}
- (void)declinePress:(id)sender {
	[self orderOut:self];
}

#pragma mark Resize

- (NSSize)windowWillResize:(NSWindow *)window toSize:(NSSize)frameSize {
	if (frameSize.width < 200) frameSize.width = 200;
	if (frameSize.height < 200) frameSize.height = 200;
	[chatView setFrame:NSMakeRect(0, 35, frameSize.width, frameSize.height - 35)];
	[chatBottom setFrame:NSMakeRect(0, 0, frameSize.width, 35)];
	[acceptButton setFrame:NSMakeRect(frameSize.width - 90, 5, 80, 25)];
	[declineButton setFrame:NSMakeRect(frameSize.width - 180, 5, 80, 25)];
	return frameSize;
}

#pragma mark Properties

- (JKChat *)chat {
	return chat;
}

- (void)setChat:(JKChat *)aChat {
	chat = aChat;
	[chatView setChat:chat];
	[chatView initializeFromChat];
}

- (void)dealloc {
	self.acceptButton = nil;
	self.declineButton = nil;
	self.chatView = nil;
	self.chatBottom = nil;
    [super dealloc];
}

@end
