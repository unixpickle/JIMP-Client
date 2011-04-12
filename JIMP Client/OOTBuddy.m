//
//  OOTBuddy.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTBuddy.h"

@interface OOTBuddy (private)

- (id)initializeBuddyInfo;

@end

@implementation OOTBuddy

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithScreenname:(NSString *)screenname groupName:(NSString *)groupName {
	NSMutableData * encodedData = [[NSMutableData alloc] init];
	screennameText = [[OOTText alloc] initWithText:screenname];
	groupText = [[OOTText alloc] initWithText:groupName];
	[encodedData appendData:[groupText encodeClass]];
	[encodedData appendData:[screennameText encodeClass]];
	if ((self = [super initWithName:@"budd" data:encodedData])) {
		// Initialization code here.
	}
	[encodedData release];
	return self;
}
- (id)initWithObject:(OOTObject *)object {
	if ((self = [super initWithObject:object])) {
		if (![self initializeBuddyInfo]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithData:(NSData *)data {
	if ((self = [super initWithData:data])) {
		if (![self initializeBuddyInfo]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super initWithByteBuffer:buffer])) {
		if (![self initializeBuddyInfo]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

- (id)initializeBuddyInfo {
	ANByteBuffer * buffer = [[ANByteBuffer alloc] initWithData:[self classData]];
	@try {
		groupText = [[OOTText alloc] initWithByteBuffer:buffer];
		screennameText = [[OOTText alloc] initWithByteBuffer:buffer];
		[buffer release];
	} @catch (NSException * e) {
		[buffer release];
		@throw e;
		return nil;
	}
	return self;
}

- (NSString *)screenName {
	return [screennameText textValue];
}

- (NSString *)groupName {
	return [groupText textValue];
}

- (void)dealloc {
	[screennameText release];
	[groupText release];
    [super dealloc];
}

@end
