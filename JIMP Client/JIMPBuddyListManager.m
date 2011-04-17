//
//  JIMPBuddyListManager.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JIMPBuddyListManager.h"

@interface JIMPBuddyListManager (private)

- (void)connectionNewPacket:(NSNotification *)notification;
- (void)connectionDidClose:(NSNotification *)notification;

@end

@implementation JIMPBuddyListManager

@synthesize delegate;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithConnection:(OOTConnection *)aConnection {
	if ((self = [super init])) {
		connection = [aConnection retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionNewPacket:) name:OOTConnectionHasObjectNotification object:connection];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionDidClose:) name:OOTConnectionClosedNotification object:connection];
	}
	return self;
}


- (BOOL)getBuddylist {
	if (!connection) return NO;
	if (![connection isOpen]) return NO;
	NSData * blankData = [[NSData alloc] init];
	OOTObject * get = [[OOTObject alloc] initWithName:@"gbst" data:blankData];
	BOOL sent = [connection writeObject:get];
	[get release];
	[blankData release];
	return sent;
}


- (BOOL)insertBuddy:(NSString *)buddy group:(NSString *)group index:(int)index; {
	if (!connection) return NO;
	if (![connection isOpen]) return NO;
	OOTBuddy * buddyObject = [[OOTBuddy alloc] initWithScreenname:[buddy lowercaseString] groupName:group];
	OOTInsertBuddy * insert = [[OOTInsertBuddy alloc] initWithIndex:index buddy:buddyObject];
	BOOL sent = [connection writeObject:insert];
	[insert release];
	[buddyObject release];
	return sent;
}


- (BOOL)insertGroup:(NSString *)group index:(int)index {
	if (!connection) return NO;
	if (![connection isOpen]) return NO;
	OOTInsertGroup * insert = [[OOTInsertGroup alloc] initWithIndex:index group:group];
	BOOL sent = [connection writeObject:insert];
	[insert release];
	return sent;
}


- (BOOL)deleteBuddy:(NSString *)buddy {
	if (!connection) return NO;
	if (![connection isOpen]) return NO;
	OOTDeleteBuddy * delete = [[OOTDeleteBuddy alloc] initWithBuddyName:[buddy lowercaseString]];
	BOOL sent = [connection writeObject:delete];
	[delete release];
	return sent;
}


- (BOOL)deleteGroup:(NSString *)group {
	if (!connection) return NO;
	if (![connection isOpen]) return NO;
	OOTDeleteGroup * delete = [[OOTDeleteGroup alloc] initWithGroupName:group];
	BOOL sent = [connection writeObject:delete];
	[delete release];
	return sent;
}

- (void)stopManaging {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:connection];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionClosedNotification object:connection];
	[connection release];
	connection = nil;
}

#pragma mark Private

- (void)connectionNewPacket:(NSNotification *)notification {
	OOTObject * object = [[notification userInfo] objectForKey:@"object"];
	if ([[object className] isEqual:@"blst"]) {
		OOTBuddyList * buddyListObj = [[OOTBuddyList alloc] initWithObject:object];
		BuddyList * buddyList = [[BuddyList alloc] initWithBuddyList:buddyListObj];
		[BuddyList setSharedBuddyList:buddyList];
		[delegate buddyListUpdated:[BuddyList sharedBuddyList]];
		[buddyList release];
		[buddyListObj release];
	} else if ([[object className] isEqual:@"isrt"]) {
		OOTInsertBuddy * buddyInsert = [[OOTInsertBuddy alloc] initWithObject:object];
		if (!buddyInsert)
			return;
		if ([BuddyList handleInsert:buddyInsert]) {
			[delegate buddyListUpdated:[BuddyList sharedBuddyList]];
		} else {
			NSLog(@"Buddy list modification failed: add");
		}
		[buddyInsert release];
	} else if ([[object className] isEqual:@"irtg"]) {
		OOTInsertGroup * groupInsert = [[OOTInsertGroup alloc] initWithObject:object];
		if (!groupInsert)
			return;
		if ([BuddyList handleInsertG:groupInsert]) {
			[delegate buddyListUpdated:[BuddyList sharedBuddyList]];
		} else {
			NSLog(@"Buddy list modification failed: add group");
		}
		[groupInsert release];
	} else if ([[object className] isEqual:@"delb"]) {
		OOTDeleteBuddy * buddyDelete = [[OOTDeleteBuddy alloc] initWithObject:object];
		if (!buddyDelete)
			return;
		if ([BuddyList handleDelete:buddyDelete]) {
			[delegate buddyListUpdated:[BuddyList sharedBuddyList]];
		} else {
			NSLog(@"Buddy list modification failed: delete buddy");
		}
		[buddyDelete release];
	} else if ([[object className] isEqual:@"delg"]) {
		OOTDeleteGroup * groupDelete = [[OOTDeleteGroup alloc] initWithObject:object];
		if (!groupDelete)
			return;
		if ([BuddyList handleDeleteG:groupDelete]) {
			[delegate buddyListUpdated:[BuddyList sharedBuddyList]];
		} else {
			NSLog(@"Buddy list modification failed: delete group");
		}
		[groupDelete release];
	}
}
- (void)connectionDidClose:(NSNotification *)notification {
	[self stopManaging];
}

- (void)dealloc {
	if (connection) {
		[self stopManaging];
	}
    [super dealloc];
}

@end
