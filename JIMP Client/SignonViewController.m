//
//  SignonViewController.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignonViewController.h"

@implementation SignonViewController

@synthesize usernameIndicator;
@synthesize username;
@synthesize createUsername;
@synthesize passwordIndicator;
@synthesize password;
@synthesize signonButton;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (void)loadView {
	[super loadView];
	
	NSView * mainView = [self view];
	NSFont * labelFont = [NSFont systemFontOfSize:11];
	self.usernameIndicator = [NSTextField labelTextFieldWithFont:labelFont];
	username = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 30, mainView.frame.size.width - 20, 22)];
	createUsername = [[ANLinkButton alloc] initWithFrame:NSMakeRect(10, 50, 130, 14)];
	self.passwordIndicator = [NSTextField labelTextFieldWithFont:labelFont];
	password = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(10, 100, mainView.frame.size.width - 20, 22)];
	signonButton = [[NSButton alloc] initWithFrame:NSMakeRect(mainView.frame.size.width - 90, 130, 80, 25)];
	
	[signonButton setButtonType:NSMomentaryLightButton];
	[signonButton setBezelStyle:NSTexturedSquareBezelStyle];
	[signonButton setTitle:@"Signon"];
	
	[signonButton setTarget:self];
	[signonButton setAction:@selector(signonPressed:)];
	
	[mainView becomeFirstResponder];
	[username becomeFirstResponder];
	[mainView setNextKeyView:password];
	
	[createUsername setTarget:self];
	[createUsername setAction:@selector(showNewScreenname:)];
	[createUsername setButtonText:@"Create a screenname"];
	
	[usernameIndicator setFrame:NSMakeRect(10, 10, 200, 30)];
	[passwordIndicator setFrame:NSMakeRect(10, 100 - 20, 80, 30)];
	
	[usernameIndicator setStringValue:@"Jitsik Screenname"];
	[passwordIndicator setStringValue:@"Password"];
	
	[username setDelegate:self];
	[password setDelegate:self];
	
	[mainView addSubview:usernameIndicator];
	[mainView addSubview:username];
	[mainView addSubview:createUsername];
	[mainView addSubview:passwordIndicator];
	[mainView addSubview:password];
	[mainView addSubview:signonButton];
}

- (BOOL)control:(NSControl*)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertTab:)) {
		if (control == username) {
			[password becomeFirstResponder];
		} else {
			[username becomeFirstResponder];
		}
    } else if (commandSelector == @selector(insertBacktab:)) {
		if (control == username) {
			[password becomeFirstResponder];
		} else {
			[username becomeFirstResponder];
		}
	}
    return NO;
}

- (void)showNewScreenname:(id)sender {
	SignupViewController * snup = [[SignupViewController alloc] init];
	[self presentViewController:snup];
	[snup release];
}

- (void)signonPressed:(id)sender {
	OOTConnection * connection = [[JIMPSessionManager sharedInstance] firstConnection];
	if (!connection) {
		connection = [[JIMPSessionManager sharedInstance] openConnection];
	}
	
	if (connection) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionGotData:) name:OOTConnectionHasObjectNotification object:connection];
		OOTAccount * account = [[OOTAccount alloc] initWithUsername:[username stringValue] password:[password stringValue]];
		if (![connection writeObject:account]) {
			NSAlert * alert = [[NSAlert alloc] init];
			[alert setMessageText:@"The connection has failed."];
			[alert setInformativeText:@"It appears that the Jitsik connection has failed."];
			[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
			[alert autorelease];
		} else {
			LoadingViewController * loadingView = [[LoadingViewController alloc] init];
			[self presentViewControllerNonanimated:loadingView];
			[loadingView release];
		}
		[account release];
	} else {
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setMessageText:@"The connection has failed."];
		[alert setInformativeText:@"Failed to connect to the Jitsik server.  Please try again later."];
		[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
		[alert autorelease];
	}
}
			 
- (void)connectionGotData:(NSNotification *)notificiation {
	OOTConnection * connection = [notificiation object];
	OOTObject * object = [[notificiation userInfo] objectForKey:@"object"];
	if ([[object className] isEqual:@"onln"]) {
		// we are now online
		[self dismissViewController];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:connection];
		NSLog(@"Signon successful.");
		BuddyListViewController * blv = [[BuddyListViewController alloc] init];
		[blv setCurrentUsername:[NSString stringWithString:[username stringValue]]];
		[self presentViewController:blv];
		[blv release];
	} else if ([[object className] isEqual:@"errr"]) {
		// we got an error.
		OOTError * error = [[OOTError alloc] initWithObject:object];

		NSAlert * alert = [[NSAlert alloc] init];
		[alert setMessageText:@"The login failed."];
		[alert setInformativeText:[error errorMessage]];
		[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
		[alert autorelease];
		
		[error release];
		
		[self dismissViewController];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:connection];
		NSLog(@"Signon error.");
	}
}

- (void)presentViewController:(ANViewController *)vc {
	[super presentViewController:vc];
	for (NSView * smallView in [self.view subviews]) {
		if ([smallView isKindOfClass:[NSTextField class]]) {
			[(NSTextField *)smallView setEnabled:NO];
		} else if ([smallView isKindOfClass:[ANLinkButton class]]) {
			[(ANLinkButton *)smallView setIsEnabled:NO];
		} else if ([smallView isKindOfClass:[NSButton class]]) {
			[(NSButton *)smallView setEnabled:NO];
		}
	}
}

- (void)presentViewControllerNonanimated:(ANViewController *)vc {
	[super presentViewControllerNonanimated:vc];
	for (NSView * smallView in [self.view subviews]) {
		if ([smallView isKindOfClass:[NSTextField class]]) {
			[(NSTextField *)smallView setEnabled:NO];
		} else if ([smallView isKindOfClass:[ANLinkButton class]]) {
			[(ANLinkButton *)smallView setIsEnabled:NO];
		} else if ([smallView isKindOfClass:[NSButton class]]) {
			[(NSButton *)smallView setEnabled:NO];
		}
	}
}

- (void)dismissViewController {
	[super dismissViewController];
	for (NSView * smallView in [self.view subviews]) {
		if ([smallView isKindOfClass:[NSTextField class]]) {
			[(NSTextField *)smallView setEnabled:YES];
		} else if ([smallView isKindOfClass:[ANLinkButton class]]) {
			[(ANLinkButton *)smallView setIsEnabled:YES];
		} else if ([smallView isKindOfClass:[NSButton class]]) {
			[(NSButton *)smallView setEnabled:YES];
		}
	}
}

- (void)dealloc {
	self.usernameIndicator = nil;
	self.username = nil;
	self.createUsername = nil;
	self.passwordIndicator = nil;
	self.password = nil;
	self.signonButton = nil;
    [super dealloc];
}

@end
