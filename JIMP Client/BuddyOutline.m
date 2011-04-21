//
//  BuddyOutline.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyOutline.h"
#import "BuddyListItem.h"
#import "BuddyTitleCell.h"

@implementation BuddyOutline

@synthesize buddyDelegate;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
	if ((self = [super initWithFrame:frameRect])) {
	}
	return self;
}

- (NSMenu *)menuForEvent:(NSEvent *)event {
	switch ([event type]) {
		case NSRightMouseDown: 
		{
			NSMenu * menu = [[NSMenu alloc] init];
			NSPoint where;
			NSInteger row = -1;
			
			[menu addItemWithTitle:@"Delete" action:@selector(deleteClick:) keyEquivalent:@""];
			
			where = [self convertPoint:[event locationInWindow] fromView:nil];
			row = (NSInteger)[self rowAtPoint:where];
			
			if (row >= 0) {
				id item = [self itemAtRow:row];
				if ([(BuddyListItem *)item type] == BuddyListItemTypeBuddy) {
					NSMenuItem * item = [menu addItemWithTitle:@"New Chat" action:@selector(newChat:) keyEquivalent:@"C"];
					[item setKeyEquivalentModifierMask:NSCommandKeyMask];
				}
				[self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
			} else {
				[self deselectAll:nil];
				[menu release];
				return nil;
			}			
			return [menu autorelease];
		}
		default:
			break;
	}
	return nil;
}

- (void)reloadData {
	NSMutableArray * expanded = [NSMutableArray array];
	
	id selectedItem = nil;
	NSInteger selected = [self selectedRow];
	if (selected >= 0)
		selectedItem = [[self itemAtRow:selected] retain];
		
	for (int i = 0; i < [self numberOfRows]; i++) {
		id item = [self itemAtRow:i];
		if ([item isExpanded]) {
			[expanded addObject:item];
		}
	}
	
	[super reloadData];
	
	for (int i = 0; i < [self numberOfRows]; i++) {
		id item = [self itemAtRow:i];
		if (!hasReloaded) {
			[super expandItem:item];
			[item setExpanded:YES];
		} else {
			for (int j = 0; j < [expanded count]; j++) {
				id anItem = [expanded objectAtIndex:j];
				if (([anItem isEqual:item] && [anItem isExpanded])) {
					[super expandItem:item];
					[item setExpanded:YES];
				}
			}
		}
	}
	
	if ([self numberOfRows] > 0) hasReloaded = YES;
	
	NSInteger rowIndex = -1;
	for (int i = 0; i < [self numberOfRows]; i++) {
		id item = [self itemAtRow:i];
		if ([item isEqual:selectedItem]) {
			rowIndex = i;
			break;
		}
	}
	
	[selectedItem release];

	if (rowIndex >= 0) {
		[self selectRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] byExtendingSelection:NO];
	}
}

- (BOOL)isExpanded:(id)item {
	return ([(BuddyListItem *)item isExpanded]);
}

- (void)collapseItem:(id)item collapseChildren:(BOOL)collapseChildren {
	[(BuddyListItem *)item setExpanded:NO];
	[super collapseItem:item collapseChildren:collapseChildren];
}

- (void)collapseItem:(id)item {
	[(BuddyListItem *)item setExpanded:NO];
	[super collapseItem:item];
}

- (void)expandItem:(id)item {
	[(BuddyListItem *)item setExpanded:YES];
	[super expandItem:item];
}

- (void)expandItem:(id)item expandChildren:(BOOL)expandChildren {
	[(BuddyListItem *)item setExpanded:YES];
	[super expandItem:item expandChildren:expandChildren];
}

- (void)newChat:(id)sender {
	NSLog(@"New chat.");
}

- (void)deleteClick:(id)sender {
	id item = [self itemAtRow:[self selectedRow]];
	if ([item isKindOfClass:[BuddyListItem class]]) {
		NSString * textItem = (NSString *)[item title];
		if ([(BuddyListItem *)item type] == BuddyListItemTypeGroup) {
			// delete the group
			[buddyDelegate buddyOutlineDeleteGroup:textItem];
		} else {
			[buddyDelegate buddyOutlineDeleteBuddy:textItem];
		}
	}
}

- (void)dealloc {
    [super dealloc];
}

@end
