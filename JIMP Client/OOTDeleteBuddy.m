//
//  OOTDeleteBuddy.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTDeleteBuddy.h"


@implementation OOTDeleteBuddy

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithBuddyName:(NSString *)aScreenname {
	if ((self = [super initWithName:@"delb" data:[aScreenname dataUsingEncoding:NSUTF8StringEncoding]])) {
		screenName = [aScreenname retain];
	}
	return self;
}

- (id)initWithObject:(OOTObject *)object {
	@try {
		if ((self = [super initWithObject:object])) {
			screenName = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
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
			screenName = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
		}
	} @catch (NSException * ex) {
		[super dealloc];
		return nil;
	}
	return self;
}

- (id)initWithData:(NSData *)data {
	@try {
		if ((self = [super initWithData:data ])) {
			screenName = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
		}
	} @catch (NSException * ex) {
		[super dealloc];
		return nil;
	}
	return self;
}

- (NSString *)screenName {
	return screenName;
}

- (void)dealloc {
	[screenName release];
    [super dealloc];
}

@end
