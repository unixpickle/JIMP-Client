//
//  JKChatWindow.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChat.h"
#import "JKChatWindowTab.h"
#import "JKChatWindowTabMover.h"
#import "JKChatWindowTitle.h"
#import "JKChatWindowContent.h"
#import "JKChatWindowContentView.h"
#import "JKChatWindowDragState.h"


@interface JKChatWindow : NSWindow <JKChatWindowTabDelegate, JKChatWindowTabMoverDelegate> {
    NSMutableArray * chatTabs;
	JKChatWindowTitle * windowControls;
	JKChatWindowContent * content;
	JKChatWindowDragState dragState;
	
	JKChatWindowTabMover * leftMover;
	JKChatWindowTabMover * rightMover;
}

+ (JKChatWindow *)currentChatWindow;
@property (readonly) JKChatWindowContent * content;

- (id)initWithChat:(JKChat *)aChat;
- (NSArray *)chatTabs;
- (void)addChat:(JKChat *)chat;
- (void)layoutTabs;

@end
