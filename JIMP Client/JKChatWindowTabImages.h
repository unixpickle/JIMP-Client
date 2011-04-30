//
//  JKChatWindowTabImages.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct {
	
	NSImage * regularLeft;
	NSImage * regularCenter;
	NSImage * regularRight;
	
} JKChatWindowTabImages;

static void JKChatWindowTabImagesRelease (JKChatWindowTabImages images) {
	[images.regularRight release];
	[images.regularLeft release];
	[images.regularCenter release];
}
