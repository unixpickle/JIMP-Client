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
#import "OOTBuddyList.h"
#import "BuddyListDisplayView.h"


@interface BuddyListView : ANViewController {
	NSString * currentUsername;
	OOTConnection * currentConnection;
	BuddyListDisplayView * buddyDisplay;
	
	NSTextField * usernameLabel;
	NSButton * signoffButton;
}

@property (nonatomic, retain) NSString * currentUsername;
@property (nonatomic, retain) NSTextField * usernameLabel;
@property (nonatomic, retain) NSButton * signoffButton;
@property (nonatomic, retain) BuddyListDisplayView * buddyDisplay;

- (void)connectionGotData:(NSNotification *)notification;

@end
