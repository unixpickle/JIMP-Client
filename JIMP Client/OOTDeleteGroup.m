//
//  OOTDeleteGroup.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTDeleteGroup.h"


@implementation OOTDeleteGroup

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}


- (id)initWithGroupName:(NSString *)aGroupName {
	if ((self = [super initWithName:@"delg" data:[aGroupName dataUsingEncoding:NSUTF8StringEncoding]])) {
		groupName = [aGroupName retain];
	}
	return self;
}
- (id)initWithObject:(OOTObject *)object {
	@try {
		if ((self = [super initWithObject:object])) {
			groupName = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
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
			groupName = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
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
			groupName = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
		}
	} @catch (NSException * ex) {
		[super dealloc];
		return nil;
	}
	return self;
}
- (NSString *)groupName {
	return groupName;
}

- (void)dealloc {
	[groupName release];
    [super dealloc];
}

@end
