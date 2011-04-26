//
//  OOTObjectTest.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "OOTObject.h"
#import "ANByteBuffer.h"


@interface OOTObjectTest : SenTestCase {

}

- (void)testCreateClassFromName;
- (void)testClassCoding;
- (void)testByteBufferCreation;

@end
