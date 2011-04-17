//
//  JIMPSessionManager.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OOTConnection.h"

#define kJIMPHost @"71.224.215.41"
#define kJIMPPort 1338

@interface JIMPSessionManager : NSObject {
    NSMutableArray * connections;
}

+ (JIMPSessionManager *)sharedInstance;
- (OOTConnection *)openConnection;
- (OOTConnection *)firstConnection;
- (void)connectionDisconnected:(NSNotification *)notification;
- (NSArray *)connections;

@end
