//
//  OOTUtil.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTUtil.h"


@implementation OOTUtil

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

+ (NSString *)paddLong:(long)l toLength:(int)requiredLength {
	NSAssert(requiredLength > 0, @"Cannot make a string that is 0 or less bytes.");
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString * paddedString = [NSString stringWithFormat:@"%ld", l];
	while ([paddedString length] < requiredLength) {
		paddedString = [NSString stringWithFormat:@"0%@", paddedString];
	}
	[paddedString retain];
	[pool drain];
	return [paddedString autorelease];
}


- (void)dealloc {
    [super dealloc];
}

@end
