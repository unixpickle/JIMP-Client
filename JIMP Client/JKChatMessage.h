//
//  JKChatMessage.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTMessage.h"

typedef enum {
	JKChatMessageSourceLocal,
	JKChatMessageSourceRemote
} JKChatMessageSource;

@interface JKChatMessage : NSObject {
    JKChatMessageSource messageSource;
	OOTMessage * message;
}

@property (readonly) JKChatMessageSource messageSource;
@property (readonly) OOTMessage * message;

- (id)initWithSource:(JKChatMessageSource)theSource message:(OOTMessage *)theMessage;
+ (JKChatMessage *)messageWithSource:(JKChatMessageSource)theSource message:(OOTMessage *)theMessage;

@end
