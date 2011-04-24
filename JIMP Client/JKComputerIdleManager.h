//
//  JKComputerIdleManager.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JKComputerIdleManagerMouseMovedNotification @"JKComputerIdleManagerMouseMovedNotification"
#define JKComputerIdleManagerIdleNotification @"JKComputerIdleManagerComputerIdleNotification"
#define JKComputerIdleManagerActiveNotification @"JKComputerIdleManagerActiveNotification"

@interface JKComputerIdleManager : NSObject {
    NSTimeInterval idleDelay;
	NSTimer * currentTimer;
	CFMachPortRef eventTap;
	NSDate * lastMouseEvent;
	BOOL isIdle;
}

@property (readonly) NSTimeInterval idleDelay;

- (id)initWithIdleDelay:(NSTimeInterval)aDelay;
- (BOOL)startTracking;
- (void)stopTracking;

@end
