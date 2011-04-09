//
//  SignupViewController.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANViewController.h"


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

@end
