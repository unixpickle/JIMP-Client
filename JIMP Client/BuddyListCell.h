//
//  BuddyListCell.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTStatus.h"


@interface BuddyListCell : NSCell {
    NSColor * backgroundColor;
	OOTStatus * currentStatus;
}

// invisible, away, idle, available

+ (NSArray *)statusImages;
+ (NSArray *)statusImagesNoflipped;
+ (NSImage *)statusImageForStatus:(OOTStatus *)status;

@property (nonatomic, retain) OOTStatus * currentStatus;
@property (nonatomic, retain) NSColor * backgroundColor;

@end
