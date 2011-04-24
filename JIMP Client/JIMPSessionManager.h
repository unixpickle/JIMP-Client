//
//  JIMPSessionManager.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTConnection.h"

#define kJIMPHost @"127.0.0.1"
#define kJIMPPort 1338

/**
 * Manage multiple connections at once.
 * Generally, there should only be
 * one open connection anyway, but
 * this helps for that too.
 */
@interface JIMPSessionManager : NSObject {
    NSMutableArray * connections;
}

/**
 * Get the shared manager.  Creates it if it does
 * not exist.
 * @return The shared instance.
 */
+ (JIMPSessionManager *)sharedInstance;

/**
 * Open a new connection.
 * @return The autorelease'd connection.
 */
- (OOTConnection *)openConnection;

/**
 * Gets the first connection that is open.
 * This should only be used when dealing with
 * one connection.
 * @return the first connection that is open.
 */
- (OOTConnection *)firstConnection;

/**
 * Called by connections to tell the manager that they are closed.
 */
- (void)connectionDisconnected:(NSNotification *)notification;

/**
 * Returns an array of the connections that are being managed.
 */
- (NSArray *)connections;

@end
