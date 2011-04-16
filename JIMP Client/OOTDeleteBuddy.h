//
//  OOTDeleteBuddy.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTText.h"


@interface OOTDeleteBuddy : OOTObject {
    NSString * screenName;
}

- (id)initWithBuddyName:(NSString *)aScreenname;
- (id)initWithObject:(OOTObject *)object;
- (id)initWithData:(NSData *)data;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (NSString *)screenName;

@end
