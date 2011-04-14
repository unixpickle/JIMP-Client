//
//  AddBuddyWindow.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSTextField+Label.h"


@protocol AddBuddyWindowDelegate <NSObject>

- (void)addBuddy:(NSString *)username toGroup:(NSString *)group;
- (void)addBuddyCancelled:(NSWindow *)sender;

@end

@interface AddBuddyWindow : NSWindow {
    NSTextField * accountName;
	NSPopUpButton * groupOption;
	NSArray * groupNames;
	NSButton * addButton;
	NSButton * cancelButton;
	id<AddBuddyWindowDelegate> delegate;
}

@property (nonatomic, retain) NSTextField * accountName;
@property (nonatomic, retain) NSPopUpButton * groupOption;
@property (nonatomic, retain) NSButton * addButton;
@property (nonatomic, retain) NSButton * cancelButton;
@property (nonatomic, retain) NSArray * groupNames;
@property (nonatomic, retain) id<AddBuddyWindowDelegate> delegate;

- (void)configureContent;
- (void)cancelButton:(id)sender;
- (void)addPress:(id)sender;

@end
