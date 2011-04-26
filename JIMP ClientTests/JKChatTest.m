//
//  JKChatTest.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKChatTest.h"


@implementation JKChatTest

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (void)testRegistering {
	JKChat * chatTest = [JKChat chatWithAccount:@"test" buddyName:@"1"];
	JKChat * chatBill = [JKChat chatWithAccount:@"bill" buddyName:@"1"];
	JKChat * chatBill2 = [JKChat chatWithAccount:@"Bill" buddyName:@"1"];
	STAssertTrue(chatTest != chatBill, @"JKChats with different accounts are equal.");
	STAssertTrue(chatBill2 == chatBill, @"JKChat cares about case for account name.");
	[chatTest endChat];
	JKChat * newChatTest = [JKChat chatWithAccount:@"test" buddyName:@"1"];
	STAssertTrue(chatTest != newChatTest, @"JKChat stays registered even after -endChat");
	[chatBill endChat];
	[newChatTest endChat];
	int retCount = [chatTest retainCount];
	STAssertEquals(retCount, 1, [NSString stringWithFormat:@"JKChat has invalid retain count of %d", [chatTest retainCount]]);
}

- (void)dealloc {
    [super dealloc];
}

@end
