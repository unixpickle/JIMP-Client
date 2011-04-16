//
//  BuddyListItem.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	BuddyListItemTypeBuddy,
	BuddyListItemTypeGroup
} BuddyListItemType;

@interface BuddyListItem : NSObject <NSCopying> {
    NSString * title;
	BuddyListItemType type;
	NSInteger index;
	BOOL expanded;
}

@property (nonatomic, retain) NSString * title;
@property (readwrite) BuddyListItemType type;
@property (readwrite) NSInteger index;
@property (readwrite, getter=isExpanded) BOOL expanded;

- (NSString *)specialDescription;

+ (BuddyListItem *)itemWithTitle:(NSString *)_title type:(BuddyListItemType)_type;
+ (BuddyListItem *)itemWithTitle:(NSString *)_title type:(BuddyListItemType)_type index:(NSInteger)_index;

@end
