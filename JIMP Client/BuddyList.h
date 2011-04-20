//
//  BuddyList.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTBuddyList.h"
#import "OOTBuddy.h"
#import "OOTInsertBuddy.h"
#import "OOTInsertGroup.h"
#import "OOTDeleteBuddy.h"
#import "OOTDeleteGroup.h"
#import "JIMPStatusHandler.h"


@interface BuddyList : NSObject {
    // group = {"name": x, "buddies": [bud1, bud2, bud3, ...]};
	NSArray * groups;
	NSMutableArray * offline;
	OOTBuddyList * buddyList;
}

@property (readonly) OOTBuddyList * buddyList;

/**
 * Returns a shared buddy list object.
 * @return	The current shared buddy list object.
 */
+ (BuddyList *)sharedBuddyList;

/**
 * Changes the shared buddy list, retaining
 * the list provided.
 * @param aList	The new buddy list of which to share
 */
+ (void)setSharedBuddyList:(BuddyList *)aList;

/**
 * Modifies the shared buddy list to accomedate an insert
 * that came from the server.
 * @param buddyInsert	The insert object that came from the server.
 * @return	YES if the buddy was successfully inserted, NO if not.
 */
+ (BOOL)handleInsert:(OOTInsertBuddy *)buddyInsert;

/**
 * Modifies the shared buddy list to accomedate an insert
 * that came from the server.
 * @param groupInsert	The insert object that came from the server.
 * @return	YES if the group was successfully inserted, NO if not.
 */
+ (BOOL)handleInsertG:(OOTInsertGroup *)groupInsert;

/**
 * Modifies the shared buddy list to accomedate a delete
 * that came from the server.
 * @param buddyDelete	The delete object that came from the server.
 * @return YES if the buddy was successfully deleted, NO if not.
 */
+ (BOOL)handleDelete:(OOTDeleteBuddy *)buddyDelete;

/**
 * Modifies the shared buddy list to accomedate a delete
 * that came from the server.
 * @param groupDelete	The delete object that came from the server.
 * @return YES if the group was successfully deleted, NO if not.
 */
+ (BOOL)handleDeleteG:(OOTDeleteGroup *)groupDelete;

/**
 * Regenerates the entire buddy list, only changing
 * the online/offline portion of the buddy list.
 */
+ (void)regenerateBuddyList;

/**
 * Creates a new BuddyList object using an OOT Buddy List object.
 * This will read the first status manager, getting the online
 * buddies for use in the buddy list.
 * @param aBuddyList An OOT Buddy List object of which to use
 * for our initial data.
 * @return	Returns a new BuddyList containing the groups that were
 * encoded in the OOTBuddyList.
 */
- (id)initWithBuddyList:(OOTBuddyList *)aBuddyList;

/**
 @return An array of group names.
 */
- (NSArray *)groupNames;

/**
 * Same thing as [groupNames count].
 * @return	The number of group names.
 */
- (int)numberOfGroups;

/**
 * Get the group title at a particular index.
 * @param index	The index of which to read in the group array.
 * @return	The NSString title of the group.
 */
- (NSString *)groupTitle:(int)index;

/**
 * Get the number of items at a group index.
 * @param group	The index of the group to count.
 * @return	The number of items in a group.
 */
- (int)numberOfItems:(int)group;

/**
 * Get an item in a group.
 * @param index	The index within the group that we are fetching
 * @param groupIndex	The index of the group that contains the item.
 * @return	An NSString containing a buddy screenname.
 */
- (NSString *)itemAtIndex:(int)index ofGroup:(int)groupIndex;

@end
