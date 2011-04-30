//
//  JKChatWindowTap.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChat.h"
#import "NSTextField+Label.h"
#import "JKChatWindowTabImages.h"
#import "NSView+Translate.h"

@class JKChatWindow;
@class JKChatWindowTab;

#define JKChatWindowTabHeight 22
#define JKChatWindowTabWidth 180
#define JKChatWindowTabMinWidth 120

@protocol JKChatWindowTabDelegate <NSObject>

@optional
- (void)chatWindowTabClicked:(JKChatWindowTab *)tab;
- (void)chatWindowTabClosed:(JKChatWindowTab *)tab;

@end

@interface JKChatWindowTab : NSView {
	JKChat * chat;
	JKChatWindow * chatWindow;
	JKChatWindowTabImages images;
	NSTextField * buddyTitle;
	float tabWidth;
	BOOL isSelected;
	id<JKChatWindowTabDelegate> delegate;
}

@property (nonatomic, retain) JKChat * chat;
@property (nonatomic, assign) JKChatWindow * chatWindow;
@property (nonatomic, retain) NSTextField * buddyTitle;
@property (readwrite) float tabWidth;
@property (readonly) BOOL isSelected;
@property (assign) id<JKChatWindowTabDelegate> delegate;

/**
 * Sizes the chat tab to fit the text of the user with the person
 * from the chat.
 * @return Returns YES if the tab fits the text, no if the text was too large
 * or small.
 */

- (BOOL)sizeToFit:(float)suggestedWidth;

- (void)setSelected:(BOOL)flag;
- (void)drawRectUnclosable:(NSRect)aRect;

@end
