//
//  BuddyList.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyList.h"


@interface BuddyList (private)

+ (BuddyList **)sharedBuddyListAddress;

@end

@implementation BuddyList

@synthesize buddyList;

#pragma mark Static Methods

+ (BuddyList **)sharedBuddyListAddress {
	static BuddyList * list;
	return &list;
}

+ (BuddyList *)sharedBuddyList {
	return *[BuddyList sharedBuddyListAddress];
}
+ (void)setSharedBuddyList:(BuddyList *)aList {
	[*[BuddyList sharedBuddyListAddress] autorelease];
	*[BuddyList sharedBuddyListAddress] = [aList retain];
}
+ (BOOL)handleInsert:(OOTInsertBuddy *)buddyInsert {
	BuddyList * buddyList = [BuddyList sharedBuddyList];
	OOTBuddyList * list = [buddyList buddyList];
	NSMutableArray * buddies = [NSMutableArray arrayWithArray:[list buddies]];
	NSMutableArray * groups = [NSMutableArray arrayWithArray:[list groups]];
	[buddies insertObject:[buddyInsert buddy] atIndex:[buddyInsert buddyIndex]];
	OOTBuddyList * newOOTList = [[OOTBuddyList alloc] initWithBuddies:buddies groups:groups];
	if (!newOOTList) {
		return NO;
	}
	BuddyList * blist = [[BuddyList alloc] initWithBuddyList:newOOTList];
	[BuddyList setSharedBuddyList:blist];
	[blist release];
	[newOOTList release];
	return YES;
}
+ (BOOL)handleInsertG:(OOTInsertGroup *)groupInsert {
	BuddyList * buddyList = [BuddyList sharedBuddyList];
	OOTBuddyList * list = [buddyList buddyList];
	NSMutableArray * buddies = [NSMutableArray arrayWithArray:[list buddies]];
	NSMutableArray * groups = [NSMutableArray arrayWithArray:[list groups]];
	[groups insertObject:[groupInsert groupName] atIndex:[groupInsert groupIndex]];
	OOTBuddyList * newOOTList = [[OOTBuddyList alloc] initWithBuddies:buddies groups:groups];
	if (!newOOTList) {
		return NO;
	}
	BuddyList * blist = [[BuddyList alloc] initWithBuddyList:newOOTList];
	[BuddyList setSharedBuddyList:blist];
	[blist release];
	[newOOTList release];
	return YES;
}
+ (BOOL)handleDelete:(OOTDeleteBuddy *)buddyDelete {
	NSString * deleteSN = [[buddyDelete screenName] lowercaseString];
	BuddyList * buddyList = [BuddyList sharedBuddyList];
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
	BuddyList * blist = [[BuddyList alloc] initWithBuddyList:newOOTList];
	[BuddyList setSharedBuddyList:blist];
	[blist release];
	[newOOTList release];
	return YES;
}

+ (BOOL)handleDeleteG:(OOTDeleteGroup *)groupDelete {
	BuddyList * buddyList = [BuddyList sharedBuddyList];
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
	BuddyList * blist = [[BuddyList alloc] initWithBuddyList:newOOTList];
	[BuddyList setSharedBuddyList:blist];
	[blist release];
	[newOOTList release];
	return YES;
}

+ (void)regenerateBuddyList {
	BuddyList * newList = [[BuddyList alloc] initWithBuddyList:[[BuddyList sharedBuddyList] buddyList]];
	[BuddyList setSharedBuddyList:newList];
	[newList release];
}

#pragma mark Buddy List Methods

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithBuddyList:(OOTBuddyList *)aBuddyList {
	if ((self = [super init])) {
		offline = [[NSMutableArray alloc] init];
		NSMutableArray * groupList = [NSMutableArray array];
		for (OOTText * group in [aBuddyList groups]) {
			NSString * groupName = [group textValue];
			NSMutableArray * buddiesInGroup = [NSMutableArray array];
			for (OOTBuddy * buddy in [aBuddyList buddies]) {
				if ([[buddy groupName] isEqual:groupName]) {
					[buddiesInGroup addObject:[buddy screenName]];
				}
			}
			NSDictionary * groupObject = [NSDictionary dictionaryWithObjectsAndKeys:buddiesInGroup, @"buddies",
																		groupName, @"name", nil];
			[groupList addObject:groupObject];
			buddyList = [aBuddyList retain];
		}
		JIMPStatusHandler * handler = *[JIMPStatusHandler firstStatusHandler];
		for (OOTBuddy * buddy in [aBuddyList buddies]) {
			OOTStatus * status = [handler statusMessageForBuddy:[buddy screenName]];
			if (!status || [status statusType] == 'n') {
				[offline addObject:[[buddy screenName] lowercaseString]];
			}
		}
		groups = [[NSArray alloc] initWithArray:groupList];
	}
	return self;
}

- (NSArray *)groupNames {
	NSMutableArray * groupNames = [NSMutableArray array];
	for (NSDictionary * groupInfo in groups) {
		[groupNames addObject:[groupInfo objectForKey:@"name"]];
	}
	return groupNames;
}

- (int)numberOfGroups {
	return (int)([groups count] + 1);
}
- (NSString *)groupTitle:(int)index {
	if (index == [groups count]) return @"Offline";
	else {
		return [[groups objectAtIndex:index] objectForKey:@"name"];
	}
}
- (int)numberOfItems:(int)group {
	if (group == [groups count]) return [offline count]; // for now, no offline
	NSArray * buddies = [[groups objectAtIndex:group] objectForKey:@"buddies"];
	int count = 0;
	// do a loop do exclude the offline noobs.
	for (NSString * sn in buddies) {
		if (![offline containsObject:[sn lowercaseString]]) count += 1;
	}
	return count;
}
- (NSString *)itemAtIndex:(int)index ofGroup:(int)groupIndex {
	if (groupIndex == [groups count]) return [offline objectAtIndex:index]; // for now, no offline
	NSArray * buddies = [[groups objectAtIndex:groupIndex] objectForKey:@"buddies"];
	int count = 0;
	// do a loop do exclude the offline noobs.
	for (NSString * sn in buddies) {
		if (![offline containsObject:[sn lowercaseString]]) {
			if (count == index) return sn;
			count += 1;
		}
	}
	return nil;
}

- (void)dealloc {
	[offline release];
	[groups release];
	[buddyList release];
    [super dealloc];
}

@end
