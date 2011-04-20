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
		NSRect bounds = self.bounds;
		buddyOutline = [[BuddyOutline alloc] initWithFrame:NSMakeRect(0, 0, bounds.size.width, bounds.size.height)];
		[buddyOutline setDataSource:self];
		[buddyOutline setDelegate:self];
		
		NSTableColumn * c = [[NSTableColumn alloc] initWithIdentifier:@"NAME"];
		[c setEditable:NO];
		[c setMinWidth:150.0];
		[buddyOutline addTableColumn:c];
		[buddyOutline setOutlineTableColumn:c];
		[buddyOutline setHeaderView:nil];
		[c release];
		
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

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(BuddyListItem *)item {
	if (!item) {
		int count = [buddyList numberOfGroups];
		return count;
	} else {
		int count = [buddyList numberOfItems:(int)[(BuddyListItem *)item index]];
		return count;
	}
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(BuddyListItem *)item {
    if ([(BuddyListItem *)item type] == BuddyListItemTypeGroup) {
		return YES;
	} else return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(BuddyListItem *)item {
	if (!item) {
		id newItem = [buddyList groupTitle:(int)index];
		return [[BuddyListItem itemWithTitle:newItem type:BuddyListItemTypeGroup index:index] retain];
	} else {
		NSString * titleItem = [buddyList itemAtIndex:(int)index ofGroup:(int)[(BuddyListItem *)item index]];
		return [[BuddyListItem itemWithTitle:titleItem type:BuddyListItemTypeBuddy index:index] retain];
	}
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(BuddyListItem *)item {
	return item;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(BuddyListItem *)item {
	if ([(BuddyListItem *)item type] == BuddyListItemTypeGroup) {
		BuddyTitleCell * buddyTitle = [[BuddyTitleCell alloc] initTextCell:[item title]];
		
		NSFont * font = [NSFont boldSystemFontOfSize:13];
		NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
									 NSForegroundColorAttributeName, [NSColor grayColor], nil];
		NSAttributedString * string = [[NSAttributedString alloc] initWithString:[item title] attributes:attributes];
		
		[buddyTitle setAttributedStringValue:string];
		[buddyTitle setOutlineView:(BuddyOutline *)outlineView];
		[buddyTitle setItem:item];
		
		[string release];
		
		return [buddyTitle autorelease];
	} else {
		BuddyListCell * cell = [[BuddyListCell alloc] initTextCell:[item title]];
		int buddyItemIndex = 0;
		int row = [outlineView rowForItem:item];
		for (int i = 0; i < [outlineView numberOfRows]; i++) {
			id anItem = [outlineView itemAtRow:i];
			if (i == row) break;
			if ([anItem type] == BuddyListItemTypeBuddy) {
				buddyItemIndex += 1;
			}
		}
		if (buddyItemIndex % 2 == 0) {
			[cell setBackgroundColor:[NSColor colorWithDeviceRed:0.929 green:0.953 blue:0.996 alpha:1]];
		}
		return [cell autorelease];
	}
	return nil;
}

- (void)outlineView:(NSOutlineView *)ov willDisplayOutlineCell:(NSButtonCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(BuddyListItem *)item {
	NSImage * blank = [[NSImage alloc] init];
	[cell setImage:blank];
	[cell setAlternateImage:blank];
	[blank release];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(BuddyListItem *)item {
	if ([(BuddyListItem *)item type] == BuddyListItemTypeGroup) return NO;
	return YES;
}

- (void)deleteClick:(id)sender {
	
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	if ([(BuddyListItem *)item type] == BuddyListItemTypeBuddy) {
		return 34;
	}
	return 17;
}

- (void)dealloc {
	self.buddyOutline = nil;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}

@end
