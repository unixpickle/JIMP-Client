//
//  JKChatWindow.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKChat.h"
#import "JKChatView.h"
#import "JKChatBottom.h"
#import "JKChatWindow.h"


@interface JKChatPreviewWindow : NSWindow <NSWindowDelegate> {
	JKChat * chat;
	NSButton * acceptButton;
	NSButton * declineButton;
	JKChatView * chatView;
	JKChatBottom * chatBottom;
}

/**
 * Set this to the chat that this window represents.
 */
@property (nonatomic, assign) JKChat * chat;

@property (nonatomic, retain) NSButton * acceptButton;
@property (nonatomic, retain) NSButton * declineButton;
@property (nonatomic, retain) JKChatView * chatView;
@property (nonatomic, retain) JKChatBottom * chatBottom;

- (id)initPendingAcceptance:(NSRect)contentRect;

@end
