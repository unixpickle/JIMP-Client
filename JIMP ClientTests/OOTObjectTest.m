//
//  OOTObjectTest.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOTObjectTest.h"


@implementation OOTObjectTest

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (void)testCreateClassFromName {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSData * myData = [@"hello" dataUsingEncoding:NSASCIIStringEncoding];
	OOTObject * object = [[OOTObject alloc] initWithName:@"objc" data:myData];
	STAssertTrue([[object className] isEqualToString:@"objc"], @"Creation did not use our class name");
	STAssertTrue([[object classData] isEqualToData:myData], @"Creation did not use our class data");
	[object release];
	[pool drain];
}
- (void)testClassCoding {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSData * myData = [@"hello" dataUsingEncoding:NSASCIIStringEncoding];
	OOTObject * object = [[OOTObject alloc] initWithName:@"objc" data:myData];
	OOTObject * anotherObject = [[OOTObject alloc] initWithData:[object encodeClass]];
	STAssertTrue([[object className] isEqual:[anotherObject className]], @"Class names didn't carry over.");
	STAssertTrue([[object classData] isEqual:[anotherObject classData]], @"Class contents didn't carry over.");
	[object release];
	[anotherObject release];
	[pool drain];
}
- (void)testByteBufferCreation {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSData * aString = [@"hello" dataUsingEncoding:NSASCIIStringEncoding];
	OOTObject * object1 = [[OOTObject alloc] initWithName:@"text" data:nil];
	OOTObject * object2 = [[OOTObject alloc] initWithName:@"text" data:aString];
	NSMutableData * encoded = [[NSMutableData alloc] init];
	[encoded appendData:[object1 encodeClass]];
	[encoded appendData:[object2 encodeClass]];
	ANByteBuffer * buffer = [[ANByteBuffer alloc] initWithData:encoded];
	[encoded release];
	OOTObject * object1copy = [[OOTObject alloc] initWithByteBuffer:buffer];
	OOTObject * object2copy = [[OOTObject alloc] initWithByteBuffer:buffer];
	STAssertTrue(([buffer remaining] == 0), @"Encoded data had remaining bytes.");
	STAssertTrue(([[object1copy className] isEqual:[object1 className]]), @"Object 1 (name) not copied via byte buffer.");
	STAssertTrue(([[object2copy className] isEqual:[object2 className]]), @"Object 2 (name) not copied via byte buffer.");
	STAssertTrue(([[object1copy classData] isEqual:[object1 classData]]), @"Object 1 (content) not copied via byte buffer.");
	STAssertTrue(([[object2copy classData] isEqual:[object2 classData]]), @"Object 2 (content) not copied via byte buffer.");
	[buffer release];
	[object1 release];
	[object2 release];
	[object1copy release];
	[object2copy release];
	[pool drain];
}

- (void)dealloc {
    [super dealloc];
}

@end
