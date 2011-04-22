//
//  StatusPickerMenuItem.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKStatusPickerMenuItem.h"


@implementation JKStatusPickerMenuItem

@synthesize status;
@synthesize menuItem;


- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		NSData * encoded = [aDecoder decodeObjectForKey:@"status"];
		if ([encoded length] > 0) {
			@try {
				status = [[OOTStatus alloc] initWithData:encoded];
			} @catch (NSException * e) {
				[super dealloc];
				return nil;
			}
		}
	}
	return self;
}

- (NSString *)statusString {
	if (!status) {
		return @"";
	} else {
		if ([[status statusMessage] isEqual:@""]) {
			if ([status statusType] == 'o') return @"Available";
			if ([status statusType] == 'n') return @"Offline";
			if ([status statusType] == 'a') return @"Away";
			if ([status statusType] == 'i') return @"Idle";
		} else {
			return [status statusMessage];
		}
	}
	return @"";
}

+ (JKStatusPickerMenuItem *)menuItemWithStatus:(OOTStatus *)status {
	JKStatusPickerMenuItem * menuItem = [[JKStatusPickerMenuItem alloc] init];
	[menuItem setStatus:status];
	return [menuItem autorelease];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	NSData * encoded;
	if (status) {
		encoded = [status encodeClass];
	} else encoded = [NSData data];
	[aCoder encodeObject:encoded forKey:@"status"];
}

- (void)dealloc {
	self.status = nil;
	self.menuItem = nil;
    [super dealloc];
}

@end
