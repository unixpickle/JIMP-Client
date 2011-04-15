//
//  OOTBuddyList.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTBuddyList.h"

@interface OOTBuddyList (private)

- (id)initializeBuddyList;

@end

@implementation OOTBuddyList

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithBuddies:(NSArray *)theBuddies groups:(NSArray *)theGroups {
	OOTArray * buddyArray = [[OOTArray alloc] initWithArray:theBuddies];
	OOTArray * groupArray = [[OOTArray alloc] initWithArray:theGroups];
	NSMutableData * encodedData = [NSMutableData data];
	[encodedData appendData:[groupArray encodeClass]];
	[encodedData appendData:[buddyArray encodeClass]];
	@try {
		if ((self = [super initWithName:@"blst" data:encodedData])) {
			buddies = buddyArray;
			groups = groupArray;
		}
	} @catch (NSException * ex) {
		[buddyArray release];
		[groupArray release];
		[super dealloc];
		return nil;
	}
	return self;
}

- (id)initWithObject:(OOTObject *)object {
	@try {
		if ((self = [super initWithObject:object])) {
			if (![self initializeBuddyList]) {
				[self dealloc];
				return nil;
			}
		}
	} @catch (NSException * ex) {
		[super dealloc];
		return nil;
	}
	return self;
}
- (id)initWithData:(NSData *)data {
	@try {
		if ((self = [super initWithData:data])) {
			if (![self initializeBuddyList]) {
				[self dealloc];
				return nil;
			}
		}
	} @catch (NSException * ex) {
		[super dealloc];
		return nil;
	}
	return self;
}
- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	@try {
		if ((self = [super initWithByteBuffer:buffer])) {
			if (![self initializeBuddyList]) {
				[self dealloc];
				return nil;
			}
		}
	} @catch (NSException * ex) {
		[super dealloc];
		return nil;
	}
	return self;
}

- (id)initializeBuddyList {
	id returnValue = self;
	ANByteBuffer * buffer = nil;
	@try {
		buffer = [[ANByteBuffer alloc] initWithData:[self classData]];
		groups = [[OOTArray alloc] initWithByteBuffer:buffer];
		buddies = [[OOTArray alloc] initWithByteBuffer:buffer];
	} @catch (NSException * e) {
		@throw e;
		returnValue = nil;
	} @finally {
		[buffer release];
	}
	return returnValue;
}

- (NSArray *)buddies {
	return [buddies objects];
}
- (NSArray *)groups {
	return [groups objects];
}

- (void)dealloc {
	[buddies release];
	[groups release];
    [super dealloc];
}

@end
