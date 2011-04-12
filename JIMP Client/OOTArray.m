//
//  OOTArray.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTArray.h"
#import "OOTObjectCreator.h"


@interface OOTArray (private) 

- (id)initializeArrayContents;
	
@end

@implementation OOTArray

@synthesize objects;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithArray:(NSArray *)objectsArray {
	NSMutableData * bufferData = [[NSMutableData alloc] init];
	long count = [objectsArray count];
	if (count > 999) {
		[bufferData release];
		[super dealloc];
		@throw [NSException exceptionWithName:@"BufferOverflowException" reason:@"You specified too many objects to fit in this array." userInfo:nil];
		return nil;
	}
	NSString * countString = [OOTUtil paddLong:(long)count toLength:3];
	[bufferData appendBytes:[countString UTF8String] length:3];
	for (id anObject in objectsArray) {
		if (![anObject isKindOfClass:[OOTObject class]]) {
			[bufferData release];
			[super dealloc];
			return nil;
		}
		[bufferData appendData:[(OOTObject *)anObject encodeClass]];
	}
	if ((self = [super initWithName:@"list" data:bufferData])) {
		objects = [objectsArray retain];
	}
	[bufferData release];
	return self;
}
- (id)initWithObject:(OOTObject *)object {
	if ((self = [super initWithObject:object])) {
		if (![self initializeArrayContents]) {
			[self dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithByteBuffer:(ANByteBuffer *)buffer {
	if ((self = [super initWithByteBuffer:buffer])) {
		if (![self initializeArrayContents]) {
			[self dealloc];
			return nil;
		}
	}
	return self;
}
- (id)initWithData:(NSData *)data {
	if ((self = [super initWithData:data])) {
		if (![self initializeArrayContents]) {
			[self dealloc];
			return nil;
		}
	}
	return self;
}

- (id)initializeArrayContents {
	if ([[self classData] length] < 3) {
		return nil;
	}
	const char * bytes = (const char *)[[self classData] bytes];
	NSString * lengthString = [[NSString alloc] initWithBytes:bytes length:3 encoding:NSASCIIStringEncoding];
	if (!lengthString) {
		return nil;
	}
	int objectCount = [lengthString intValue];
	int myLength = (int)([[self classData] length] - 3);
	ANByteBuffer * buffer = [(ANByteBuffer *)[ANByteBuffer alloc] initWithBytes:&bytes[3] length:myLength];
	NSMutableArray * objectArray = [NSMutableArray array];
	for (int i = 0; i < objectCount; i++) {
		OOTObject * anObject = [[OOTObject alloc] initWithByteBuffer:buffer];
		OOTObject * newObject = [OOTObjectCreator objectSubclassForObject:anObject];
		[objectArray addObject:newObject];
		[anObject release];
	}
	objects = [[NSArray alloc] initWithArray:objectArray];
	return self;
}

- (void)dealloc {
	[objects release];
    [super dealloc];
}

@end
