//
//  OOTGetStatus.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTGetStatus.h"


@implementation OOTGetStatus

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithScreenName:(NSString *)aScreenName {
	if ((self = [super initWithName:@"gsts" data:[aScreenName dataUsingEncoding:NSUTF8StringEncoding]])) {
		screenName = [aScreenName retain];
	}
	return self;
}
- (id)initWithData:(NSData *)data {
	if ((self = [super initWithData:data])) {
		screenName = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
	}
	return self;
}
- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super initWithByteBuffer:buffer])) {
		screenName = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
	}
	return self;
}
- (id)initWithObject:(OOTObject *)object {
	if ((self = [super initWithObject:object])) {
		screenName = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
	}
	return self;
}

- (NSString *)screenName {
	return [[screenName retain] autorelease];
}

- (void)dealloc {
	[screenName release];
    [super dealloc];
}

@end
