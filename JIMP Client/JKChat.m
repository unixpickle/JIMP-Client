//
//  JKChat.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChat.h"
#import "JKMessageHandler.h"

@interface JKChat (private)

+ (NSMutableArray *)chatsCache;

@end

@implementation JKChat

@synthesize account;
@synthesize buddyName;
@synthesize currentWindow;
@synthesize chatState;
@synthesize messages;
@synthesize handler;

+ (int)chatCountOfState:(JKChatState)state {
	int counter = 0;
	NSMutableArray * chats = [JKChat chatsCache];
	for (JKChat * chat in chats) {
		if ([chat chatState] == state) counter++;
	}
	return counter;
}

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
		account = @"";
		buddyName = @"";
		currentWindow = nil;
    }
    return self;
}

- (id)initWithAccount:(NSString *)_account buddyName:(NSString *)_buddyName {
	if ((self = [super init])) {
		account = [_account retain];
		buddyName = [_buddyName retain];
		currentWindow = nil;
		chatState = JKChatStateUninitialized;
		messages = [[NSMutableArray alloc] init];
	}
	return self;
}

+ (JKChat *)chatWithAccount:(NSString *)_account buddyName:(NSString *)_buddyName {
	NSMutableArray * chats = [JKChat chatsCache];
	NSString * acctLower = [_account lowercaseString];
	NSString * buddLower = [_buddyName lowercaseString];
	for (JKChat * chat in chats) {
		if ([[[chat account] lowercaseString] isEqual:acctLower] && [[[chat buddyName] lowercaseString] isEqual:buddLower]) {
			return [[chat retain] autorelease];
		}
	}
	JKChat * newChat = [[JKChat alloc] initWithAccount:_account buddyName:_buddyName];
	[chats addObject:newChat];
	return [newChat autorelease];
}

- (void)endChat {
	NSMutableArray * chats = [JKChat chatsCache];
	NSString * acctLower = [account lowercaseString];
	NSString * buddLower = [buddyName lowercaseString];
	for (int i = 0; i < [chats count]; i++) {
		JKChat * chat = [chats objectAtIndex:i];
		if ([[[chat account] lowercaseString] isEqual:acctLower] && [[[chat buddyName] lowercaseString] isEqual:buddLower]) {
			[chats removeObjectAtIndex:i];
			return;
		}
	}
}

- (void)dealloc {
	[account release];
	[buddyName release];
	[messages release];
    [super dealloc];
}

+ (NSMutableArray *)chatsCache {
	static NSMutableArray * chats = nil;
	if (!chats) {
		chats = [[NSMutableArray alloc] init];
	}
	return chats;
}

@end
