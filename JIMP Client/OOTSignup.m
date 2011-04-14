//
//  OOTSignup.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTSignup.h"

@interface OOTSignup (private)

- (BOOL)initializeWithContents;

@end

@implementation OOTSignup

- (id)initWithObject:(OOTObject *)object {
	if ((self = [super initWithObject:object])) {
		if (![self initializeWithContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

// @pass should not be given with MD5 encrypting.
- (id)initWithUsername:(NSString *)user password:(NSString *)pass {
	NSMutableData * encoded = [[NSMutableData alloc] init];
	OOTText * uname = [[OOTText alloc] initWithText:user];
	OOTText * upass = [[OOTText alloc] initWithText:[pass stringMD5Hash]];
	[encoded appendData:[uname encodeClass]];
	[encoded appendData:[upass encodeClass]];
	if ((self = [super initWithName:@"snup" data:encoded])) {
		username = uname;
		password = upass;
	} else {
		[uname release];
		[upass release];
	}
	[encoded release];
	return self;
}

- (id)initWithData:(NSData *)data {
	if ((self = [super initWithData:data])) {
		if (![self initializeWithContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super initWithByteBuffer:buffer])) {
		if (![self initializeWithContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

- (BOOL)intializeWithContents {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	@try {
		ANByteBuffer * bb = [[[ANByteBuffer alloc] initWithData:[self classData]] autorelease];
		username = [[OOTText alloc] initWithByteBuffer:bb];
		password = [[OOTText alloc] initWithByteBuffer:bb];
	} @catch (NSException * ex) {
		[pool drain];
		return NO;
	}
	[pool drain];
	return YES;
}

- (NSString *)usernameString {
	return [username textValue];
}
- (NSString *)passwordString {
	return [password textValue];
}

- (void)dealloc {
	[username release];
	[password release];
	[super dealloc];
}

@end
