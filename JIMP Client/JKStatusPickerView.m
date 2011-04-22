//
//  StatusPickerView.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKStatusPickerView.h"


@implementation JKStatusPickerView

@synthesize delegate;

static void drawText (NSAttributedString * myString, NSRect frame) {
	NSTextStorage * textStorage = [[[NSTextStorage alloc]
									initWithAttributedString:myString] autorelease];
	NSTextContainer * textContainer = [[[NSTextContainer alloc]
										initWithContainerSize:frame.size] autorelease];
	NSLayoutManager * layoutManager = [[[NSLayoutManager alloc] init]
									   autorelease];
	[layoutManager addTextContainer:textContainer];
	[textStorage addLayoutManager:layoutManager];
	[textContainer setLineFragmentPadding:0.0];
	[layoutManager glyphRangeForTextContainer:textContainer];
	NSPoint newOrigin = NSMakePoint(frame.origin.x + 7, frame.origin.y - 7);
	[layoutManager drawGlyphsForGlyphRange:NSMakeRange(0, [layoutManager numberOfGlyphs]) 
								   atPoint:newOrigin];
}

static float textWidth (NSAttributedString * myString, float height) {
	NSTextStorage * textStorage = [[[NSTextStorage alloc]
									initWithAttributedString:myString] autorelease];
	NSTextContainer * textContainer = [[[NSTextContainer alloc]
										initWithContainerSize:NSMakeSize(FLT_MAX, height)] autorelease];
	NSLayoutManager * layoutManager = [[[NSLayoutManager alloc] init]
									   autorelease];
	[layoutManager addTextContainer:textContainer];
	[textStorage addLayoutManager:layoutManager];
	[textContainer setLineFragmentPadding:0.0];
	[layoutManager glyphRangeForTextContainer:textContainer];
	return ceil([layoutManager
			usedRectForTextContainer:textContainer].size.width);
}

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
		NSArray * myArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self encodedSavePath]];
		if (myArray) {
			menuItems = [[NSMutableArray alloc] initWithArray:myArray];
		} else {
			menuItems = [[NSMutableArray alloc] init];
			OOTStatus * invisible = [[OOTStatus alloc] initWithMessage:@"Invisible" owner:@"" type:'n'];
			OOTStatus * available = [[OOTStatus alloc] initWithMessage:@"Available" owner:@"" type:'o'];
			OOTStatus * away = [[OOTStatus alloc] initWithMessage:@"Away" owner:@"" type:'a'];
			[menuItems addObject:[JKStatusPickerMenuItem menuItemWithStatus:invisible]];
			[menuItems addObject:[JKStatusPickerMenuItem menuItemWithStatus:available]];
			[menuItems addObject:[JKStatusPickerMenuItem menuItemWithStatus:away]];
			[invisible release];
			[available release];
			[away release];
		}
		
		NSRect pulldownFrame = self.bounds;
		
		statusHandler = *[JIMPStatusHandler firstStatusHandler];
		statusPulldown = [[NSPopUpButton alloc] initWithFrame:pulldownFrame pullsDown:YES];
		statusTextPicker = [[NSTextField alloc] initWithFrame:self.bounds];
		
		//[statusPulldown setPullsDown:YES];
		
		[self generateMenuItems];
		
		[[statusPulldown menu] setDelegate:self];
		
		[statusTextPicker setBordered:YES];
		[statusTextPicker setSelectable:YES];
		[statusTextPicker setHidden:YES];
		
		currentState = StatusPickerViewStateUnselected;
		
		[statusPulldown setHidden:YES];
		[self addSubview:statusPulldown];
    }
    return self;
}

- (void)generateMenuItems {
	NSMenuItem * item = [NSMenuItem separatorItem];
	[[statusPulldown menu] addItem:item];
	
	JKStatusPickerMenuItem * lastItem = nil;
	for (JKStatusPickerMenuItem * menuItem in menuItems) {
		if ([[lastItem status] statusType] != [[menuItem status] statusType] && lastItem) {
			NSMenuItem * item = [NSMenuItem separatorItem];
			[[statusPulldown menu] addItem:item];
			
			NSString * title = @"Balls";
			if ([[lastItem status] statusType] == 'n') {
				title = @"Custom Available";
			} else if ([[lastItem status] statusType] == 'o') {
				title = @"Custom Away";
			}
			
			NSMenuItem * customizeItem = [[NSMenuItem alloc] initWithTitle:title action:@selector(menuItemSelected:) keyEquivalent:@""];
			[customizeItem setTarget:self];
			[[statusPulldown menu] addItem:customizeItem];
			[customizeItem release];
		}
		NSMenuItem * newItem = nil;
		if (![menuItem menuItem]) {
			newItem = [[NSMenuItem alloc] initWithTitle:[menuItem statusString] action:@selector(menuItemSelected:) keyEquivalent:@""];
		} else {
			newItem = [[menuItem menuItem] retain];	
		}
		[newItem setTarget:self];
		
		switch ([[menuItem status] statusType]) {
			case 'o':
			{
				NSImage * image = [[BuddyListCell statusImagesNoflipped] objectAtIndex:3];
				[newItem setImage:image];
				break;
			}
			case 'a':
			{
				NSImage * image = [[BuddyListCell statusImagesNoflipped] objectAtIndex:1];
				[newItem setImage:image];
				break;
			}
			case 'n':
			{
				NSImage * image = [[BuddyListCell statusImagesNoflipped] objectAtIndex:0];
				[newItem setImage:image];
				break;
			}
			default:
				break;
		}
		
		[[statusPulldown menu] addItem:newItem];
		[menuItem setMenuItem:newItem];
		[newItem release];
		lastItem = menuItem;
	}
}

