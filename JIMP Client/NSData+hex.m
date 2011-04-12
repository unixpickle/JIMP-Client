//
//  NSData+hex.m
//  Roboto
//
//  Created by Alex Nichol on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSData+hex.h"


@implementation NSData (hex)

- (NSString *)hexadecimalString {
	NSMutableString * hexString = [[NSMutableString alloc] init];
	const unsigned char * bytes = [self bytes];
	for (int i = 0; i < [self length]; i++) {
		[hexString appendFormat:@"%02X", bytes[i]];
	}
	
	NSString * immutableHex = [NSString stringWithString:hexString];
	[hexString release];
	return immutableHex;
}

@end
