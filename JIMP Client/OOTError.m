//
//  OOTError.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTError.h"

@interface OOTError (private)

- (id)initializeInfo;

@end

@implementation OOTError

- (id)initWithObject:(OOTObject *)object {
	if ((self = [super initWithObject:object])) {
		if (![self initializeInfo]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

- (id)initWithData:(NSData *)data {
	if ((self = [super initWithData:data])) {
		if (![self initializeInfo]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super initWithByteBuffer:buffer])) {
		if (![self initializeInfo]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

- (id)initWithCode:(int)code message:(NSString *)message {
	NSString * numString = [NSString stringWithFormat:@"%s%d", (code < 10 ? "0" : ""), code];
	NSMutableData * generatedClassData = [NSMutableData data];
	[generatedClassData appendBytes:[numString UTF8String] length:[numString length]];
	[generatedClassData appendBytes:[message UTF8String] length:[message length]];
	if ((self = [super initWithName:@"errr" data:generatedClassData])) {
		errorCode = code;
		errorMessage = [message retain];
	}
	return self;
}

- (id)initializeInfo {
	if ([[self classData] length] < 2) {
		return nil;
	}
	
	NSData * theClassData = [self classData];
	const char * bytes = [theClassData bytes];
	
	NSString * errorCodeString = [[NSString alloc] initWithBytes:bytes length:2 encoding:NSASCIIStringEncoding];
	errorCode = [errorCodeString intValue];
	errorMessage = [[NSString alloc] initWithBytes:&bytes[2] length:([theClassData length] - 2) encoding:NSASCIIStringEncoding];
	
	[errorCodeString release];
	
	return self;
}

- (NSString *)errorMessage {
	return errorMessage;
}
- (int)errorCode {
	return errorCode;
}

- (id)description {
	return [NSString stringWithFormat:@"OOTError(code:%d message:\"%@\")", errorCode, errorMessage];
}

- (void)dealloc {
	[errorMessage release];
    [super dealloc];
}

@end
