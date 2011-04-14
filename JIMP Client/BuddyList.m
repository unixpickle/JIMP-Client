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

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithBuddyList:(OOTBuddyList *)buddyList {
	if ((self = [super init])) {
		NSMutableArray * groupList = [NSMutableArray array];
		for (OOTText * group in [buddyList groups]) {
			NSString * groupName = [group textValue];
			NSMutableArray * buddiesInGroup = [NSMutableArray array];
			for (OOTBuddy * buddy in [buddyList buddies]) {
				if ([[buddy groupName] isEqual:groupName]) {
					[buddiesInGroup addObject:[buddy screenName]];
				}
			}
			NSDictionary * groupObject = [NSDictionary dictionaryWithObjectsAndKeys:buddiesInGroup, @"buddies",
																		groupName, @"name", nil];
			[groupList addObject:groupObject];
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
	if (group == [groups count]) return 0; // for now, no offline
	NSArray * buddies = [[groups objectAtIndex:group] objectForKey:@"buddies"];
	int count = 0;
	// do a loop do exclude the offline noobs.
	for (NSString * sn in buddies) {
		count += 1;
	}
	return count;
}
- (NSString *)itemAtIndex:(int)index ofGroup:(int)groupIndex {
	if (groupIndex == [groups count]) return nil; // for now, no offline
	NSArray * buddies = [[groups objectAtIndex:groupIndex] objectForKey:@"buddies"];
	int count = 0;
	// do a loop do exclude the offline noobs.
	for (NSString * sn in buddies) {
		if (count == index) return sn;
		count += 1;
	}
	return nil;
}

- (void)dealloc {
	[groups release];
    [super dealloc];
}

@end
