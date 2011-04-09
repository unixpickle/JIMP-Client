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
	createUsername = [[ANLinkButton alloc] initWithFrame:NSMakeRect(10, 50, 200, 17)];
	self.passwordIndicator = [NSTextField labelTextFieldWithFont:labelFont];
	password = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(10, 100, mainView.frame.size.width - 20, 22)];
	
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

- (void)dealloc {
	self.usernameIndicator = nil;
	self.username = nil;
	self.createUsername = nil;
	self.passwordIndicator = nil;
	self.password = nil;
    [super dealloc];
}

@end
