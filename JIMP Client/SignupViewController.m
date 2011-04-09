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

	usernameField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, frame.size.width - 20, 25)];
	passwordField = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(10, 45, frame.size.width - 20, 25)];
	confirmPasswordField = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(10, 80, frame.size.width - 20, 25)];
	createButton = [[NSButton alloc] initWithFrame:NSMakeRect(frame.size.width - 90, 115, 80, 25)];
	cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(10, 115, 80, 25)];
	
	[usernameField becomeFirstResponder];
	
	[createButton setButtonType:NSMomentaryLightButton];
	[createButton setBezelStyle:NSTexturedSquareBezelStyle];
	[createButton setTitle:@"Create"];
	
	[cancelButton setButtonType:NSMomentaryLightButton];
	[cancelButton setBezelStyle:NSTexturedSquareBezelStyle];
	[cancelButton setTitle:@"Cancel"];
	
	[cancelButton setTarget:self];
	[cancelButton setAction:@selector(cancelSignup:)];
	
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
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
	if (commandSelector == @selector(insertTab:)) {
		if (control == usernameField) {
			[passwordField becomeFirstResponder];
		} else if (control == passwordField) {
			[confirmPasswordField becomeFirstResponder];
		} else if (control == confirmPasswordField) {
			[usernameField becomeFirstResponder];
		}
    } else if (commandSelector == @selector(insertBacktab:)) {
		if (control == confirmPasswordField) {
			[passwordField becomeFirstResponder];
		} else if (control == usernameField) {
			[confirmPasswordField becomeFirstResponder];
		} else if (control == passwordField) {
			[usernameField becomeFirstResponder];
		}
	}
	return NO;
}

- (void)cancelSignup:(id)sender {
	[[self parentViewController] dismissViewController];
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
