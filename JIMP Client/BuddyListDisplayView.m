//
//  BuddyListDisplayView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyListDisplayView.h"


@implementation BuddyListDisplayView

@synthesize buddyOutline;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
		indices = [[NSMutableDictionary alloc] init];
		NSRect bounds = self.bounds;
		buddyOutline = [[NSOutlineView alloc] initWithFrame:bounds];
		[buddyOutline setDataSource:self];
		[buddyOutline setDelegate:self];
		
		BlankCell * cell = [[BlankCell alloc] initTextCell:@"Buddies:"];
		NSTableColumn * c = [[NSTableColumn alloc] initWithIdentifier:@"NAME"];
		[c setEditable:NO];
		[c setMinWidth:150.0];
		[c setHeaderCell:cell];
		[buddyOutline addTableColumn:c];
		[buddyOutline setOutlineTableColumn:c];
		[buddyOutline setHeaderView:nil];
		[c release];
		[cell release];
		
		[buddyOutline reloadData];
		
		NSScrollView * scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, bounds.size.width, bounds.size.height)];
		[scrollView setDocumentView:buddyOutline];
		[scrollView setAutoresizesSubviews:YES];
		
		[self addSubview:scrollView];
		// [scrollView release];
    }
    return self;
}

- (void)setBuddyList:(BuddyList *)_buddyList {
	[buddyList autorelease];
	buddyList = [_buddyList retain];
	[buddyOutline reloadData];
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	[buddyOutline setFrame:self.bounds];
}

#pragma mark Outline View

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (!item) {
		int count = [buddyList numberOfGroups];
		return count;
	} else {
		int count = [buddyList numberOfItems:[[indices objectForKey:item] intValue]];
		return count;
	}
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (![outlineView parentForItem:item]) {
		return YES;
	} else return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if (!item) {
		id newItem = [buddyList groupTitle:(int)index];
		[indices setObject:[NSNumber numberWithInt:(int)index] forKey:newItem];
		return newItem;
	} else {
		return [buddyList itemAtIndex:(int)index ofGroup:[[indices objectForKey:item] intValue]];
	}
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	return item;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	if (![outlineView parentForItem:item]) {
		BuddyTitleCell * buddyTitle = [[BuddyTitleCell alloc] initTextCell:item];
		NSText * text = [[NSText alloc] init];
		[text setFont:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]]];
		[text setTextColor:[NSColor grayColor]];
		[buddyTitle setUpFieldEditorAttributes:text];
		return [buddyTitle autorelease];
	}
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
	if (![outlineView parentForItem:item]) return NO;
	return YES;
}

- (void)dealloc {
	self.buddyOutline = nil;
	[indices release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	//[[NSColor blackColor] set];
	//NSRectFill(dirtyRect);
}

@end
