//
//  ANLinkButton.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSTextField+Label.h"


@interface ANLinkButton : NSView {
	NSTextField * label;
	id target;
	SEL action;
}

@property (nonatomic, retain) id target;
@property (readwrite) SEL action;

- (void)setButtonText:(NSString *)text;

@end
