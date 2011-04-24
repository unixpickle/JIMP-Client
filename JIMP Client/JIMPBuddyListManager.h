//
//  JIMPBuddyListManager.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTConnection.h"
#import "OOTBuddyList.h"
#import "JKBuddyList.h"

#import "OOTInsertBuddy.h"
#import "OOTInsertGroup.h"
#import "OOTDeleteBuddy.h"
#import "OOTDeleteGroup.h"


@protocol JIMPBuddyListManagerDelegate <NSObject>

/**
 * Called when we have successfully modified the buddy list,
 * or another client has.  This will also be called when the
 * initialial buddy list arrives.
 * @param newBuddyList The new buddy list.
*/
- (void)buddyListUpdated:(JKBuddyList *)newBuddylist;

@end


/**
 * Use the Buddy List Manager to handle buddy list modifications,
 * and to make them.  This will tell its delegate when the buddy list
 * has changed.
 */
@interface JIMPBuddyListManager : NSObject {
	OOTConnection * connection;
	JIMPStatusHandler * statusHandler;
	JKBuddyList * buddyList;
	id <JIMPBuddyListManagerDelegate> delegate;
}

/**
 * The delegate property is called whenever it is
 * apparent that the buddy list has changed.
*/
@property (assign) id <JIMPBuddyListManagerDelegate> delegate;

@property (nonatomic, retain) JIMPStatusHandler * statusHandler;
@property (nonatomic, retain) JKBuddyList * buddyList;

/**
 * Modifies the shared buddy list to accomedate an insert
 * that came from the server.
 * @param buddyInsert The insert object that came from the server.
 * @return	YES if the buddy was successfully inserted, NO if not.
 */
- (BOOL)handleInsert:(OOTInsertBuddy *)buddyInsert;

/**
 * Modifies the shared buddy list to accomedate an insert
 * that came from the server.
 * @param groupInsert The insert object that came from the server.
 * @return	YES if the group was successfully inserted, NO if not.
 */
- (BOOL)handleInsertG:(OOTInsertGroup *)groupInsert;

/**
 * Modifies the shared buddy list to accomedate a delete
 * that came from the server.
 * @param buddyDelete The delete object that came from the server.
 * @return YES if the buddy was successfully deleted, NO if not.
 */
- (BOOL)handleDelete:(OOTDeleteBuddy *)buddyDelete;

/**
 * Modifies the shared buddy list to accomedate a delete
 * that came from the server.
 * @param groupDelete The delete object that came from the server.
 * @return YES if the group was successfully deleted, NO if not.

 */
- (BOOL)handleDeleteG:(OOTDeleteGroup *)groupDelete;

/**
 * Regenerates the entire buddy list, only changing
 * the online/offline portion of the buddy list.
 */
- (void)regenerateBuddyList;

#pragma mark Buddy List

/**
 * Takes a connection and retains it.  Also, registers
 * the notifications that it needs.
 * @return	returns the initialized object.
*/
- (id)initWithConnection:(OOTConnection *)aConnection;

/**
 * Queries the server for the buddy list.
 * @return	YES if the query object was sent, NO if not.
 */
- (BOOL)getBuddylist;

/**
 * Insert a buddy at an index in the buddy array.
 * @param buddy	the buddy screenname to insert, will be converted
 * to lowercase.
 * @param group	the group to which the buddy belongs.
 * @param index	the index into which we will insert the buddy.
 * @return	YES if the insert object was sent, NO if not.
 */
- (BOOL)insertBuddy:(NSString *)buddy group:(NSString *)group index:(int)index;

/**
 * Insert a group at an index in the group array.
 * @param group	the group name to insert, case sensitive.
 * @param index	the index into which we will insert the group.
 * @return	YES if the insert object was sent, NO if not.
 */
- (BOOL)insertGroup:(NSString *)group index:(int)index;

/**
 * Deletes the first buddy found with a particular screenname.
 * This will convert the specified screenname to lowercase.
 * @param buddy	the buddy screenname to delete (will be set to lowercase)
 * @return	YES if the delete object was sent, NO if not.
 */
- (BOOL)deleteBuddy:(NSString *)buddy;

/**
 * Deletes the first group found with a particular screenname.
 * This will not change the case of the group.
 * @param group	the group of which you are looking to delete.
 * This is case sensitive.
 * @return	YES if the delete object was sent, NO if not.
 */
- (BOOL)deleteGroup:(NSString *)group;

/**
 * Removes the NSNotification observers that the manager
 * has registered, release the connection.
*/
- (void)stopManaging;

@end
