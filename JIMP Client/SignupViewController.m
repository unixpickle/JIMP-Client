//
//  SignupViewController.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignupViewController.h"


@implementation SignupViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize confirmPasswordField;
@synthesize cancelButton;
@synthesize createButton;
@synthesize delegate;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (void)loadView {
	[super loadView];
	
	NSView * newView = [self view];
	
	// set the new size.
	NSRect frame = [newView frame];
	frame.size.width = 320;
	[newView setFrame:frame];
	
	NSFont * sysFont = [NSFont systemFontOfSize:[NSFont systemFontSize]];

	usernameField = [[NSTextField alloc] initWithFrame:NSMakeRect(100, 10, frame.size.width - 110, 23)];
	passwordField = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(100, 45, frame.size.width - 110, 23)];
	confirmPasswordField = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(100, 80, frame.size.width - 110, 23)];
	createButton = [[NSButton alloc] initWithFrame:NSMakeRect(frame.size.width - 90, 115, 80, 25)];
	cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(10, 115, 80, 25)];
	NSTextField * usernameFieldPrompt = [NSTextField labelTextFieldWithFont:sysFont];
	NSTextField * passwordFieldPrompt = [NSTextField labelTextFieldWithFont:sysFont];
	NSTextField * confirmFieldPrompt = [NSTextField labelTextFieldWithFont:sysFont];
	
	[usernameFieldPrompt setFrame:NSMakeRect(10, 12, 85, 25)];
	[usernameFieldPrompt setStringValue:@"Screenname:"];
	
	[passwordFieldPrompt setFrame:NSMakeRect(10, 48, 85, 25)];
	[passwordFieldPrompt setStringValue:@"Password:"];
	
	[confirmFieldPrompt setFrame:NSMakeRect(10, 83, 85, 25)];
	[confirmFieldPrompt setStringValue:@"Confirm:"];
	
	[usernameFieldPrompt setAlignment:NSRightTextAlignment];
	[passwordFieldPrompt setAlignment:NSRightTextAlignment];
	[confirmFieldPrompt setAlignment:NSRightTextAlignment];
	
	[usernameField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
	
	[createButton setButtonType:NSMomentaryLightButton];
	[createButton setBezelStyle:NSTexturedSquareBezelStyle];
	[createButton setTitle:@"Create"];
	
	[cancelButton setButtonType:NSMomentaryLightButton];
	[cancelButton setBezelStyle:NSTexturedSquareBezelStyle];
	[cancelButton setTitle:@"Cancel"];
	
	[cancelButton setTarget:self];
	[cancelButton setAction:@selector(cancelSignup:)];
	
	[createButton setTarget:self];
	[createButton setAction:@selector(createPressed:)];
	
	[[usernameField cell] setPlaceholderString:@"Desired Screenname"];
	[[passwordField cell] setPlaceholderString:@"Password"];
	[[confirmPasswordField cell] setPlaceholderString:@"Re-type Password"];
	
	[usernameField setDelegate:self];
	[passwordField setDelegate:self];
	[confirmPasswordField setDelegate:self];
	
	[newView addSubview:usernameField];
	[newView addSubview:passwordField];
	[newView addSubview:confirmPasswordField];
	[newView addSubview:cancelButton];
	[newView addSubview:createButton];
	[newView addSubview:usernameFieldPrompt];
	[newView addSubview:passwordFieldPrompt];
	[newView addSubview:confirmFieldPrompt];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
	if (commandSelector == @selector(insertTab:)) {
		if (control == usernameField) {
			[passwordField selectText:self];
		} else if (control == passwordField) {
			[confirmPasswordField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
		} else if (control == confirmPasswordField) {
			[usernameField becomeFirstResponder];
		}
    } else if (commandSelector == @selector(insertBacktab:)) {
		if (control == confirmPasswordField) {
			[passwordField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
		} else if (control == usernameField) {
			[confirmPasswordField becomeFirstResponder];
		} else if (control == passwordField) {
			[usernameField becomeFirstResponder];
		}
	}
	return NO;
}

- (void)cancelSignup:(id)sender {
	[delegate signupViewControllerDone:self];
}

- (void)createPressed:(id)sender {
	if (![[passwordField stringValue] isEqual:[confirmPasswordField stringValue]]) {
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Password mismatch"];
		[alert setInformativeText:@"The passwords that you entered did not match.  Please retype your password in both password fields, making sure that they are the same."];
		[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
		[alert autorelease];
		return;
	}
	
	OOTConnection * connection = [[JIMPSessionManager sharedInstance] firstConnection];
	if (!connection) {
		connection = [[JIMPSessionManager sharedInstance] openConnection];
	}
	if (connection) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionGotData:) name:OOTConnectionHasObjectNotification object:connection];
		OOTSignup * signup = [[OOTSignup alloc] initWithUsername:[usernameField stringValue]
														password:[passwordField stringValue]];
		if (![connection writeObject:signup]) {
			NSAlert * alert = [[NSAlert alloc] init];
			[alert setMessageText:@"Connection closed."];
			[alert setInformativeText:@"The current Jitsik connection has been closed.  Please try again later."];
			[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
			[alert autorelease];
		} else {
			LoadingViewController * loadingView = [[LoadingViewController alloc] init];
			[self presentViewControllerNonanimated:loadingView];
			[loadingView release];
		}
		[signup release];
	} else {
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setMessageText:@"The signup failed."];
		[alert setInformativeText:@"Could not establish a connection with the Jitsik server.  Please try again later."];
		[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
		[alert autorelease];
	}
}

- (void)connectionGotData:(NSNotification *)notification {
	OOTConnection * connection = [notification object];
	OOTObject * object = [[notification userInfo] objectForKey:@"object"];
	if ([[object className] isEqual:@"aded"]) {
		[self dismissViewController];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:connection];
		
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Signup success"];
		[alert setInformativeText:@"The account has been created.  Click done and sign in with your new account!"];
		[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
		[alert autorelease];
	} else if ([[object className] isEqual:@"errr"]) {
		// we got an error.
		OOTError * error = [[OOTError alloc] initWithObject:object];
		
		NSAlert * alert = [[NSAlert alloc] init];
		[alert setMessageText:@"The signup failed."];
		[alert setInformativeText:[error errorMessage]];
		[alert beginSheetModalForWindow:[self window] modalDelegate:nil didEndSelector:0 contextInfo:NULL];
		[alert autorelease];
		
		[error release];
		
		[self dismissViewController];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:connection];
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
	self.usernameField = nil;
	self.passwordField = nil;
	self.confirmPasswordField = nil;
	self.cancelButton = nil;
	self.createButton = nil;
    [super dealloc];
}

@end
