//
//  BuddyListView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyListView.h"
#import "JIMP_ClientAppDelegate.h"


@implementation BuddyListView

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
	
	self.usernameLabel = [NSTextField labelTextFieldWithFont:[NSFont systemFontOfSize:12]];
	buddyDisplay = [[BuddyListDisplayView alloc] initWithFrame:NSMakeRect(0, 45, self.view.frame.size.width, self.view.frame.size.height - 25)];
	
	[usernameLabel setFrame:NSMakeRect(10, 10, self.view.frame.size.width - 20, 25)];
	[usernameLabel setStringValue:[NSString stringWithFormat:@"Logged in as: %@", currentUsername]];
	
	[self.view addSubview:usernameLabel];
	[self.view addSubview:buddyDisplay];
	
	// here we will query the buddy list.
	OOTObject * object = [[OOTObject alloc] initWithName:@"gbst" data:[NSData data]];
	OOTConnection * connection = [[JIMPSessionManager sharedInstance] firstConnection];
	if (!connection) {
		NSLog(@"Fail.");
		[object release];
		return;
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionGotData:) name:OOTConnectionHasObjectNotification object:connection];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionDidClose:) name:OOTConnectionClosedNotification object:connection];
	[connection writeObject:object];
	currentConnection = [connection retain];
	[object release];
}

- (void)connectionGotData:(NSNotification *)notification {
	OOTObject * object = [[notification userInfo] objectForKey:@"object"];
	// NSLog(@"object: %@", object);
	if ([[object className] isEqual:@"blst"]) {
		OOTBuddyList * blist = [[OOTBuddyList alloc] initWithObject:object];
		for (OOTText * group in [blist groups]) {
			NSLog(@"Group: %@", [group textValue]);
		}
		for (OOTBuddy * buddy in [blist buddies]) {
			NSLog(@"Buddy: %@ (%@)", [buddy screenName], [buddy groupName]);
		}
		BuddyList * buddyList = [[BuddyList alloc] initWithBuddyList:blist];
		[buddyDisplay setBuddyList:buddyList];
		[BuddyList setSharedBuddyList:buddyList];
		[buddyList release];
		[blist release];
	} else if ([[object className] isEqual:@"isrt"]) {
		OOTInsertBuddy * buddyInsert = [[OOTInsertBuddy alloc] initWithObject:object];
		if (!buddyInsert) {
			NSLog(@"Failed to parse isrt object.");
			return;
		}
		if ([BuddyList handleInsert:buddyInsert]) {
			NSLog(@"Buddy list modified: add");
			[buddyDisplay setBuddyList:[BuddyList sharedBuddyList]];
		} else {
			NSLog(@"Buddy list modification failed: add");
		}
	} else if ([[object className] isEqual:@"errr"]) {
		OOTError * error = [[OOTError alloc] initWithObject:object];
		NSString * message = [error errorMessage];
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Error"];
		[alert setInformativeText:message];
		[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
		[alert autorelease];
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
	NSLog(@"Add buddy");
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

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
}

- (void)addBuddyCancelled:(id)sender {
	[NSApp endSheet:sender];
	[sender orderOut:nil];
}

- (void)addBuddy:(NSString *)username toGroup:(NSString *)group {
	// TODO: create a buddy list INSERT object here.
	int index = (int)[[[[BuddyList sharedBuddyList] buddyList] buddies] count];
	OOTBuddy * buddy = [[OOTBuddy alloc] initWithScreenname:username groupName:group];
	OOTInsertBuddy * insert = [[OOTInsertBuddy alloc] initWithIndex:index buddy:buddy];
	[currentConnection writeObject:insert];
	[insert release];
	[buddy release];
}

- (void)closeView:(id)sender {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionClosedNotification object:currentConnection];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:currentConnection];
	[currentConnection release];
	currentConnection = nil;
	[[self parentViewController] dismissViewController];
}

- (void)dealloc {
	[currentConnection release];
	self.currentUsername = nil;
	self.usernameLabel = nil;
	self.signoffButton = nil;
	self.buddyDisplay = nil;
    [super dealloc];
}

@end
