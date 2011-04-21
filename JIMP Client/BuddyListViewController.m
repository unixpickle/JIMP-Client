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
@synthesize statusPicker;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (void)loadView {
	[super loadView];
	[self configureMenuItems];
	
	buddyDisplay = [[BuddyListDisplayView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width, self.view.frame.size.height - 45)];
	statusPicker = [[StatusPickerView alloc] initWithFrame:NSMakeRect(10, self.view.frame.size.height - 35, 20, 15)];
	signoffButton = [[NSButton alloc] initWithFrame:NSMakeRect(self.view.frame.size.width - 90, self.view.frame.size.height - 35, 80, 25)];
	NSBox * line = [[NSBox alloc] initWithFrame:NSMakeRect(-10, self.view.frame.size.height - 44, self.view.frame.size.width + 20, 1)];
	self.usernameLabel = [NSTextField labelTextFieldWithFont:[NSFont systemFontOfSize:12]];
	
	[(BuddyOutline *)[buddyDisplay buddyOutline] setBuddyDelegate:self];
	[line setBorderType:NSLineBorder];
	[line setBoxType:NSBoxSeparator];
	[line setBorderWidth:2];
	
	[signoffButton setTitle:@"Gtfo"];
	[signoffButton setTarget:self];
	[signoffButton setAction:@selector(signOffAndClose:)];
	
	[usernameLabel setFrame:NSMakeRect(10, self.view.frame.size.height - 30, self.view.frame.size.width - 20, 25)];
	[usernameLabel setStringValue:[NSString stringWithFormat:@"Logged in as: %@", currentUsername]];
	[usernameLabel setHidden:YES];
	
	OOTStatus * myStatus = [[OOTStatus alloc] initWithMessage:@"" owner:nil type:'n'];
	[statusPicker setCurrentStatus:myStatus];
	[statusPicker setDelegate:self];
	[myStatus release];

	[self.view addSubview:line];
	[self.view addSubview:usernameLabel];
	[self.view addSubview:buddyDisplay];
	[self.view addSubview:statusPicker];
	[self.view addSubview:signoffButton];
	
	[line release];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mouseMoved:) name:ANViewControllerViewMouseMovedNotification object:self.view];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mouseDown:) name:ANViewControllerViewMouseDownNotification object:self.view];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mouseUp:) name:ANViewControllerViewMouseUpNotification object:self.view];
	
	[self configureManagers];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionGotData:) name:OOTConnectionHasObjectNotification object:currentConnection];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionDidClose:) name:OOTConnectionClosedNotification object:currentConnection];
	
	OOTStatus * status = [[OOTStatus alloc] initWithMessage:@"Available" owner:@"" type:'o'];
	[statusHandler setStatus:status];
	[status release];
}

- (void)configureMenuItems {
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
}
- (void)configureManagers {
	OOTConnection * connection = [[JIMPSessionManager sharedInstance] firstConnection];
	NSAssert(connection != nil, @"The connection was closed before the buddy list view was loaded.");
	JIMPBuddyListManager * manager = [[JIMPBuddyListManager alloc] initWithConnection:connection];
	[manager setDelegate:self];
	[manager getBuddylist];
	buddylistManager = manager;
	
	statusHandler = [[JIMPStatusHandler alloc] initWithConnection:connection];
	[statusHandler setDelegate:self];
	
	currentConnection = [connection retain];
}
- (void)disableMenuItems {
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

#pragma mark Buddy List Handler

- (void)buddyListUpdated:(BuddyList *)newBuddylist {
	NSLog(@"-buddyListUpdated:");
	[buddyDisplay setBuddyList:newBuddylist];
}

#pragma mark Connection

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
	NSLog(@"Got object class: %@", [object className]);
}

