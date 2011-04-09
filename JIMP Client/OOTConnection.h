//
//  OOTConnection.h
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#import "OOTObject.h"

#define OOTConnectionHasObjectNotification @"OOTConnectionHasObjectNotification"
#define OOTConnectionClosedNotification @"OOTConnectionClosedNotification"

@interface OOTConnection : NSObject {
    NSLock * isOpenLock;
	BOOL isOpen;
	int socketfd;
	
	NSString * _host;
	int _port;
	
	NSMutableArray * bufferedWrites;
	NSThread * writeThread;
	
	NSMutableArray * bufferedReads;
	NSThread * readThread;
}

- (id)initWithHost:(NSString *)host port:(int)port;

- (NSString *)host;
- (int)port;

- (OOTObject *)readObject:(BOOL)block;
- (BOOL)writeObject:(OOTObject *)object;

- (BOOL)isOpen;
- (void)close;
- (BOOL)connect:(NSError **)error;

@end