- (NSString *)encodedSavePath {
	return [NSString stringWithFormat:@"%@/Library/Preferences/jimpclient_statuses.dat", NSHomeDirectory()];
}

#pragma mark Properties

- (OOTStatus *)currentStatus {
	return currentStatus;
}

- (void)setCurrentStatus:(OOTStatus *)aStatus {
	[currentStatus autorelease];
	currentStatus = [aStatus retain];
	[self setNeedsDisplay:YES];
	BOOL wasFound = NO;
	for (JKStatusPickerMenuItem * item in menuItems) {
		if ([[item status] statusType] == [aStatus statusType]) {
			if ([[[item status] statusMessage] isEqual:[aStatus statusMessage]]) {
				[[item menuItem] setState:1];
				wasFound = YES;
			} else {
				[[item menuItem] setState:0];
			}
		} else {
			[[item menuItem] setState:0];
		}
	}
	if (!wasFound) {
		// TODO: add a new status item.
	}
}

- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
}

- (void)setHovering {
	if (currentState == StatusPickerViewStateHover) return;
	currentState = StatusPickerViewStateHover;
	[self setNeedsDisplay:YES];
}
- (void)setMouseDown {
	if (currentState == StatusPickerViewStateMenuDown) return;
	currentState = StatusPickerViewStateMenuDown;
	[self setNeedsDisplay:YES];
	[statusPulldown performClick:self];
	[self setUnhovering];
}
- (void)setMouseUp {
	if (currentState == StatusPickerViewStateMenuDown) {
		currentState = StatusPickerViewStateUnselected;
		[self setNeedsDisplay:YES];
	}
}
- (void)setUnhovering {
	if (currentState == StatusPickerViewStateUnselected) return;
	currentState = StatusPickerViewStateUnselected;
	[self setNeedsDisplay:YES];
}
- (void)setTypingStatus {
	float width = [[self superview] frame].size.width;
	while (![delegate statusPicker:self requestResize:width]) {
		width -= 10;
	}
	[statusTextPicker setDelegate:self];
	[self setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
	if (currentState == StatusPickerViewStateEnteringText) return;
	currentState = StatusPickerViewStateEnteringText;
	[self setNeedsDisplay:YES];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

#pragma mark User Interface


- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextClearRect(context, CGRectMake(0, 0, self.frame.size.width + 1, self.frame.size.height));
	[super drawRect:dirtyRect];
	
	[[NSColor colorWithDeviceRed:92.9/100.0 green:92.9/100.0 blue:92.9/100.0 alpha:1] set];
	NSRectFill(dirtyRect);
	
	NSColor * textColor = [NSColor blackColor];
	NSFont * font = [NSFont systemFontOfSize:11];
	switch (currentState) {
		case StatusPickerViewStateHover:
		{
			textColor = [NSColor whiteColor];
			break;
		}
		case StatusPickerViewStateMenuDown:
		{
			textColor = [NSColor whiteColor];
			break;
		}
		case StatusPickerViewStateEnteringText:
			[statusTextPicker setFrame:self.bounds];
			[statusTextPicker setHidden:NO];
			if (![statusTextPicker superview]) {
				[self addSubview:statusTextPicker];
			}
			[statusTextPicker setTarget:self];
			[statusTextPicker setAction:@selector(textFieldEnter:)];
			return; // return, no drawing to do.
			break;
		default:
			break;
	}
	
	NSString * myString = [[[NSString alloc] initWithFormat:@"%@", [currentStatus statusMessage]] autorelease];
	if ([myString isEqual:@""] || [currentStatus statusMessage] == nil) {
		if ([currentStatus statusType] == 'n') {
			myString = @"Offline";
		} else if ([currentStatus statusType] == 'a') {
			myString = @"Away";
		} else if ([currentStatus statusType] == 'o') {
			myString = @"Available";
		} else if ([currentStatus statusType] == 'i') {
			myString = [NSString stringWithFormat:@"Idle %d minutes", [currentStatus idleTime] / 60];
		}
	}
	
	NSMutableParagraphStyle * pSt = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								 font, NSFontAttributeName,
								 textColor, NSForegroundColorAttributeName,
								 pSt, NSParagraphStyleAttributeName, nil];
	NSAttributedString * as = [[NSAttributedString alloc] initWithString:myString
															  attributes:attributes];
	[pSt release];
	
	float width = textWidth(as, self.frame.size.height);
	if (![delegate statusPicker:self requestResize:width + 20]) {
		// we cannot resize ourselves
		while ([myString length] != 0) {
			NSString * newString = [myString substringToIndex:[myString length] - 1];
			[as release];
			as = [[NSAttributedString alloc] initWithString:[newString stringByAppendingFormat:@"..."]
												 attributes:attributes];
			width = textWidth(as, self.frame.size.height);
			if ([delegate statusPicker:self requestResize:width + 20]) {
				break;
			} else {
				myString = newString;
			}
		}
	}
	
	NSRect frame = self.frame;
	frame.size.width = width + 20;
	[self setFrame:frame];
	[self drawBackgroundComponents];
	drawText(as, self.bounds);
	[as release];
}

