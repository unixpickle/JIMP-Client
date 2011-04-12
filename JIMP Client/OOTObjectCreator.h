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


@interface OOTObjectCreator : NSObject {
    
}

+ (OOTObject *)objectSubclassForObject:(OOTObject *)anObject;

@end
