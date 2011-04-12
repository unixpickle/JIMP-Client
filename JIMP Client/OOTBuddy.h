//
//  OOTBuddy.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTObject.h"
#import "OOTText.h"


@interface OOTBuddy : OOTObject {
    OOTText * screennameText;
	OOTText * groupText;
}

- (id)initWithScreenname:(NSString *)screenname groupName:(NSString *)groupName;
- (id)initWithObject:(OOTObject *)object;
- (id)initWithData:(NSData *)data;
- (id)initWithByteBuffer:(ANByteBuffer *)buffer;

- (NSString *)screenName;
- (NSString *)groupName;

@end
