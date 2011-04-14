//
//  OOTInsertBuddy.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OOTObject.h"
#import "OOTBuddy.h"
#import "OOTUtil.h"


@interface OOTInsertBuddy : OOTObject {
	int buddyIndex;
	OOTBuddy * buddy;
}

@property (readonly) int buddyIndex;
@property (readonly) OOTBuddy * buddy;

- (id)initWithIndex:(int)index buddy:(OOTBuddy *)aBuddy;
- (id)initWithObject:(OOTObject *)object;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (id)initWithData:(NSData *)data;

@end
