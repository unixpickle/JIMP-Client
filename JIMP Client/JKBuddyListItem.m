//
//  BuddyListItem.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKBuddyListItem.h"


@implementation JKBuddyListItem

@synthesize title;
@synthesize type;
@synthesize index;
@synthesize expanded;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

+ (JKBuddyListItem *)itemWithTitle:(NSString *)_title type:(BuddyListItemType)_type {
	JKBuddyListItem * item = [[JKBuddyListItem alloc] init];
	item.title = _title;
	item.type = _type;
	return [item autorelease];
}

+ (JKBuddyListItem *)itemWithTitle:(NSString *)_title type:(BuddyListItemType)_type index:(NSInteger)_index {
	JKBuddyListItem * item = [JKBuddyListItem itemWithTitle:_title type:_type];
	item.index = _index;
	return item;
}

- (id)copyWithZone:(NSZone *)zone {
	JKBuddyListItem * item = [[JKBuddyListItem allocWithZone:zone] init];
	[item setIndex:[self index]];
	[item setTitle:[self title]];
	[item setType:[self type]];
	return item;
}

- (BOOL)isEqual:(id)object {
	if (![object isKindOfClass:[self class]]) return NO;
	JKBuddyListItem * item = (JKBuddyListItem *)object;
	if ([item type] == [self type] && [[item title] isEqual:[self title]]) {
		return YES;
	}
	return NO;
}

- (NSString *)specialDescription {
	return [NSString stringWithFormat:@"BuddyListItem: (type=%d, title=\"%@\", index=%d)", type, title, index];
}

- (id)description {
	return title;
}

- (void)dealloc {
	self.title = nil;
    [super dealloc];
}

@end
