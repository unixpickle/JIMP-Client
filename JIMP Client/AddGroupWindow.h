//
//  AddGroupWindow.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSTextField+Label.h"

@protocol AddGroupWindowDelegate <NSObject>

- (void)addGroupClicked:(NSString *)groupName;
- (void)addGroupCancelled:(NSWindow *)sender;

@end


@interface AddGroupWindow : NSWindow {
	NSTextField * groupLabel;
	NSTextField * groupName;
	NSButton * addButton;
	NSButton * cancelButton;
	id<AddGroupWindowDelegate> delegate;
}

@property (nonatomic, retain) NSTextField * groupLabel;
@property (nonatomic, retain) NSTextField * groupName;
@property (nonatomic, retain) NSButton * addButton;
@property (nonatomic, retain) NSButton * cancelButton;
@property (assign) id<AddGroupWindowDelegate> delegate;

- (void)configureContent;
- (void)addPress:(id)sender;
- (void)cancelPress:(id)sender;

@end
