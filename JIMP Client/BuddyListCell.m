//
//  BuddyListCell.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuddyListCell.h"


@implementation BuddyListCell

- (void)setBackgroundColor:(NSColor *)aColor {
	[backgroundColor autorelease];
	backgroundColor = [aColor retain];
}

- (NSColor *)backgroundColor {
	return backgroundColor;
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
	BuddyListCell * cell = [[BuddyListCell allocWithZone:zone] initTextCell:[self stringValue]];
	[cell setCurrentStatus:[self currentStatus]];
	[cell setBackgroundColor:[self backgroundColor]];
	return cell;
}

+ (NSArray *)statusImages {
	static NSArray * images = nil;
	if (!images) {
		images = [[NSArray arrayWithObjects:[NSImage imageNamed:@"invisible.png"], [NSImage imageNamed:@"status-away.tiff"], [NSImage imageNamed:@"status-idle.tiff"], [NSImage imageNamed:@"status-available.tiff"], nil] retain];
	}
	return images;
}

+ (NSArray *)statusImagesNoflipped {
	static NSArray * images = nil;
	if (!images) {
		NSArray * flipped = [self statusImages];
		NSMutableArray * copy = [[NSMutableArray alloc] init];
		for (NSImage * image in flipped) {
			NSImage * copyImage = [[NSImage alloc] initWithData:[image TIFFRepresentation]];
			[copy addObject:copyImage];
			[copyImage release];
		}
		images = copy;
	}
	return images;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSRect backgroundFrame = cellFrame;
	NSRect newFrame = cellFrame;
	
	backgroundFrame.origin.x -= 33;
	backgroundFrame.origin.y -= 1;
	backgroundFrame.size.width += 33;
	backgroundFrame.size.height += 1;
	
	newFrame.origin.x -= 15;
	newFrame.origin.y += 8;
	newFrame.size.height -= 8;
	newFrame.size.width += 15;
	
	NSImage * statusImage = nil;
	
	switch ([currentStatus statusType]) {
		case 'o':
			statusImage = [[BuddyListCell statusImages] objectAtIndex:3];
			break;
		case 'a':
			statusImage = [[BuddyListCell statusImages] objectAtIndex:1];
			break;
		case 'i':
			statusImage = [[BuddyListCell statusImages] objectAtIndex:2];
			break;
		default:
			break;
	}
	
	if (backgroundColor) {
		[backgroundColor set];
		if (![self isHighlighted]) {
			NSRectFill(backgroundFrame);
		}
	}
	
	if (statusImage) {		
		[statusImage setFlipped:YES];
		[statusImage drawInRect:NSMakeRect(newFrame.origin.x - 14, newFrame.origin.y + 1, statusImage.size.width, statusImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	}
	
	[super drawWithFrame:newFrame inView:controlView];
}

- (void)setCurrentStatus:(OOTStatus *)aStatus {
	[currentStatus autorelease];
	currentStatus = [aStatus retain];
}

- (OOTStatus *)currentStatus {
	return currentStatus;
}

- (void)dealloc {
	NSLog(@"Dealloc.");
	[self setCurrentStatus:nil];
	self.backgroundColor = nil;
    [super dealloc];
}

@end
