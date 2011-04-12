//
//  BuddyListView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyListView.h"


@implementation BuddyListView

@synthesize currentUsername;
@synthesize usernameLabel;
@synthesize signoffButton;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (void)loadView {
	[super loadView];
	usernameLabel = [NSTextField labelTextFieldWithFont:[NSFont systemFontOfSize:12]];
	
	[usernameLabel setFrame:NSMakeRect(10, 10, self.view.frame.size.width - 20, 25)];
	[usernameLabel setStringValue:[NSString stringWithFormat:@"Logged in as: %@", currentUsername]];
	
	[self.view addSubview:usernameLabel];
	
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
	NSLog(@"object: %@", object);
	if ([[object className] isEqual:@"blst"]) {
		OOTBuddyList * blist = [[OOTBuddyList alloc] initWithObject:object];
		for (OOTText * group in [blist groups]) {
			NSLog(@"Group: %@", [group textValue]);
		}
		for (OOTBuddy * buddy in [blist buddies]) {
			NSLog(@"Buddy: %@ (%@)", [buddy screenName], [buddy groupName]);
		}
	}
}

- (void)dealloc {
	self.currentUsername = nil;
	self.usernameLabel = nil;
	self.signoffButton = nil;
    [super dealloc];
}

@end
