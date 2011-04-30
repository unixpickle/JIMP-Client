//
//  JKMessageHandler.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChat.h"
#import "JKChatMessage.h"
#import "OOTConnection.h"

#import "JKMessageWaitingWindow.h"
#import "JKMessageWaitingView.h"
#import "JKChatPreviewWindow.h"
#import "JKChatWindow.h"

@interface JKMessageHandler : NSObject <JKMessageWaitingWindowDelegate> {
    NSString * account;
	OOTConnection * connection;
}

@property (readonly) NSString * account;
@property (readonly) OOTConnection * connection;

- (id)initWithConnection:(OOTConnection *)connection account:(NSString *)account;

- (void)newChat:(NSString *)buddyName;
- (JKChatMessage *)sendMessage:(OOTMessage *)message onChat:(JKChat *)theChat;
- (void)stopHandling;

@end
