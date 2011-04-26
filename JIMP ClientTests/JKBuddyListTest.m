//
//  JKBuddyListTest.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKBuddyListTest.h"


@implementation JKBuddyListTest

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)testInitialize {
	OOTBuddy * alex = [[OOTBuddy alloc] initWithScreenname:@"alex" groupName:@"Buddies"];
	OOTBuddy * jon = [[OOTBuddy alloc] initWithScreenname:@"jon" groupName:@"Buddies"];
	OOTText * buddies = [[OOTText alloc] initWithText:@"Buddies"];
	OOTStatus * alexStatus = [[OOTStatus alloc] initWithMessage:@"Hey!" owner:@"alex" type:'o'];
	NSArray * buddyArray = [NSArray arrayWithObjects:alex, jon, nil];
	NSArray * groupArray = [NSArray arrayWithObject:buddies];
	NSArray * statuses = [NSArray arrayWithObject:alexStatus];
	[alex release];
	[jon release];
	[buddies release];
	[alexStatus release];
	OOTBuddyList * buddyList = [[OOTBuddyList alloc] initWithBuddies:buddyArray groups:groupArray];
	JKBuddyList * testList = [[JKBuddyList alloc] initWithBuddyList:buddyList statuses:statuses];
	STAssertEquals([testList buddyList], buddyList, @"JKBuddyList didn't save the OOTBuddyList.");
	[buddyList release];
	[testList release];
}
- (void)testGroups {
	OOTBuddy * alex = [[OOTBuddy alloc] initWithScreenname:@"alex" groupName:@"Buddies"];
	OOTBuddy * jon = [[OOTBuddy alloc] initWithScreenname:@"jon" groupName:@"Buddies"];
	OOTText * buddies = [[OOTText alloc] initWithText:@"Buddies"];
	OOTStatus * alexStatus = [[OOTStatus alloc] initWithMessage:@"Hey!" owner:@"alex" type:'o'];
	NSArray * buddyArray = [NSArray arrayWithObjects:alex, jon, nil];
	NSArray * groupArray = [NSArray arrayWithObject:buddies];
	NSArray * statuses = [NSArray arrayWithObject:alexStatus];
	[alex release];
	[jon release];
	[buddies release];
	[alexStatus release];
	OOTBuddyList * buddyList = [[OOTBuddyList alloc] initWithBuddies:buddyArray groups:groupArray];
	JKBuddyList * testList = [[JKBuddyList alloc] initWithBuddyList:buddyList statuses:statuses];
	STAssertEquals([testList numberOfGroups], 2, @"JKBuddyList doesn't have two groups.");
	if (![[testList groupTitle:0] isEqual:@"Buddies"]) {
		STFail(@"OOTBuddyList didn't order the groups correctly.");
	}
	if (![[testList groupTitle:1] isEqual:@"Offline"]) {
		STFail(@"OOTBuddyList didn't add the Offline group correctly.");
	}
	[buddyList release];
	[testList release];
}
- (void)testBuddies {
	OOTBuddy * alex = [[OOTBuddy alloc] initWithScreenname:@"alex" groupName:@"Buddies"];
	OOTBuddy * jon = [[OOTBuddy alloc] initWithScreenname:@"jon" groupName:@"Buddies"];
	OOTText * buddies = [[OOTText alloc] initWithText:@"Buddies"];
	OOTStatus * alexStatus = [[OOTStatus alloc] initWithMessage:@"Hey!" owner:@"alex" type:'o'];
	NSArray * buddyArray = [NSArray arrayWithObjects:alex, jon, nil];
	NSArray * groupArray = [NSArray arrayWithObject:buddies];
	NSArray * statuses = [NSArray arrayWithObject:alexStatus];
	[alex release];
	[jon release];
	[buddies release];
	[alexStatus release];
	OOTBuddyList * buddyList = [[OOTBuddyList alloc] initWithBuddies:buddyArray groups:groupArray];
	JKBuddyList * testList = [[JKBuddyList alloc] initWithBuddyList:buddyList statuses:statuses];
	STAssertEquals([testList numberOfGroups], 2, @"JKBuddyList doesn't have two groups.");
	if (![[testList itemAtIndex:0 ofGroup:0] isEqual:@"alex"]) {
		STFail(@"OOTBuddyList didn't insert alex properly.");
	}
	if (![[testList itemAtIndex:0 ofGroup:1] isEqual:@"jon"]) {
		STFail(@"OOTBuddyList didn't insert jon properly.");
	}
	[buddyList release];
	[testList release];
}
- (void)testDestroy {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	OOTBuddy * alex = [[OOTBuddy alloc] initWithScreenname:@"alex" groupName:@"Buddies"];
	OOTBuddy * jon = [[OOTBuddy alloc] initWithScreenname:@"jon" groupName:@"Buddies"];
	OOTText * buddies = [[OOTText alloc] initWithText:@"Buddies"];
	OOTStatus * alexStatus = [[OOTStatus alloc] initWithMessage:@"Hey!" owner:@"alex" type:'o'];
	NSArray * buddyArray = [NSArray arrayWithObjects:alex, jon, nil];
	NSArray * groupArray = [NSArray arrayWithObject:buddies];
	NSArray * statuses = [NSArray arrayWithObject:alexStatus];
	[alex release];
	[jon release];
	[buddies release];
	[alexStatus release];
	OOTBuddyList * buddyList = [[OOTBuddyList alloc] initWithBuddies:buddyArray groups:groupArray];
	JKBuddyList * testList = [[JKBuddyList alloc] initWithBuddyList:buddyList statuses:statuses];
	[pool drain];
	pool = [[NSAutoreleasePool alloc] init];
	if ([buddyList retainCount] != 2) {
		STFail(@"OOTBuddyList retain count was not 2, but %d", [buddyList retainCount]);
	}
	if ([testList retainCount] != 1) {
		STFail(@"JKBuddyList retain count was not 2, but %d", [testList retainCount]);
	}
	[testList release];
	[pool drain];
	if ([buddyList retainCount] != 1) {
		STFail(@"OOTBuddyList retain count was not 1, but %d", [buddyList retainCount]);
	}
	[buddyList release];
}

- (void)dealloc {
    [super dealloc];
}

@end
