//
//  BuddyListViewController.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyListViewController.h"
#import "JIMP_ClientAppDelegate.h"


@implementation BuddyListViewController

@synthesize currentUsername;
@synthesize usernameLabel;
@synthesize signoffButton;
@synthesize buddyDisplay;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (void)loadView {
	[super loadView];
	
	JIMP_ClientAppDelegate * appDelegate = (JIMP_ClientAppDelegate *)[[NSApplication sharedApplication] delegate];
	NSMenuItem * addItem = [appDelegate menuItemAddBuddy];
	[addItem setTarget:self];
	[addItem setAction:@selector(addBuddy:)];
	[addItem setEnabled:YES];
	NSMenuItem * addGItem = [appDelegate menuItemAddGroup];
	[addGItem setTarget:self];
	[addGItem setAction:@selector(addGroup:)];
	[addGItem setEnabled:YES];
	NSMenuItem * removeItem = [appDelegate menuItemRemoveBuddy];
	[removeItem setTarget:self];
	[removeItem setAction:@selector(removeBuddy:)];
	[removeItem setEnabled:YES];
	

	
	self.usernameLabel = [NSTextField labelTextFieldWithFont:[NSFont systemFontOfSize:12]];
	buddyDisplay = [[BuddyListDisplayView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width, self.view.frame.size.height - 45)];
	NSBox * line = [[NSBox alloc] initWithFrame:NSMakeRect(-10, self.view.frame.size.height - 44, self.view.frame.size.width + 20, 1)];
	
	[(BuddyOutline *)[buddyDisplay buddyOutline] setBuddyDelegate:self];
	
	[line setBorderType:NSLineBorder];
	[line setBorderWidth:1];
	
	[usernameLabel setFrame:NSMakeRect(10, self.view.frame.size.height - 30, self.view.frame.size.width - 20, 25)];
	[usernameLabel setStringValue:[NSString stringWithFormat:@"Logged in as: %@", currentUsername]];

	[self.view addSubview:line];
	[self.view addSubview:usernameLabel];
	[self.view addSubview:buddyDisplay];
	
	[line release];
	
	OOTConnection * connection = [[JIMPSessionManager sharedInstance] firstConnection];
	NSAssert(connection != nil, @"The connection was closed before the buddy list view was loaded.");
	if (!connection) {
		NSLog(@"ERROR: Connection closed or some such thing.");
		return;
	}
	JIMPBuddyListManager * manager = [[JIMPBuddyListManager alloc] initWithConnection:connection];
	[manager setDelegate:self];
	[manager getBuddylist];
	buddylistManager = manager;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionGotData:) name:OOTConnectionHasObjectNotification object:connection];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionDidClose:) name:OOTConnectionClosedNotification object:connection];
	currentConnection = [connection retain];
}

- (void)buddyListUpdated:(BuddyList *)newBuddylist {
	[buddyDisplay setBuddyList:newBuddylist];
}

- (void)connectionGotData:(NSNotification *)notification {
	OOTObject * object = [[notification userInfo] objectForKey:@"object"];
	// NSLog(@"object: %@", object);
	if ([[object className] isEqual:@"errr"]) {
		OOTError * error = [[OOTError alloc] initWithObject:object];
		NSString * message = [error errorMessage];
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Error"];
		[alert setInformativeText:message];
		[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
		[alert autorelease];
		[error release];
	}
}

- (void)connectionDidClose:(NSNotification *)notification {
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:@"The connection has died."];
	[alert setInformativeText:@"You are no longer connected to a JIMP server.  Please sign back in."];
	[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
	[alert autorelease];
	[self closeView:self];
}

- (void)addBuddy:(id)sender {
	NSRect addBuddyWindowFrame = NSMakeRect(0, 0, 325, 100);
	NSView * contentView = [[ANViewControllerView alloc] initWithFrame:addBuddyWindowFrame];
	AddBuddyWindow * addWindow = [[AddBuddyWindow alloc] initWithContentRect:addBuddyWindowFrame styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO];
	
	[addWindow setDelegate:self];
	[addWindow setGroupNames:[[BuddyList sharedBuddyList] groupNames]];
	[addWindow setContentView:contentView];
	[addWindow configureContent];
		
	[NSApp beginSheet:addWindow modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
	
	[addWindow release];
	[contentView release];
}

- (void)addGroup:(id)sender {
	NSRect addGroupWindowFrame = NSMakeRect(0, 0, 325, 100);
	NSView * contentView = [[ANViewControllerView alloc] initWithFrame:addGroupWindowFrame];
	AddBuddyWindow * addWindow = [[AddGroupWindow alloc] initWithContentRect:addGroupWindowFrame styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO];

	[addWindow setContentView:contentView];
	[addWindow setDelegate:self];
	[addWindow configureContent];
	
	[NSApp beginSheet:addWindow modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
	
	[addWindow release];
	[contentView release];
}

- (void)removeBuddy:(id)sender {
	if ([[buddyDisplay buddyOutline] selectedRow] < 0) {
		NSBeep();
		return;
	}
	
	int index = (int)[[buddyDisplay buddyOutline] selectedRow];
	id item = [[[buddyDisplay buddyOutline] itemAtRow:index] title];
	[self buddyOutlineDeleteBuddy:item];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
}

- (void)addBuddyCancelled:(id)sender {
	[NSApp endSheet:sender];
	[sender orderOut:nil];
}

- (void)addBuddy:(NSString *)username toGroup:(NSString *)group {
	// TODO: create a buddy list INSERT object here.
	int index = (int)[[[[BuddyList sharedBuddyList] buddyList] buddies] count];
	[buddylistManager insertBuddy:username group:group index:index];
}

- (void)addGroupClicked:(NSString *)aGroup {
	int index = (int)[[[[BuddyList sharedBuddyList] buddyList] groups] count];
	[buddylistManager insertGroup:aGroup index:index];
}

- (void)addGroupCancelled:(NSWindow *)sender {
	[NSApp endSheet:sender];
	[sender orderOut:nil];
}

- (void)buddyOutlineDeleteBuddy:(NSString *)buddy {
	[buddylistManager deleteBuddy:buddy];
}

- (void)buddyOutlineDeleteGroup:(NSString *)group {
	[buddylistManager deleteGroup:group];
}

- (void)closeView:(id)sender {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionClosedNotification object:currentConnection];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:currentConnection];
	[currentConnection release];
	currentConnection = nil;
	[buddylistManager stopManaging];
	[buddylistManager release];
	buddylistManager = nil;
	[[self parentViewController] dismissViewController];
	
	JIMP_ClientAppDelegate * appDelegate = (JIMP_ClientAppDelegate *)[[NSApplication sharedApplication] delegate];
	NSMenuItem * addItem = [appDelegate menuItemAddBuddy];
	[addItem setTarget:nil];
	[addItem setEnabled:NO];
	NSMenuItem * addGItem = [appDelegate menuItemAddGroup];
	[addGItem setTarget:nil];
	[addGItem setEnabled:NO];
	NSMenuItem * removeBuddy = [appDelegate menuItemAddGroup];
	[removeBuddy setTarget:nil];
	[removeBuddy setEnabled:NO];
}

- (void)dealloc {
	[currentConnection release];
	[buddylistManager release];
	self.currentUsername = nil;
	self.usernameLabel = nil;
	self.signoffButton = nil;
	self.buddyDisplay = nil;
    [super dealloc];
}

@end