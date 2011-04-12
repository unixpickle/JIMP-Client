//
//  OOTError.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"


@interface OOTError : OOTObject {
    NSString * errorMessage;
	int errorCode;
}

- (id)initWithObject:(OOTObject *)object;
- (id)initWithCode:(int)code message:(NSString *)message;

- (NSString *)errorMessage;
- (int)errorCode;

@end