- (void)drawBackgroundComponents {
	NSImage * expand = nil;
	switch (currentState) {
		case StatusPickerViewStateHover:
		{
			expand = [NSImage imageNamed:@"smallexpand_h.png"];
			CGFloat radius = self.frame.size.height / 2;
			NSColor * color = [NSColor colorWithDeviceRed:0.549 green:0.549 blue:0.549 alpha:1];
			[color set];
			NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:radius yRadius:radius];
			
			[path fill];
			break;
		}
		case StatusPickerViewStateMenuDown:
		{
			expand = [NSImage imageNamed:@"smallexpand_h.png"];
			CGFloat radius = self.frame.size.height / 2;
			NSColor * color = [NSColor colorWithDeviceRed:0.349 green:0.349 blue:0.349 alpha:1];
			[color set];
			NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:radius yRadius:radius];
			
			[path fill];
			break;
		}
		case StatusPickerViewStateEnteringText:

			break;
		default:
			expand = [NSImage imageNamed:@"smallexpand.png"];
			break;
	}
	[expand drawInRect:NSMakeRect(self.frame.size.width - (expand.size.width + 2), 4, expand.size.width, expand.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

#pragma mark Text Field

- (void)textFieldEnter:(id)sender {
	[statusTextPicker setHidden:YES];
	int insertIndex = 0;
	if (enteringStatusType == 'o') {
		for (int i = 0; i < [menuItems count]; i++) {
			JKStatusPickerMenuItem * menuItem = [menuItems objectAtIndex:i];
			insertIndex = i;
			if ([[menuItem status] statusType] == 'a') break;
		}
	} else if (enteringStatusType == 'a') {
		insertIndex = [menuItems count];
	}
	OOTStatus * newStatus = [[OOTStatus alloc] initWithMessage:[statusTextPicker stringValue] owner:@"" type:enteringStatusType];
	JKStatusPickerMenuItem * menuItem = [JKStatusPickerMenuItem menuItemWithStatus:newStatus];
	[menuItems insertObject:menuItem atIndex:insertIndex];
	[statusPulldown removeAllItems];
	[self generateMenuItems];
	[self setUnhovering];
	[self setCurrentStatus:newStatus];
	[newStatus release];
	[statusTextPicker setStringValue:@""];
	[statusTextPicker removeFromSuperview];
	[NSKeyedArchiver archiveRootObject:menuItems toFile:[self encodedSavePath]];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command {
    if (command == @selector(cancelOperation:)) {
		[statusTextPicker setHidden:YES];
		[statusTextPicker setStringValue:@""];
		[statusTextPicker removeFromSuperview];
        [self setUnhovering];
    }
    return NO;
}

#pragma mark Menu

- (void)menuItemSelected:(NSMenuItem *)anItem {
	BOOL found = NO;
	for (JKStatusPickerMenuItem * item in menuItems) {
		if (anItem == [item menuItem]) {
			found = YES;
		}
	}
	if (!found) {
		[anItem setState:0];
		if ([[anItem title] isEqual:@"Custom Available"]) {
			enteringStatusType = 'o';
			[self setTypingStatus];
		} else if ([[anItem title] isEqual:@"Custom Away"]) {
			enteringStatusType = 'a';
			[self setTypingStatus];
		}
		return;
	}
	for (JKStatusPickerMenuItem * item in menuItems) {
		if (anItem == [item menuItem]) {
			// set the status
			[delegate statusPicker:self setStatus:[item status]];
		} else {
			[[item menuItem] setState:0];
		}
	}
}

- (void)menuDidClose:(NSMenu *)menu {
	[self setUnhovering];
}

#pragma mark Dealloc

- (void)dealloc {
	[menuItems release];
	[currentStatus release];
	[statusPulldown release];
	[statusTextPicker release];
    [super dealloc];
}

@end
