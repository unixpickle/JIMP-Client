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
+ (JKBuddyList **)sharedBuddyListAddress;

@end

@implementation JIMPBuddyListManager

@synthesize delegate;
@synthesize statusHandler;
@synthesize buddyList;

//+ (JKBuddyList **)sharedBuddyListAddress {
//	static JKBuddyList * list;
//	return &list;
//}
//
//+ (JKBuddyList *)sharedBuddyList {
//	return *[JIMPBuddyListManager sharedBuddyListAddress];
//}
//+ (void)setSharedBuddyList:(JKBuddyList *)aList {
//	[*[JIMPBuddyListManager sharedBuddyListAddress] autorelease];
//	*[JIMPBuddyListManager sharedBuddyListAddress] = [aList retain];
//}

#pragma mark Class

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

#pragma mark Changes

- (BOOL)handleInsert:(OOTInsertBuddy *)buddyInsert {
	OOTBuddyList * list = [buddyList buddyList];
	NSMutableArray * buddies = [NSMutableArray arrayWithArray:[list buddies]];
	NSMutableArray * groups = [NSMutableArray arrayWithArray:[list groups]];
	[buddies insertObject:[buddyInsert buddy] atIndex:[buddyInsert buddyIndex]];
	OOTBuddyList * newOOTList = [[OOTBuddyList alloc] initWithBuddies:buddies groups:groups];
	if (!newOOTList) {
		return NO;
	}
	JKBuddyList * blist = [[JKBuddyList alloc] initWithBuddyList:newOOTList statuses:[statusHandler allStatuses]];
	[self setBuddyList:blist];
	[blist release];
	[newOOTList release];
	return YES;
}
- (BOOL)handleInsertG:(OOTInsertGroup *)groupInsert {
	OOTBuddyList * list = [buddyList buddyList];
	NSMutableArray * buddies = [NSMutableArray arrayWithArray:[list buddies]];
	NSMutableArray * groups = [NSMutableArray arrayWithArray:[list groups]];
	[groups insertObject:[groupInsert groupName] atIndex:[groupInsert groupIndex]];
	OOTBuddyList * newOOTList = [[OOTBuddyList alloc] initWithBuddies:buddies groups:groups];
	if (!newOOTList) {
		return NO;
	}
	JKBuddyList * blist = [[JKBuddyList alloc] initWithBuddyList:newOOTList statuses:[statusHandler allStatuses]];
	[self setBuddyList:blist];
	[blist release];
	[newOOTList release];
	return YES;
}
- (BOOL)handleDelete:(OOTDeleteBuddy *)buddyDelete {
	NSString * deleteSN = [[buddyDelete screenName] lowercaseString];
	OOTBuddyList * list = [buddyList buddyList];
	NSMutableArray * buddies = [NSMutableArray arrayWithArray:[list buddies]];
	NSMutableArray * groups = [NSMutableArray arrayWithArray:[list groups]];
	for (int i = 0; i < [buddies count]; i++) {
		NSString * lowercaseSN = [[[buddies objectAtIndex:i] screenName] lowercaseString];
		if ([lowercaseSN isEqual:deleteSN]) {
			[buddies removeObjectAtIndex:i];
			break;
		}
	}
	OOTBuddyList * newOOTList = [[OOTBuddyList alloc] initWithBuddies:buddies groups:groups];
	if (!newOOTList) {
		return NO;
	}
	JKBuddyList * blist = [[JKBuddyList alloc] initWithBuddyList:newOOTList statuses:[statusHandler allStatuses]];
	[self setBuddyList:blist];
	[blist release];
	[newOOTList release];
	return YES;
}

