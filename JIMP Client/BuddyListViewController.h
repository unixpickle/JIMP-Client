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
#import "JKBuddyListDisplayView.h"
#import "AddBuddyWindow.h"
#import "AddGroupWindow.h"
#import "JKStatusPickerView.h"

#import "JIMPSessionManager.h"
#import "JIMPBuddyListManager.h"
#import "JIMPStatusHandler.h"

#import "OOTConnection.h"
#import "OOTBuddyList.h"
#import "OOTInsertBuddy.h"
#import "OOTInsertGroup.h"
#import "OOTDeleteGroup.h"
#import "OOTDeleteBuddy.h"
#import "BuddyListItem.h"
#import "JKBuddyOutline.h"
#import "NSView+Translate.h"


@interface BuddyListViewController : ANViewController <AddBuddyWindowDelegate, AddGroupWindowDelegate, JKBuddyOutlineDelegate, JIMPBuddyListManagerDelegate, JIMPStatusHandlerDelegate, JKStatusPickerViewDelegate> {
	NSString * currentUsername;
	OOTConnection * currentConnection;
	JKBuddyListDisplayView * buddyDisplay;
	JIMPBuddyListManager * buddylistManager;
	JIMPStatusHandler * statusHandler;
	JKStatusPickerView * statusPicker;
	
	NSTextField * usernameLabel;
	NSButton * signoffButton;
}

@property (nonatomic, retain) NSString * currentUsername;
@property (nonatomic, retain) NSTextField * usernameLabel;
@property (nonatomic, retain) NSButton * signoffButton;
@property (nonatomic, retain) JKBuddyListDisplayView * buddyDisplay;
@property (nonatomic, retain) JKStatusPickerView * statusPicker;

- (void)connectionGotData:(NSNotification *)notification;
- (void)connectionDidClose:(NSNotification *)notification;

- (void)configureMenuItems;
- (void)configureManagers;
- (void)disableMenuItems;

- (void)addBuddy:(id)sender;
- (void)addGroup:(id)sender;
- (void)removeBuddy:(id)sender;

- (void)mouseMoved:(NSNotification *)notification;
- (void)mouseDown:(NSNotification *)notification;
- (void)mouseUp:(NSNotification *)notification;

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)closeView:(id)sender;
- (void)signOffAndClose:(id)sender;

@end
