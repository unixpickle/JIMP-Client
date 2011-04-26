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
#import "NSTextField+Label.h"

#import "ANLinkButton.h"

#import "JIMPSessionManager.h"
#import "OOTSignup.h"
#import "OOTError.h"

@protocol SignupViewControllerDelegate

- (void)signupViewControllerDone:(id)sender;

@end

@interface SignupViewController : ANViewController <NSTextFieldDelegate> {
    NSTextField * usernameField;
	NSSecureTextField * passwordField;
	NSSecureTextField * confirmPasswordField;
	NSButton * cancelButton;
	NSButton * createButton;
	id<SignupViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSTextField * usernameField;
@property (nonatomic, retain) NSSecureTextField * passwordField;
@property (nonatomic, retain) NSSecureTextField * confirmPasswordField;
@property (nonatomic, retain) NSButton * cancelButton;
@property (nonatomic, retain) NSButton * createButton;
@property (assign) id<SignupViewControllerDelegate> delegate;

- (void)cancelSignup:(id)sender;
- (void)createPressed:(id)sender;
- (void)connectionGotData:(NSNotification *)notification;

@end
