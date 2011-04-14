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
	
	usernameLabel = [NSTextField labelTextFieldWithFont:[NSFont systemFontOfSize:12]];
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
	[connection writeObject:object];
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
	}
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
	NSLog(@"-sheetDidEnd");
}

- (void)addBuddyCancelled:(id)sender {
	[NSApp endSheet:sender];
	[sender orderOut:nil];
}

- (void)addBuddy:(NSString *)username toGroup:(NSString *)group {
	// TODO: create a buddy list INSERT object here.
}

- (void)dealloc {
	self.currentUsername = nil;
	self.usernameLabel = nil;
	self.signoffButton = nil;
	self.buddyDisplay = nil;
    [super dealloc];
}

@end
