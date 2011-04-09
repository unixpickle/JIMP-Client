//
//  NSTextField+Label.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSTextField+Label.h"


@implementation NSTextField (Label)

+ (NSTextField *)labelTextFieldWithFont:(NSFont *)font {
	NSTextField * field = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
	[field setBordered:NO];
	[field setBackgroundColor:[NSColor clearColor]];
	[field setSelectable:NO];
	[field setFont:font];
	return [field autorelease];
}

@end
