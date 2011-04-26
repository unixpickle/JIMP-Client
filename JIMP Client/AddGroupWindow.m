//
//  AddGroupWindow.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddGroupWindow.h"


@implementation AddGroupWindow

@synthesize groupLabel;
@synthesize groupName;
@synthesize addButton;
@synthesize cancelButton;
@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
		self.groupLabel = [NSTextField labelTextFieldWithFont:[NSFont systemFontOfSize:[NSFont systemFontSize]]];
		groupName = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 35, contentRect.size.width - 20, 25)];
		addButton = [[NSButton alloc] initWithFrame:NSMakeRect(contentRect.size.width - 90, contentRect.size.height - 30, 85, 25)];
		cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(contentRect.size.width - 185, contentRect.size.height - 30, 85, 25)];
				
		[addButton setTitle:@"Add"];
		[cancelButton setTitle:@"Cancel"];
		
		[cancelButton setButtonType:NSMomentaryLightButton];
		[addButton setButtonType:NSMomentaryLightButton];
		[addButton setBezelStyle:NSRoundRectBezelStyle];
		[cancelButton setBezelStyle:NSRoundRectBezelStyle];
		
		[cancelButton setTarget:self];
		[cancelButton setAction:@selector(cancelPress:)];
		[addButton setTarget:self];
		[addButton setAction:@selector(addPress:)];
		
		[groupName performSelector:@selector(selectText:) withObject:self afterDelay:0.2];

		
		[groupLabel setFrame:NSMakeRect(10, 10, 90, 25)];
		[groupLabel setStringValue:@"Group name:"];
	}
	return self;
}

- (void)configureContent {
	[self.contentView addSubview:groupLabel];
	[self.contentView addSubview:groupName];
	[self.contentView addSubview:addButton];
	[self.contentView addSubview:cancelButton];
}

- (void)addPress:(id)sender {
	[delegate addGroupClicked:[groupName stringValue]];
	[delegate addGroupCancelled:self];
}
- (void)cancelPress:(id)sender {
	[delegate addGroupCancelled:self];
}

- (void)dealloc {
	self.groupLabel = nil;
	self.groupName = nil;
	self.addButton = nil;
	self.cancelButton = nil;
    [super dealloc];
}

@end
