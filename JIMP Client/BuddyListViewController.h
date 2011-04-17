//
//  BuddyListViewController.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANViewController.h"
#import "NSTextField+Label.h"
#import "BuddyListDisplayView.h"
#import "AddBuddyWindow.h"
#import "AddGroupWindow.h"

#import "JIMPSessionManager.h"
#import "JIMPBuddyListManager.h"
#import "OOTConnection.h"
#import "OOTBuddyList.h"
#import "OOTInsertBuddy.h"
#import "OOTInsertGroup.h"
#import "OOTDeleteGroup.h"
#import "OOTDeleteBuddy.h"
#import "BuddyListItem.h"
#import "BuddyOutline.h"


@interface BuddyListViewController : ANViewController <AddBuddyWindowDelegate, AddGroupWindowDelegate, BuddyOutlineDelegate, JIMPBuddyListManagerDelegate> {
	NSString * currentUsername;
	OOTConnection * currentConnection;
	BuddyListDisplayView * buddyDisplay;
	JIMPBuddyListManager * buddylistManager;
	
	NSTextField * usernameLabel;
	NSButton * signoffButton;
}

@property (nonatomic, retain) NSString * currentUsername;
@property (nonatomic, retain) NSTextField * usernameLabel;
@property (nonatomic, retain) NSButton * signoffButton;
@property (nonatomic, retain) BuddyListDisplayView * buddyDisplay;

- (void)connectionGotData:(NSNotification *)notification;
- (void)connectionDidClose:(NSNotification *)notification;

- (void)addBuddy:(id)sender;
- (void)addGroup:(id)sender;
- (void)removeBuddy:(id)sender;

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)closeView:(id)sender;

@end
