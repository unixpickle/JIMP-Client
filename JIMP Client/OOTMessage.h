//
//  OOTMessage.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTText.h"
#import "ANByteBuffer.h"


@interface OOTMessage : OOTObject {
    OOTText * username;
	OOTText * message;
}

- (id)initWithUsername:(NSString *)username message:(NSString *)message;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (id)initWithData:(NSData *)data;
- (id)initWithObject:(OOTObject *)object;

- (NSString *)username;
- (NSString *)message;

@end
