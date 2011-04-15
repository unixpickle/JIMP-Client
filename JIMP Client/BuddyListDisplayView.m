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
		buddyOutline = [[NSOutlineView alloc] initWithFrame:NSMakeRect(0, 0, bounds.size.width, bounds.size.height)];
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
		
		[buddyOutline setAutoresizingMask:(NSViewWidthSizable)];
		[buddyOutline reloadData];
		[buddyOutline setAutoresizesOutlineColumn:NO];
		
		NSScrollView * scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, bounds.size.width, bounds.size.height)];
		[scrollView setDocumentView:buddyOutline];
		[scrollView setAutohidesScrollers:YES];
		[scrollView setScrollsDynamically:YES];
		[scrollView setHasVerticalScroller:YES];
		
		[self setAutoresizesSubviews:YES];
		
		[self addSubview:scrollView];
		[scrollView release];
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
	} else { 
		BuddyListCell * cell = [[BuddyListCell alloc] initTextCell:item];
		if ([outlineView rowForItem:item] % 2 == 0) {
			[cell setBackgroundColor:[NSColor colorWithDeviceRed:0.929 green:0.953 blue:0.996 alpha:1]];
		}
		return [cell autorelease];
	}
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
	if (![outlineView parentForItem:item]) return NO;
	return YES;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	if ([outlineView parentForItem:item]) {
		return 34;
	}
	return 17;
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
