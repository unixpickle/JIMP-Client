//
//  OOTObjectCreator.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"
#import "OOTText.h"
#import "OOTArray.h"
#import "OOTBuddy.h"
#import "OOTBuddyList.h"
#import "OOTError.h"
#import "OOTAccount.h"
#import "OOTInsertBuddy.h"
#import "OOTInsertGroup.h"
#import "OOTDeleteBuddy.h"
#import "OOTDeleteGroup.h"


@interface OOTObjectCreator : NSObject {
    
}

/**
 * Creates an object that is a subclass of a more specific
 * type of data.  
 * @return Either an OOTObject subclass, or the same 
 * object that was passed in.
 */
+ (OOTObject *)objectSubclassForObject:(OOTObject *)anObject;

@end
