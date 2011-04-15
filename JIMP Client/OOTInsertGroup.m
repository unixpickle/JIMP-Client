//
//  OOTInsertGroup.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTInsertGroup.h"

@interface OOTInsertGroup (private)

- (BOOL)initializeFromContents;

@end

@implementation OOTInsertGroup

@synthesize groupIndex;
@synthesize groupName;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
	}
    return self;
}

- (id)initWithIndex:(int)index group:(NSString *)aGroupName {
	if (index > 999) {
		[super dealloc];
		return nil;
	}
	NSMutableData * encoded = [NSMutableData data];
	NSString * indexString = [OOTUtil paddLong:index toLength:3];
	groupName = [[OOTText alloc] initWithText:aGroupName];
	[encoded appendData:[indexString dataUsingEncoding:NSASCIIStringEncoding]];
	[encoded appendData:[groupName encodeClass]];
	@try {
		if ((self = [super initWithName:@"irtg" data:encoded])) {
			
		}
	} @catch (NSException * e) {
		[groupName release];
		[super dealloc];
		return nil;
	}
	return self;
}
- (id)initWithObject:(OOTObject *)object {
	if ((self = [super initWithObject:object])) {
		if (![self initializeFromContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super initWithByteBuffer:buffer])) {
		if (![self initializeFromContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithData:(NSData *)data {
	if ((self = [super initWithData:data])) {
		if (![self initializeFromContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

- (BOOL)initializeFromContents {
	if ([[self classData] length] < 3) {
		return NO;
	}
	int length = (int)[[self classData] length];
	const char * bytes = [[self classData] bytes];
	NSString * indexString = [[NSString alloc] initWithBytes:bytes length:3 encoding:NSASCIIStringEncoding];
	if (!indexString) {
		return NO;
	}
	groupIndex = [indexString intValue];
	@try {
		groupName = [[OOTText alloc] initWithData:[NSData dataWithBytes:&bytes[3] length:(length - 3)]];
	} @catch (NSException * e) {
		return NO;
	}
	return YES;
}

- (void)dealloc {
	[groupName release];
    [super dealloc];
}

@end
