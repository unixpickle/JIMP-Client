//
//  SignonViewController.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSTextField+Label.h"
#import "ANViewController.h"
#import "ANLinkButton.h"

#import "JIMPSessionManager.h"
#import "OOTConnection.h"
#import "OOTObject.h"
#import "OOTAccount.h"
#import "OOTError.h"

#import "SignupViewController.h"
#import "LoadingViewController.h"
#import "BuddyListViewController.h"


@interface SignonViewController : ANViewController <NSTextFieldDelegate> {
    NSTextField * usernameIndicator;
	NSTextField * username;
	ANLinkButton * createUsername;
	NSTextField * passwordIndicator;
	NSSecureTextField * password;
	NSButton * signonButton;
}

@property (nonatomic, retain) NSTextField * usernameIndicator;
@property (nonatomic, retain) NSTextField * username;
@property (nonatomic, retain) ANLinkButton * createUsername;
@property (nonatomic, retain) NSTextField * passwordIndicator;
@property (nonatomic, retain) NSSecureTextField * password;
@property (nonatomic, retain) NSButton * signonButton;

- (void)showNewScreenname:(id)sender;
- (void)signonPressed:(id)sender;
- (void)connectionGotData:(NSNotification *)notification;

@end
