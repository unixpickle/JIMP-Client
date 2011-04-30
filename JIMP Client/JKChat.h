//
//  JKChat.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChatMessage.h"

typedef enum {
	JKChatStateUninitialized,		// the chat has not been started by either user.
	JKChatStatePendingAcceptance,	// they have IMed us, we have not accepted or acknowleged them.
	JKChatStateViewOnly,			// the IM has been acknowleged, but the user must click accept or deny to send a message.
	JKChatStateNotAccepted,			// we have IMed them, they have not accepted or acknowleged us.
	JKChatStateTwoWay				// both people are chatting, both windows are full sized.
} JKChatState;

@class JKMessageHandler;

@interface JKChat : NSObject {
	NSString * account;
	NSString * buddyName;
	NSWindow * currentWindow;
	NSMutableArray * messages;
	JKMessageHandler * handler;
	JKChatState chatState;
}

@property (readonly) NSString * account;
@property (readonly) NSString * buddyName;
@property (nonatomic, assign) NSWindow * currentWindow;
@property (readwrite) JKChatState chatState;
@property (nonatomic, assign) JKMessageHandler * handler;
@property (nonatomic, readonly) NSMutableArray * messages;

+ (int)chatCountOfState:(JKChatState)state;


/**
 * Creates a new chat with defined parameters.
 */
- (id)initWithAccount:(NSString *)_account buddyName:(NSString *)_buddyName;

/**
 * Searches for an existing chat with an account and buddy.
 * @return if the chat exists, this returns that chat.  Otherwise, this
 * will return a new chat with the specified parameters, which will be
 * retained internally by JKChat.
 */
+ (JKChat *)chatWithAccount:(NSString *)_account buddyName:(NSString *)_buddyName;

/**
 * Releases/removes the chat from the saved chats cache.
 */
- (void)endChat;

@end
