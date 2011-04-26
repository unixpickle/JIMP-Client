//
//  JKMessageWaitingWindow.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JKChat.h"

@class JKMessageWaitingWindow;

@protocol JKMessageWaitingWindowDelegate

- (void)messageWaitingWindowClicked:(JKMessageWaitingWindow *)sender;
- (void)messageWaitingWindowClosed:(JKMessageWaitingWindow *)sender;

@end

@interface JKMessageWaitingWindow : NSWindow {
	JKChat * chat;
    NSTextField * alertText;
	NSPoint initialLocation;
	BOOL wasDragged;
	id <JKMessageWaitingWindowDelegate> delegate;
}

@property (nonatomic, assign) JKChat * chat;
@property (nonatomic, retain) NSTextField * alertText;
@property (readwrite) NSPoint initialLocation;
@property (nonatomic, assign) id <JKMessageWaitingWindowDelegate> delegate;

- (void)configureWindow:(NSString *)aUser;

@end
