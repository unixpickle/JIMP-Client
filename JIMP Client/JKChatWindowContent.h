//
//  JKChatWindowContent.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChatView.h"


@interface JKChatWindowContent : NSView <NSTextFieldDelegate> {
    JKChatView * chatView;
	NSTextField * messageField;
	JKChat * currentChat;
}

@property (readonly) JKChat * currentChat;
@property (nonatomic, retain) JKChatView * chatView;
@property (nonatomic, retain) NSTextField * messageField;

- (void)switchToChat:(JKChat *)currentChat;
- (void)sendMessage:(id)sender;

@end
