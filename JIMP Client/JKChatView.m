//
//  JKChatView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatView.h"

@interface JKChatView (private)

- (void)appendTagToBody:(NSString *)tagName innerHTML:(NSString *)innerHTML;

@end

@implementation JKChatView

@synthesize chat;

- (id)initWithFrame:(NSRect)frameRect chat:(JKChat *)aChat {
	if ((self = [super initWithFrame:frameRect])) {
		chat = aChat;
		chatWebView = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height) frameName:@"_current" groupName:@"monkey"];
		[self addSubview:chatWebView];
	}
	return self;
}

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
		chatWebView = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height) frameName:@"_current" groupName:@"monkey"];
		[self addSubview:chatWebView];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewDone:) name:WebViewProgressFinishedNotification object:chatWebView];
    }
    return self;
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	[chatWebView setFrame:self.bounds];
}

- (void)initializeFromChat {
	NSMutableString * theHTML = [NSMutableString stringWithString:@"<html><body style=\"font-face : arial;\"><basefont face=\"arial, verdana, courier\" size=\"4\">"];
	for (JKChatMessage * message in [chat messages]) {
		if ([message messageSource] == JKChatMessageSourceLocal) {
			// we sent it
			[theHTML appendFormat:@"<div style=\"word-wrap : break-word; font-family : arial;\"><font color=\"red\" face=\"arial\">Me: </font>%@<br /></div>", [[message message] message]];
		} else {
			[theHTML appendFormat:@"<div style=\"word-wrap : break-word; font-family : arial;\"><font color=\"blue\" face=\"arial\">%@: </font>%@<br /></div>", [[message message] username], [[message message] message]];
		}
	}
	[theHTML appendFormat:@"</body></html>"];
	[[chatWebView mainFrame] loadHTMLString:theHTML baseURL:[NSURL URLWithString:@"file:///"]];
	[chatWebView performSelector:@selector(scrollToEndOfDocument:) withObject:self afterDelay:0.0];
}

- (void)appendTagToBody:(NSString *)tagName innerHTML:(NSString *)innerHTML {
    DOMNodeList * bodyNodeList = [[[chatWebView mainFrame] DOMDocument] getElementsByTagName:@"body"];	
    DOMHTMLElement * bodyNode = (DOMHTMLElement *) [bodyNodeList item:0];
	DOMHTMLElement * newNode = (DOMHTMLElement *)[[[chatWebView mainFrame] DOMDocument] createElement:tagName];
    [newNode setInnerHTML:innerHTML];
    [bodyNode appendChild:newNode];
}

- (void)addMessage:(JKChatMessage *)message {
	if ([message messageSource] == JKChatMessageSourceLocal) {
		// we sent it
		[self appendTagToBody:@"div" innerHTML:[NSString stringWithFormat:@"<div style=\"word-wrap : break-word; font-family : arial;\"><font color=\"red\">Me: </font>%@<br /></div>", [[message message] message]]];
	} else {
		NSString * messageTxt = [[message message] message];
		[self appendTagToBody:@"div" innerHTML:[NSString stringWithFormat:@"<div style=\"word-wrap : break-word; font-family : arial;\"><font color=\"blue\">%@: </font>%@<br /></div>", [chat buddyName], messageTxt]];
	}
	[chatWebView performSelector:@selector(scrollToEndOfDocument:) withObject:self afterDelay:0.01];
	[chatWebView performSelector:@selector(scrollToEndOfDocument:) withObject:self afterDelay:0.2];
}

- (void)webViewDone:(NSNotification *)notification {
	[chatWebView performSelector:@selector(scrollToEndOfDocument:) withObject:self afterDelay:0.1];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:WebViewProgressFinishedNotification object:chatWebView];
	[chatWebView release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor whiteColor] set];
	NSRectFill(dirtyRect);
}

@end
