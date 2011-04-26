//
//  JKComputerIdleManager.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JKComputerIdleManager.h"

@interface JKComputerIdleManager (private)

- (void)mouseMovedNotification:(id)aNotification;
- (void)timerFire:(id)userInfo;
+ (id)globalObject;

@end

@implementation JKComputerIdleManager

CGEventRef myCGEventCallback (CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
	// mouse moved
	[[NSNotificationCenter defaultCenter] postNotificationName:JKComputerIdleManagerMouseMovedNotification object:[JKComputerIdleManager globalObject]];
	return event;
}

@synthesize idleDelay;

+ (id)globalObject {
	static id anObject = nil;
	if (!anObject) anObject = [[NSObject alloc] init];
	return anObject;
}

- (id)init {
    if ((self = [super init])) {
        idleDelay = 60.0;
    }
    return self;
}

- (id)initWithIdleDelay:(NSTimeInterval)aDelay {
	if ((self = [super init])) {
		idleDelay = aDelay;
	}
	return self;
}
- (BOOL)startTracking {
	if (eventTap) return NO;	
    CFRunLoopSourceRef runLoopSource;
	CGEventFlags emask;
	/*
    // We only want one kind of event at the moment: The mouse has moved
    emask = CGEventMaskBit(kCGEventKeyDown);
	
    // Create the Tap
    CFMachPortRef myEventTap = CGEventTapCreate (
								   kCGSessionEventTap, // Catch all events for current user session
								   kCGTailAppendEventTap, // Append to end of EventTap list
								   kCGEventTapOptionListenOnly, // We only listen, we don't modify
								   emask,
								   &myCGEventCallback,
								   NULL // We need no extra data in the callback
								   );
	
    // Create a RunLoop Source for it
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, myEventTap, 0);
	
    // Add the source to the current RunLoop
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
	*/
	emask = CGEventMaskBit(kCGEventMouseMoved);
	eventTap = CGEventTapCreate(kCGSessionEventTap, kCGTailAppendEventTap, kCGEventTapOptionListenOnly, emask, &myCGEventCallback, NULL);
	if (!eventTap) {
		return NO;
	}
	
	runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
	CFRelease(runLoopSource);

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mouseMovedNotification:) name:JKComputerIdleManagerMouseMovedNotification object:[JKComputerIdleManager globalObject]];
	
	[currentTimer invalidate];
	[currentTimer release];
	currentTimer = [[NSTimer timerWithTimeInterval:10 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES] retain];
	[[NSRunLoop currentRunLoop] addTimer:currentTimer forMode:NSDefaultRunLoopMode];
	[lastMouseEvent release];
	lastMouseEvent = [[NSDate date] retain];
	return YES;
}
- (void)stopTracking {
	if (eventTap) {
		CGEventTapEnable(eventTap, false);
		CFRelease(eventTap);
		eventTap = nil;
	}
	[currentTimer invalidate];
	[currentTimer release];
	currentTimer = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:JKComputerIdleManagerMouseMovedNotification object:[JKComputerIdleManager globalObject]];
	[lastMouseEvent release];
	lastMouseEvent = nil;
}

- (void)mouseMovedNotification:(id)aNotification {
	[currentTimer invalidate];
	[currentTimer release];
	currentTimer = [[NSTimer timerWithTimeInterval:10 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES] retain];
	[lastMouseEvent release];
	lastMouseEvent = [[NSDate date] retain];
	[[NSRunLoop currentRunLoop] addTimer:currentTimer forMode:NSDefaultRunLoopMode];
	if (isIdle) {
		isIdle = NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:JKComputerIdleManagerActiveNotification object:self];
	}
	 
}

- (void)timerFire:(id)userInfo {
	NSTimeInterval idleTime = [[NSDate date] timeIntervalSinceDate:lastMouseEvent];
	if (idleTime >= idleDelay) {
		isIdle = YES;
		NSDictionary * info = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:idleTime] forKey:@"timeInterval"];
		[[NSNotificationCenter defaultCenter] postNotificationName:JKComputerIdleManagerIdleNotification object:self userInfo:info];
	}
}

- (void)dealloc {
	[currentTimer invalidate];
	[currentTimer release];
	[lastMouseEvent release];
    [super dealloc];
}

@end
