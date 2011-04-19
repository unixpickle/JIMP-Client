//
//  OOTGetStatus.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"


@interface OOTGetStatus : OOTObject {
    NSString * screenName;
}

- (id)initWithScreenName:(NSString *)aScreenName;
- (id)initWithData:(NSData *)data;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (id)initWithObject:(OOTObject *)object;

- (NSString *)screenName;

@end
