//
//  BuddyListColumn.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyListColumn.h"


@implementation BuddyListColumn

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	return [super outlineView:outlineView dataCellForTableColumn:tableColumn item:item];
}

- (void)dealloc {
    [super dealloc];
}

@end
