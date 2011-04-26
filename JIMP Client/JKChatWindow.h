//
//  JKChatWindow.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChat.h"


@interface JKChatWindow : NSWindow {
    NSMutableArray * chats;
}

+ (JKChatWindow *)currentChatWindow;

- (id)initWithChat:(JKChat *)aChat;
- (NSArray *)chats;
- (void)addChat:(JKChat *)chat;

@end
