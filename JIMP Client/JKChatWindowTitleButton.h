//
//  JKChatWindowTitleButton.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define JKChatWindowTitleButtonStateActive @"-active-color.tiff"
#define JKChatWindowTitleButtonStateActiveNokey @"-activenokey-color.tiff"
#define JKChatWindowTitleButtonStatePress @"-pd-color.tiff"
#define JKChatWindowTitleButtonStateRollover @"-rollover-color.tiff"

@interface JKChatWindowTitleButton : NSObject {
    NSRect buttonFrame;
	NSMutableDictionary * buttonImages;
}

@property (readwrite) NSRect buttonFrame;

/**
 * Creates a title button with a name.
 * @param buttonName The name of the file, for instance "close" or "minimize"
 * @return A new chat window title button with the state images loaded.
 */
- (id)initWithPrefix:(NSString *)buttonName;

- (NSImage *)imageWithState:(NSString *)buttonState;

@end
