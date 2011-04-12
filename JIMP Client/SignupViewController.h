//
//  SignupViewController.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANViewController.h"
#import "LoadingViewController.h"

#import "ANLinkButton.h"

#import "JIMPSessionManager.h"
#import "OOTSignup.h"
#import "OOTError.h"

@interface SignupViewController : ANViewController <NSTextFieldDelegate> {
    NSTextField * usernameField;
	NSSecureTextField * passwordField;
	NSSecureTextField * confirmPasswordField;
	NSButton * cancelButton;
	NSButton * createButton;
}

@property (nonatomic, retain) NSTextField * usernameField;
@property (nonatomic, retain) NSSecureTextField * passwordField;
@property (nonatomic, retain) NSSecureTextField * confirmPasswordField;
@property (nonatomic, retain) NSButton * cancelButton;
@property (nonatomic, retain) NSButton * createButton;

- (void)cancelSignup:(id)sender;
- (void)createPressed:(id)sender;
- (void)connectionGotData:(NSNotification *)notification;

@end
