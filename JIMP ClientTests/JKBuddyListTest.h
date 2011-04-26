//
//  JKBuddyListTest.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "JIMPBuddyListManager.h"
#import "JKBuddyList.h"
#import "OOTBuddy.h"
#import "JIMPStatusHandler.h"


@interface JKBuddyListTest : SenTestCase {
}

- (void)testInitialize;
- (void)testGroups;
- (void)testBuddies;
- (void)testDestroy;

@end