- (void)connectionDidClose:(NSNotification *)notification {
	NSAlert * alert = [[NSAlert alloc] init];
	[alert setMessageText:@"The connection has died."];
	[alert setInformativeText:@"You are no longer connected to a JIMP server.  Please sign back in."];
	[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
	[alert autorelease];
	[self closeView:self];
}

#pragma mark UI Events

- (void)addBuddy:(id)sender {
	NSRect addBuddyWindowFrame = NSMakeRect(0, 0, 325, 100);
	NSView * contentView = [[ANViewControllerView alloc] initWithFrame:addBuddyWindowFrame];
	AddBuddyWindow * addWindow = [[AddBuddyWindow alloc] initWithContentRect:addBuddyWindowFrame styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO];
	
	[addWindow setDelegate:self];
	[addWindow setGroupNames:[[JIMPBuddyListManager sharedBuddyList] groupNames]];
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

- (void)addGroupCancelled:(NSWindow *)sender {
	[NSApp endSheet:sender];
	[sender orderOut:nil];
}

- (void)closeView:(id)sender {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionClosedNotification object:currentConnection];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:currentConnection];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ANViewControllerViewMouseMovedNotification object:self.view];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ANViewControllerViewMouseDownNotification object:self.view];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ANViewControllerViewMouseUpNotification object:self.view];
	[currentConnection release];
	currentConnection = nil;
	[buddylistManager stopManaging];
	[buddylistManager release];
	buddylistManager = nil;
	[statusHandler stopManaging];
	[statusHandler release];
	statusHandler = nil;
	
	[self disableMenuItems];
	
	[[self parentViewController] dismissViewController];
}

- (void)signOffAndClose:(id)sender {
	OOTObject * snof = [[OOTObject alloc] initWithName:@"snof" data:[NSData data]];
	[currentConnection writeObject:snof];
	[snof release];
	[self closeView:nil];
}

#pragma mark Mouse Events

- (void)mouseMoved:(NSNotification *)notification {
	NSEvent * theEvent = [[notification userInfo] objectForKey:@"event"];
	NSPoint point = [theEvent locationInWindow];
	NSRect selfLocation = [statusPicker translateBoundsToWindow];
	if (NSPointInRect(point, selfLocation)) {
		[statusPicker setHovering];
	} else [statusPicker setUnhovering];
}

- (void)mouseDown:(NSNotification *)notification {
	NSEvent * theEvent = [[notification userInfo] objectForKey:@"event"];
	NSPoint point = [theEvent locationInWindow];
	NSRect selfLocation = [statusPicker translateBoundsToWindow];
	if (NSPointInRect(point, selfLocation)) {
		[statusPicker setMouseDown];
	} else {
		[statusPicker setMouseUp];
	}
}

- (void)mouseUp:(NSNotification *)notification {
	NSEvent * theEvent = [[notification userInfo] objectForKey:@"event"];
	NSPoint point = [theEvent locationInWindow];
	NSRect selfLocation = [statusPicker translateBoundsToWindow];
	if (NSPointInRect(point, selfLocation)) {
		[statusPicker setHovering];
	} else {
		[statusPicker setMouseUp];
	}
}

#pragma mark Buddy Operations (Work)

- (void)addBuddy:(NSString *)username toGroup:(NSString *)group {
	int index = (int)[[[[JIMPBuddyListManager sharedBuddyList] buddyList] buddies] count];
	[buddylistManager insertBuddy:username group:group index:index];
}

- (void)addGroupClicked:(NSString *)aGroup {
	int index = (int)[[[[JIMPBuddyListManager sharedBuddyList] buddyList] groups] count];
	[buddylistManager insertGroup:aGroup index:index];
}


- (void)buddyOutlineDeleteBuddy:(NSString *)buddy {
	[buddylistManager deleteBuddy:buddy];
}

- (void)buddyOutlineDeleteGroup:(NSString *)group {
	[buddylistManager deleteGroup:group];
}

#pragma mark Statuses

- (void)statusHandler:(id)sender gotStatus:(OOTStatus *)aStatus previousStatus:(OOTStatus *)anotherStatus {
	[JIMPBuddyListManager regenerateBuddyList];
	[buddyDisplay setBuddyList:[JIMPBuddyListManager sharedBuddyList]];
	if ([[aStatus owner] isEqual:[currentUsername lowercaseString]]) {
		[statusPicker setCurrentStatus:aStatus];
	}
}

- (void)statusPicker:(id)sender setStatus:(OOTStatus *)newStatus {
	[currentConnection writeObject:newStatus];
	[self.view setNeedsDisplay:YES];
}

- (BOOL)statusPicker:(id)sender requestResize:(float)newWidth {
	NSView * theView = (NSView *)sender;
	if ([theView frame].origin.x + newWidth > self.view.frame.size.width - 10) {
		return NO;
	}
	return YES;
}

- (void)dealloc {
	[currentConnection release];
	[buddylistManager release];
	[statusHandler release];
	self.currentUsername = nil;
	self.usernameLabel = nil;
	self.signoffButton = nil;
	self.buddyDisplay = nil;
	self.statusPicker = nil;
    [super dealloc];
}

@end
