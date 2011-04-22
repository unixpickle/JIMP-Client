//
//  StatusPickerView.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JIMPStatusHandler.h"
#import "JKStatusPickerMenuItem.h"


@protocol JKStatusPickerViewDelegate <NSObject>

- (void)statusPicker:(id)sender setStatus:(OOTStatus *)newStatus;
- (BOOL)statusPicker:(id)sender requestResize:(float)newWidth;

@end

typedef enum {
	StatusPickerViewStateUnselected,
	StatusPickerViewStateEnteringText,
	StatusPickerViewStateMenuDown,
	StatusPickerViewStateHover
} StatusPickerViewState;

@interface JKStatusPickerView : NSView <NSMenuDelegate> {
    JIMPStatusHandler * statusHandler;
	OOTStatus * currentStatus;
	
	NSPopUpButton * statusPulldown;
	NSTextField * statusTextPicker;
	NSMutableArray * menuItems;
	
	id<JKStatusPickerViewDelegate> delegate;
	
	StatusPickerViewState currentState;
}

- (void)setHovering;
- (void)setMouseDown;
- (void)setMouseUp;
- (void)setUnhovering;
- (void)menuItemSelected:(NSMenuItem *)item;

- (NSString *)encodedSavePath;
- (void)drawBackgroundComponents;

@property (nonatomic, assign) id<JKStatusPickerViewDelegate> delegate;
@property (nonatomic, retain) OOTStatus * currentStatus;

@end
