//
//  JKMessageHandler.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKMessageHandler.h"

@interface JKMessageHandler (private)

- (void)connectionNewPacket:(NSNotification *)notification;

@end

@implementation JKMessageHandler

@synthesize account;
@synthesize connection;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithConnection:(OOTConnection *)_connection account:(NSString *)_account {
	if ((self = [super init])) {
		account = [_account retain];
		connection = _connection;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionNewPacket:) name:OOTConnectionHasObjectNotification object:connection];
	}
	return self;
}

- (JKChatMessage *)sendMessage:(OOTMessage *)message onChat:(JKChat *)theChat {
	[connection writeObject:message];
	JKChatMessage * aMessage = [JKChatMessage messageWithSource:JKChatMessageSourceLocal message:message];
	[[theChat messages] addObject:aMessage];
	return aMessage;
}

- (void)stopHandling {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:connection];
}

- (void)newChat:(NSString *)buddyName {
	JKChat * chat = [JKChat chatWithAccount:account buddyName:[buddyName lowercaseString]];
	[chat setHandler:self];
	[[chat currentWindow] orderFront:self];
	if (![chat currentWindow]) {
		[chat setChatState:JKChatStateTwoWay];
		JKChatWindow * window = [JKChatWindow currentChatWindow];
		if (!window) {
			window = [[JKChatWindow alloc] initWithChat:chat];
			[window setReleasedWhenClosed:YES];
		} else {
			[window addChat:chat];
		}
		[chat setCurrentWindow:window];
		[window makeKeyAndOrderFront:self];
	}
}

- (void)connectionNewPacket:(NSNotification *)notification {
	OOTObject * object = [[notification userInfo] objectForKey:@"object"];
	if ([[object className] isEqual:@"mssg"]) {
		OOTMessage * message = [[OOTMessage alloc] initWithObject:object];
		JKChat * chat = [JKChat chatWithAccount:account buddyName:[message username]];
		[chat setHandler:self];
		JKChatMessage * chatMessage = [JKChatMessage messageWithSource:JKChatMessageSourceRemote message:message];
		[[chat messages] addObject:chatMessage];
		if ([chat chatState] == JKChatStateUninitialized) {
			NSRect screen = [[NSScreen mainScreen] visibleFrame];
			int activeCount = [JKChat chatCountOfState:JKChatStateNotAccepted];
			NSRect contentFrame = NSMakeRect(screen.size.width - 350, screen.size.height - 70 - (60 * activeCount), 300, 50);
			JKMessageWaitingView * contentView = [[JKMessageWaitingView alloc] initWithFrame:contentFrame];
			[contentView setBackgroundColor:nil];
			JKMessageWaitingWindow * waiting = [[JKMessageWaitingWindow alloc] initWithContentRect:contentFrame styleMask:(NSBorderlessWindowMask) backing:NSBackingStoreBuffered defer:NO];
			[waiting setTitle:@"Chat Invitation"];
			[waiting setContentView:contentView];
			[waiting setOpaque:NO];
			[waiting setBackgroundColor:[NSColor clearColor]];
			[waiting setDelegate:self];
			[waiting configureWindow:[message username]];
			[chat setCurrentWindow:waiting];
			[chat setChatState:JKChatStateNotAccepted];
			[waiting makeKeyAndOrderFront:self];
			[waiting setChat:chat];
			[contentView release];
		} else {
			NSWindow * window = [chat currentWindow];
			if ([window isKindOfClass:[JKChatWindow class]]) {
				JKChatWindowContent * content = [(JKChatWindow *)window content];
				if ([content currentChat] == chat) {
					[[content chatView] addMessage:chatMessage];
				}
			} else if ([window isKindOfClass:[JKChatPreviewWindow class]]) {
				JKChatView * chatView = [(JKChatPreviewWindow *)window chatView];
				[chatView addMessage:chatMessage];
			}
		}
		[message release];
	}
}

#pragma mark Message Waiting Window

- (void)messageWaitingWindowClicked:(JKMessageWaitingWindow *)sender {
	NSRect contentFrame = [[sender contentView] frame];
	contentFrame.size.height += 200;
	JKChat * theChat = [sender chat];
	JKChatPreviewWindow * chatWindow = [[JKChatPreviewWindow alloc] initPendingAcceptance:contentFrame];
	[chatWindow setTitle:[theChat buddyName]];
	[[chatWindow standardWindowButton:NSWindowCloseButton] setHidden:NO];
	[[chatWindow standardWindowButton:NSWindowCloseButton] setEnabled:YES];
	
	NSRect originalFrame = chatWindow.frame;
	
	[chatWindow setChat:theChat];
	[theChat setChatState:JKChatStateViewOnly];
	[theChat setCurrentWindow:chatWindow];
	
	float theDifference = [chatWindow frame].size.height - [sender frame].size.height;
	originalFrame.origin.x = sender.frame.origin.x;
	originalFrame.origin.y = sender.frame.origin.y - theDifference;
	
	[chatWindow setFrame:NSMakeRect(originalFrame.origin.x, originalFrame.origin.y + theDifference, originalFrame.size.width, [sender frame].size.height) display:YES];
	[sender orderOut:self];
	[chatWindow makeKeyAndOrderFront:self];
	[chatWindow setFrame:originalFrame display:YES animate:YES];
}

- (void)messageWaitingWindowClosed:(JKMessageWaitingWindow *)sender {
	
}

#pragma mark Dealloc

- (void)dealloc {
	[account release];
    [super dealloc];
}

@end
