//
//  NSString+MD5.m
//  Roboto
//
//  Created by Alex Nichol on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+MD5.h"


@implementation NSString (MD5)

- (NSString *)stringMD5Hash {
	return [[self dataMD5Hash] hexadecimalString];
}
- (NSData *)dataMD5Hash {
	const char * cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (unsigned int)strlen(cStr), result);
	return [NSData dataWithBytes:result length:16];
}

@end
