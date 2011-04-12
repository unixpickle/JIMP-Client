//
//  OOTText.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"


@interface OOTText : OOTObject {
	NSString * textValue;
}

- (id)initWithObject:(OOTObject *)anObject;
- (id)initWithText:(NSString *)textValue;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;
- (NSString *)textValue;

@end
