//
//  StatusPickerView.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JIMPStatusHandler.h"

@protocol StatusPickerViewDelegate <NSObject>

- (void)statusPicker:(id)sender setStatus:(OOTStatus *)newStatus;
- (BOOL)statusPicker:(id)sender requestResize:(float)newWidth;

@end

typedef enum {
	StatusPickerViewStateUnselected,
	StatusPickerViewStateEnteringText,
	StatusPickerViewStateMenuDown,
	StatusPickerViewStateHover
} StatusPickerViewState;

@interface StatusPickerView : NSView {
    JIMPStatusHandler * statusHandler;
	OOTStatus * currentStatus;
	
	NSPopUpButton * statusPulldown;
	NSTextField * statusTextPicker;
	
	id<StatusPickerViewDelegate> delegate;
	
	StatusPickerViewState currentState;
}

- (void)setHovering;
- (void)setUnhovering;

@property (nonatomic, assign) id<StatusPickerViewDelegate> delegate;
@property (nonatomic, retain) OOTStatus * currentStatus;

@end
