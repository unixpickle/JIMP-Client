//
//  BuddyListView.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANViewController.h"
#import "OOTConnection.h"
#import "NSTextField+Label.h"
#import "JIMPSessionManager.h"


@interface BuddyListView : ANViewController {
	NSString * currentUsername;
	OOTConnection * currentConnection;
	
	NSTextField * usernameLabel;
	NSButton * signoffButton;
}

@property (nonatomic, retain) NSString * currentUsername;
@property (nonatomic, retain) NSTextField * usernameLabel;
@property (nonatomic, retain) NSButton * signoffButton;

- (void)connectionGotData:(NSNotification *)notification;

@end
