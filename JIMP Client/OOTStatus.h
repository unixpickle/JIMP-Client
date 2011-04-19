//
//  OOTStatus.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"
#import "OOTText.h"
#import "OOTUtil.h"


@interface OOTStatus : OOTObject {
	OOTText * statusMessage;
	OOTText * owner;
	char statusType;
	long idleTime;
}

- (id)initWithObject:(OOTObject *)object;
- (id)initWithData:(NSData *)data;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (id)initWithMessage:(NSString *)message owner:(NSString *)anOwner type:(char)type idle:(long)idle;
- (id)initWithMessage:(NSString *)message owner:(NSString *)anOwner type:(char)type;

- (NSString *)statusMessage;
- (NSString *)owner;
- (char)statusType;
- (long)idleTime;

@end
