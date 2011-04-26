//
//  OOTMessage.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTMessage.h"

@interface OOTMessage (private)

- (BOOL)initializeFromContents;

@end

@implementation OOTMessage

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithUsername:(NSString *)_username message:(NSString *)_message {
	NSAssert(_username != nil, @"OOTMessage must be initialized with a username.");
	NSAssert(_message != nil, @"OOTMessage must be initialized with a message.");
	NSMutableData * encoded = [[NSMutableData alloc] init];
	username = [[OOTText alloc] initWithText:_username];
	message = [[OOTText alloc] initWithText:_message];
	[encoded appendData:[username encodeClass]];
	[encoded appendData:[message encodeClass]];
	if ((self = [super initWithName:@"mssg" data:encoded])) {
		
	}
	[encoded release];
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
- (id)initWithObject:(OOTObject *)object {
	if ((self = [super initWithObject:object])) {
		if (![self initializeFromContents]) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

- (NSString *)username {
	return [username textValue];
}
- (NSString *)message {
	return [message textValue];
}

- (id)description {
	return [NSString stringWithFormat:@"%@: from \"%@\": %@", [super description], self.username, self.message];
}

- (BOOL)initializeFromContents {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	@try {
		ANByteBuffer * buffer = [[[ANByteBuffer alloc] initWithData:[self classData]] autorelease];
		username = [[OOTText alloc] initWithByteBuffer:buffer];
		message = [[OOTText alloc] initWithByteBuffer:buffer];
	} @catch (NSException * e) {
		[username release];
		[message release];
		[pool drain];
		return NO;
	}
	[pool drain];
	return YES;
}

- (void)dealloc {
	[username release];
	[message release];
    [super dealloc];
}

@end
