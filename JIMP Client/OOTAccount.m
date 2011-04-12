//
//  OOTAccount.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTAccount.h"


@implementation OOTAccount

- (id)initWithObject:(OOTObject *)object {
	if ((self = [super initWithObject:object])) {
		ANByteBuffer * bb = [[ANByteBuffer alloc] initWithData:[self classData]];
		BOOL didFail = NO;
		@try {
			username = [[OOTText alloc] initWithByteBuffer:bb];
			password = [[OOTText alloc] initWithByteBuffer:bb];
		} @catch (NSException * e) {
			[self autorelease];
			didFail = YES;
		} @finally {
			[bb release];
		}
		if (didFail) return nil;
	}
	return self;
}

- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super initWithByteBuffer:buffer])) {
		ANByteBuffer * bb = [[ANByteBuffer alloc] initWithData:[self classData]];
		BOOL didFail = NO;
		@try {
			username = [[OOTText alloc] initWithByteBuffer:bb];
			password = [[OOTText alloc] initWithByteBuffer:bb];
		} @catch (NSException * e) {
			[self autorelease];
			didFail = YES;
		} @finally {
			[bb release];
		}
		if (didFail) return nil;
	}
	return self;
}

- (id)initWithData:(NSData *)data {
	if ((self = [super initWithData:data])) {
		ANByteBuffer * bb = [[ANByteBuffer alloc] initWithData:[self classData]];
		BOOL didFail = NO;
		@try {
			username = [[OOTText alloc] initWithByteBuffer:bb];
			password = [[OOTText alloc] initWithByteBuffer:bb];
		} @catch (NSException * e) {
			[self autorelease];
			didFail = YES;
		} @finally {
			[bb release];
		}
		if (didFail) return nil;
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
	if ((self = [super initWithName:@"acco" data:encoded])) {
		username = uname;
		password = upass;
	} else {
		[uname release];
		[upass release];
	}
	[encoded release];
	return self;
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
