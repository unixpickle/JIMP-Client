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

@interface JIMPSessionManager : NSObject {
    NSMutableArray * connections;
}

+ (JIMPSessionManager *)sharedInstance;
- (OOTConnection *)newConnection;
- (OOTConnection *)firstConnection;
- (void)connectionDisconnected:(NSNotification *)notification;
- (NSArray *)connections;

@end
