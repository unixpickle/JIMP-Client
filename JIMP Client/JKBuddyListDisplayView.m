//
//  BuddyListDisplayView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKBuddyListDisplayView.h"


@implementation JKBuddyListDisplayView

@synthesize buddyOutline;
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
		NSRect bounds = self.bounds;
		buddyOutline = [[JKBuddyOutline alloc] initWithFrame:NSMakeRect(0, 0, bounds.size.width, bounds.size.height)];
		[buddyOutline setDataSource:self];
		[buddyOutline setDelegate:self];
		
		itemCache = [[NSMutableArray alloc] init];
		
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

- (void)setBuddyList:(JKBuddyList *)_buddyList {
	[buddyList autorelease];
	buddyList = [_buddyList retain];
	[buddyOutline reloadData];
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	[buddyOutline setFrame:self.bounds];
}

#pragma mark Outline View

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(JKBuddyListItem *)item {
	if (!item) {
		int count = [buddyList numberOfGroups];
		return count;
	} else {
		int count = [buddyList numberOfItems:(int)[(JKBuddyListItem *)item index]];
		return count;
	}
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(JKBuddyListItem *)item {
    if ([(JKBuddyListItem *)item type] == BuddyListItemTypeGroup) {
		return YES;
	} else return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(JKBuddyListItem *)item {
	if (!item) {
		NSString * groupTitle = [buddyList groupTitle:(int)index];
		for (JKBuddyListItem * object in itemCache) {
			if ([[object title] isEqual:groupTitle] && [object type] == BuddyListItemTypeGroup && [object index] == index) {
				return object;
			}
		}
		JKBuddyListItem * anItem = [JKBuddyListItem itemWithTitle:groupTitle type:BuddyListItemTypeGroup index:index];
		[itemCache addObject:anItem];
		return anItem;
	} else {
		NSString * titleItem = [buddyList itemAtIndex:(int)index ofGroup:(int)[(JKBuddyListItem *)item index]];
		for (JKBuddyListItem * object in itemCache) {
			if ([[object title] isEqual:titleItem] && [object type] == BuddyListItemTypeBuddy && [object index] == index) {
				return object;
			}
		}
		JKBuddyListItem * anItem = [JKBuddyListItem itemWithTitle:titleItem type:BuddyListItemTypeBuddy index:index];
		[itemCache addObject:anItem];
		return anItem;
	}
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(JKBuddyListItem *)item {
	return item;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(JKBuddyListItem *)item {
	if ([(JKBuddyListItem *)item type] == BuddyListItemTypeGroup) {
		BuddyTitleCell * buddyTitle = [[BuddyTitleCell alloc] initTextCell:[item title]];
		
		NSFont * font = [NSFont boldSystemFontOfSize:13];
		NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
									 NSForegroundColorAttributeName, [NSColor grayColor], nil];
		NSAttributedString * string = [[NSAttributedString alloc] initWithString:[item title] attributes:attributes];
		
		[buddyTitle setAttributedStringValue:string];
		[buddyTitle setOutlineView:(JKBuddyOutline *)outlineView];
		[buddyTitle setItem:item];
		
		[string release];
		
		return [buddyTitle autorelease];
	} else {
		BuddyListCell * cell = [[BuddyListCell alloc] initTextCell:[item title]];
		int buddyItemIndex = 0;
		int row = (int)[outlineView rowForItem:item];
		for (int i = 0; i < [outlineView numberOfRows]; i++) {
			id anItem = [outlineView itemAtRow:i];
			if (i == row) break;
			if ([(JKBuddyListItem *)anItem type] == BuddyListItemTypeBuddy) {
				buddyItemIndex += 1;
			}
		}
		JIMPStatusHandler * handler = [delegate buddyListDisplayViewGetStatusHandler:self];
		OOTStatus * status = [handler statusMessageForBuddy:[item title]];
		if (status) {
			[cell setCurrentStatus:status];
		}
		if (buddyItemIndex % 2 == 0) {
			[cell setBackgroundColor:[NSColor colorWithDeviceRed:0.929 green:0.953 blue:0.996 alpha:1]];
		} else {
			[cell setBackgroundColor:nil];
		}

		return [cell autorelease];
	}
	return nil;
}

- (void)outlineView:(NSOutlineView *)ov willDisplayOutlineCell:(NSButtonCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(JKBuddyListItem *)item {
	NSImage * blank = [[NSImage alloc] init];
	[cell setImage:blank];
	[cell setAlternateImage:blank];
	[blank release];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(JKBuddyListItem *)item {
	if ([(JKBuddyListItem *)item type] == BuddyListItemTypeGroup) return NO;
	return YES;
}

- (void)deleteClick:(id)sender {
	
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
	if ([(JKBuddyListItem *)item type] == BuddyListItemTypeBuddy) {
		return 34;
	}
	return 17;
}

- (void)dealloc {
	self.buddyOutline = nil;
	[itemCache release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}

@end
