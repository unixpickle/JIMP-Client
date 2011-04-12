//
//  NSString+MD5.h
//  Roboto
//
//  Created by Alex Nichol on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSData+hex.h"

@interface NSString (MD5)

- (NSString *)stringMD5Hash;
- (NSData *)dataMD5Hash;

@end
