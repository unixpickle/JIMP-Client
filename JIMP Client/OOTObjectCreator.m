//
//  OOTObjectCreator.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTObjectCreator.h"


@implementation OOTObjectCreator

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (OOTObject *)objectSubclassForObject:(OOTObject *)anObject {
	if ([[anObject className] isEqual:@"budd"]) {
		OOTBuddy * buddy = [[OOTBuddy alloc] initWithObject:anObject];
		return [buddy autorelease];
	} else if ([[anObject className] isEqual:@"acco"]) {
		OOTAccount * account = [[OOTAccount alloc] initWithObject:anObject];
		return [account autorelease];
	} else if ([[anObject className] isEqual:@"blst"]) {
		OOTBuddyList * buddyList = [[OOTBuddyList alloc] initWithObject:anObject];
		return [buddyList autorelease];
	} else if ([[anObject className] isEqual:@"text"]) {
		OOTText * text = [[OOTText alloc] initWithObject:anObject];
		return [text autorelease];
	} else if ([[anObject className] isEqual:@"list"]) {
		OOTArray * array = [[OOTArray alloc] initWithObject:anObject];
		return [array autorelease];
	} else if ([[anObject className] isEqual:@"isrt"]) {
		OOTInsertBuddy * buddyInsert = [[OOTInsertBuddy alloc] initWithObject:anObject];
		return [buddyInsert autorelease];
	} else if ([[anObject className] isEqual:@"irtg"]) {
		OOTInsertGroup * groupInsert = [[OOTInsertGroup alloc] initWithObject:anObject];
		return [groupInsert autorelease];
	} else if ([[anObject className] isEqual:@"delg"]) {
		OOTDeleteGroup * groupDelete = [[OOTDeleteGroup alloc] initWithObject:anObject];
		return [groupDelete autorelease];
	} else if ([[anObject className] isEqual:@"delb"]) {
		OOTDeleteBuddy * buddyDelete = [[OOTDeleteBuddy alloc] initWithObject:anObject];
		return [buddyDelete autorelease];
	}
	return anObject;
}

- (void)dealloc {
    [super dealloc];
}

@end
