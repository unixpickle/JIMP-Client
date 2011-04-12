//
//  OOTAccount.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MD5.h"
#import "OOTObject.h"
#import "OOTText.h"


@interface OOTAccount : OOTObject {
	OOTText * username;
	OOTText * password;
}

- (id)initWithObject:(OOTObject *)object;

// @pass should not be given with MD5 encrypting.
- (id)initWithUsername:(NSString *)user password:(NSString *)pass;

- (NSString *)usernameString;
- (NSString *)passwordString;

@end
