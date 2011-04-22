//
//  BuddyList.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKBuddyList.h"


@implementation JKBuddyList

@synthesize buddyList;

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
		/*
		 Filter out the buddies that are offline, moving them
		 to the temporary Offline group.
		 */
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
	if (group == [groups count]) return [offline count];
	NSArray * buddies = [[groups objectAtIndex:group] objectForKey:@"buddies"];
	int count = 0;
	for (NSString * sn in buddies) {
		if (![offline containsObject:[sn lowercaseString]]) count += 1;
	}
	return count;
}
- (NSString *)itemAtIndex:(int)index ofGroup:(int)groupIndex {
	if (groupIndex == [groups count]) return [offline objectAtIndex:index];
	NSArray * buddies = [[groups objectAtIndex:groupIndex] objectForKey:@"buddies"];
	int count = 0;
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
