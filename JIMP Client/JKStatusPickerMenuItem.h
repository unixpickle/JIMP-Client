//
//  StatusPickerMenuItem.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OOTStatus.h"


@interface JKStatusPickerMenuItem : NSObject <NSCoding> {
	OOTStatus * status;
	NSMenuItem * menuItem;
}

@property (nonatomic, retain) OOTStatus * status;
@property (nonatomic, retain) NSMenuItem * menuItem;

- (NSString *)statusString;
+ (JKStatusPickerMenuItem *)menuItemWithStatus:(OOTStatus *)status;

@end
