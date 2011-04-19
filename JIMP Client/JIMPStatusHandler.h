//
//  JIMPStatusHandler.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTStatus.h"
#import "OOTConnection.h"
#import "OOTGetStatus.h"


@protocol JIMPStatusHandlerDelegate

/**
 * Called when a status object has been received from the server.
 * @param sender The JIMPStatusHandlerDelegate that got the change.
 * @param aStatus The status object received
 * @param anotherStatus The previous status owned by this user, nil
 * if the user has had no previous statuses cached.
 */
- (void)statusHandler:(id)sender gotStatus:(OOTStatus *)aStatus previousStatus:(OOTStatus *)anotherStatus;

@end

@interface JIMPStatusHandler : NSObject {
    NSMutableArray * statuses;
	OOTConnection * connection;
	id<JIMPStatusHandlerDelegate> delegate;
}

@property (assign) id<JIMPStatusHandlerDelegate> delegate;

/**
 * Creates a new JIMPStatusHandler with an open connection.
 * This will register the status handler with various
 * notifications.
 * @param aConnection The connection of which to use.
 * @return A new status handler object.
 */
- (id)initWithConnection:(OOTConnection *)aConnection;

/**
 * Gets the status of a buddy.  If the status handler does not
 * have the status cached, it will fetch it in the background
 * and return nil.
 * @param buddy The buddy screenname to fetch the status for.
 * This will be converted to lower-case.
 * @return If the status was cached, this will return the cached status,
 * otherwise it will return nil and fetch the status in the background.
 */
- (OOTStatus *)statusMessageForBuddy:(NSString *)buddy;

/**
 * Sets the status message of the connection.
 * @param status The new status to set.
 */
- (void)setStatus:(OOTStatus *)status;

/**
 * Stops managing the current connection's status
 * messages.  This removes all notifications,
 * and releases the connection.
 */
- (void)stopManaging;

@end
