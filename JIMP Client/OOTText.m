//
//  OOTText.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTText.h"


@implementation OOTText

- (id)initWithObject:(OOTObject *)anObject {
	if ((self = [super initWithObject:anObject])) {
		textValue = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
	}
	return self;
}
- (id)initWithText:(NSString *)_textValue {
	if ((self = [super initWithName:@"text" data:[_textValue dataUsingEncoding:NSUTF8StringEncoding]])) {
		textValue = [_textValue retain];
	}
	return self;
}

- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super initWithByteBuffer:buffer])) {
		textValue = [[NSString alloc] initWithData:[self classData] encoding:NSUTF8StringEncoding];
	}
	return self;
}

- (NSString *)textValue {
	return textValue;
}

- (void)dealloc {
	[textValue release];
    [super dealloc];
}

@end
