//
//  AddBuddyWindow.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddBuddyWindow.h"


@implementation AddBuddyWindow

@synthesize accountName;
@synthesize groupOption;
@synthesize addButton;
@synthesize cancelButton;
@synthesize delegate;
@synthesize groupNames;

- (id)init {
	if ((self = [super init])) {
	}    
	return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
		
	}
	return self;
}

- (void)configureContent {
	NSFont * aFont = [NSFont systemFontOfSize:[NSFont systemFontSize]];
	NSTextField * accountLabel = [NSTextField labelTextFieldWithFont:aFont];
	NSTextField * groupLabel = [NSTextField labelTextFieldWithFont:aFont];
	accountName = [[NSTextField alloc] initWithFrame:NSMakeRect(115, 10, 200, 22)];
	groupOption = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(112, 40, 207, 25)];
	addButton = [[NSButton alloc] initWithFrame:NSMakeRect([[self contentView] frame].size.width - 90, [[self contentView] frame].size.height - 30, 85, 25)];
	cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect([[self contentView] frame].size.width - 185, [[self contentView] frame].size.height - 30, 85, 25)];
	
	[groupOption setEnabled:YES];
	
	[addButton setTitle:@"Add"];
	[cancelButton setTitle:@"Cancel"];
	
	[cancelButton setButtonType:NSMomentaryLightButton];
	[addButton setButtonType:NSMomentaryLightButton];
	[addButton setBezelStyle:NSRoundRectBezelStyle];
	[cancelButton setBezelStyle:NSRoundRectBezelStyle];
	
	[cancelButton setTarget:self];
	[cancelButton setAction:@selector(cancelButton:)];
	[addButton setTarget:self];
	[addButton setAction:@selector(addPress:)];
	
	[accountLabel setFrame:NSMakeRect(10, 10, 100, 25)];
	[accountLabel setStringValue:@"Account name:"];
	[groupLabel setFrame:NSMakeRect(15, 40, 95, 25)];
	[groupLabel setStringValue:@"Add to group:"];
	
	[accountName performSelector:@selector(selectText:) withObject:self afterDelay:0.2];
	
	[groupOption addItemsWithTitles:groupNames];
	
	[self.contentView addSubview:accountLabel];
	[self.contentView addSubview:groupLabel];
	[self.contentView addSubview:accountName];
	[self.contentView addSubview:groupOption];
	[self.contentView addSubview:addButton];
	[self.contentView addSubview:cancelButton];
}

- (void)cancelButton:(id)sender {
	[delegate addBuddyCancelled:self];
}

- (void)addPress:(id)sender {
	[delegate addBuddy:[accountName stringValue] toGroup:[[groupOption selectedItem] title]];
	[delegate addBuddyCancelled:self];
}

- (void)dealloc {
	self.accountName = nil;
	self.groupOption = nil;
	self.addButton = nil;
	self.cancelButton = nil;
	self.groupNames = nil;
	[super dealloc];
}

@end
