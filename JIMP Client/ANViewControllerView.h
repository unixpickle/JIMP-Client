//
//  ANViewControllerView.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define ANViewControllerViewMouseMovedNotification @"ANViewControllerViewMouseMovedNotification"
#define ANViewControllerViewMouseDownNotification @"ANViewControllerViewMouseDownNotification"
#define ANViewControllerViewMouseUpNotification @"ANViewControllerViewMouseUpNotification"

@interface ANViewControllerView : NSView {
    NSColor * backgroundColor;
}

- (void)setBackgroundColor:(NSColor *)aColor;

@end
