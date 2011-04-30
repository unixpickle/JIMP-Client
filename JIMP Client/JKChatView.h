//
//  JKChatView.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "JKChat.h"
#import "JKChatMessage.h"


@interface JKChatView : NSView {
    JKChat * chat;
	WebView * chatWebView;
}

@property (nonatomic, assign) JKChat * chat;

- (id)initWithFrame:(NSRect)frameRect chat:(JKChat *)chat;

/**
 * Create the display for the messages that are already
 * in the chat.
 */
- (void)initializeFromChat;

/**
 * Add a message that has already been added to the chat,
 * appending to the content of the window.  This will not
 * change the chat in any way.
 * @param aMessage the message object to append to the end
 * of the chat view.
 */
- (void)addMessage:(JKChatMessage *)aMessage;

- (void)webViewDone:(NSNotification *)notification;

@end
