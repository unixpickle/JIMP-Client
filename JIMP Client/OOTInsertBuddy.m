//
//  OOTInsertBuddy.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTInsertBuddy.h"

@interface OOTInsertBuddy (private)

- (BOOL)initializeFromContents;

@end


@implementation OOTInsertBuddy

@synthesize buddyIndex;
@synthesize buddy;

- (id)initWithIndex:(int)index buddy:(OOTBuddy *)aBuddy {
	// compose the data
	NSMutableData * dataContent = nil;
	@try {
		dataContent = [[NSMutableData alloc] init];
		NSString * string = [OOTUtil paddLong:index toLength:3];
		NSData * encoded = [aBuddy encodeClass];
		[dataContent appendData:[string dataUsingEncoding:NSASCIIStringEncoding]];
		[dataContent appendData:encoded];
		
		if ((self = [super initWithName:@"isrt" data:encoded])) {
			buddy = [aBuddy retain];
			buddyIndex = index;
		}
		
		[dataContent release];
	} @catch (NSException * ex) {
		[dataContent release];
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
	@try {
		const char * bytes = [[self classData] bytes];
		int length = (int)[[self classData] length];
		if (length < 3) {
			return NO;
		}
		NSString * indexString = [[NSString alloc] initWithBytes:bytes length:3 encoding:NSASCIIStringEncoding];
		NSData * buddyBytes = [NSData dataWithBytes:&bytes[3] length:(length - 3)];
		[indexString autorelease];
		buddy = [[OOTBuddy alloc] initWithData:buddyBytes];
		if (!buddy || !indexString) {
			if (buddy) [buddy release];
			return NO;
		}
		buddyIndex = [indexString intValue];
	} @catch (NSException * ex) {
		return NO;
	}
	return YES;
}

@end