- (BOOL)handleDeleteG:(OOTDeleteGroup *)groupDelete {
	OOTBuddyList * list = [buddyList buddyList];
	NSMutableArray * buddies = [NSMutableArray arrayWithArray:[list buddies]];
	NSMutableArray * groups = [NSMutableArray arrayWithArray:[list groups]];
	for (int i = 0; i < [groups count]; i++) {
		if ([[[groups objectAtIndex:i] textValue] isEqual:[groupDelete groupName]]) {
			[groups removeObjectAtIndex:i];
			break;
		}
	}
	for (int i = 0; i < [buddies count]; i++) {
		OOTBuddy * buddy = [buddies objectAtIndex:i];
		if ([[buddy groupName] isEqual:[groupDelete groupName]]) {
			[buddies removeObjectAtIndex:i];
			i -= 1;
		}
	}
	OOTBuddyList * newOOTList = [[OOTBuddyList alloc] initWithBuddies:buddies groups:groups];
	if (!newOOTList) {
		return NO;
	}
	JKBuddyList * blist = [[JKBuddyList alloc] initWithBuddyList:newOOTList statuses:[statusHandler allStatuses]];
	[self setBuddyList:blist];
	[blist release];
	[newOOTList release];
	return YES;
}

- (void)regenerateBuddyList {
	JKBuddyList * newList = [[JKBuddyList alloc] initWithBuddyList:[buddyList buddyList] statuses:[statusHandler allStatuses]];
	[self setBuddyList:newList];
	[newList release];
}

#pragma mark Private

- (void)connectionNewPacket:(NSNotification *)notification {
	NSAssert(statusHandler != nil, @"A JIMPBuddyListManager requires a status handler.");
	OOTObject * object = [[notification userInfo] objectForKey:@"object"];
	if ([[object className] isEqual:@"blst"]) {
		NSLog(@"Blist object.");
		OOTBuddyList * buddyListObj = [[OOTBuddyList alloc] initWithObject:object];
		/*
		Remove all of the statuses that we do not have in the buddy list.
		We will then initialize the buddy list, which will fetch all statuses.
		*/
		[statusHandler removeBuddyStatuses:[buddyListObj buddies]];
		
		JKBuddyList * aBuddyList = [[JKBuddyList alloc] initWithBuddyList:buddyListObj statuses:[statusHandler allStatuses]];
		[self setBuddyList:aBuddyList];
		[delegate buddyListUpdated:aBuddyList];
		
		[buddyList release];
		[buddyListObj release];
	} else if ([[object className] isEqual:@"isrt"]) {
		OOTInsertBuddy * buddyInsert = [[OOTInsertBuddy alloc] initWithObject:object];
		if (!buddyInsert)
			return;
		if ([self handleInsert:buddyInsert]) {
			[delegate buddyListUpdated:buddyList];
		} else {
			NSLog(@"Buddy list modification failed: add");
		}
		[buddyInsert release];
	} else if ([[object className] isEqual:@"irtg"]) {
		OOTInsertGroup * groupInsert = [[OOTInsertGroup alloc] initWithObject:object];
		if (!groupInsert)
			return;
		if ([self handleInsertG:groupInsert]) {
			[delegate buddyListUpdated:buddyList];
		} else {
			NSLog(@"Buddy list modification failed: add group");
		}
		[groupInsert release];
	} else if ([[object className] isEqual:@"delb"]) {
		OOTDeleteBuddy * buddyDelete = [[OOTDeleteBuddy alloc] initWithObject:object];
		if (!buddyDelete)
			return;
		if ([self handleDelete:buddyDelete]) {
			[delegate buddyListUpdated:buddyList];
		} else {
			NSLog(@"Buddy list modification failed: delete buddy");
		}
		[buddyDelete release];
	} else if ([[object className] isEqual:@"delg"]) {
		OOTDeleteGroup * groupDelete = [[OOTDeleteGroup alloc] initWithObject:object];
		if (!groupDelete)
			return;
		if ([self handleDeleteG:groupDelete]) {
			[delegate buddyListUpdated:buddyList];
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
	self.statusHandler = nil;
	if (connection) {
		[self stopManaging];
	}
    [super dealloc];
}

@end
