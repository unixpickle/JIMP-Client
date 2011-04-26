//
//  JKMessageHandler.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChat.h"
#import "OOTConnection.h"
#import "OOTMessage.h"
#import "JKMessageWaitingWindow.h"
#import "JKMessageWaitingView.h"
#import "JKChatPreviewWindow.h"

@interface JKMessageHandler : NSObject <JKMessageWaitingWindowDelegate> {
    NSString * account;
	OOTConnection * connection;
}

@property (readonly) NSString * account;
@property (readonly) OOTConnection * connection;

- (id)initWithConnection:(OOTConnection *)connection account:(NSString *)account;

- (void)sendMessage:(OOTMessage *)message;
- (void)stopHandling;

@end
