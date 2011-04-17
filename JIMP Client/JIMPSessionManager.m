//
//  JIMPSessionManager.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JIMPSessionManager.h"


@implementation JIMPSessionManager

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
		connections = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (JIMPSessionManager *)sharedInstance {
	static JIMPSessionManager * manager = nil;
	if (!manager) {
		manager = [[JIMPSessionManager alloc] init];
	}
	return manager;
}
- (OOTConnection *)openConnection {
	OOTConnection * connection = [[OOTConnection alloc] initWithHost:kJIMPHost port:kJIMPPort];
	if (![connection connect:nil]) {
		[connection release];
		return nil;
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionDisconnected:) name:OOTConnectionClosedNotification object:connection];
	[connections addObject:connection];
	return [connection autorelease];
}
- (OOTConnection *)firstConnection {
	if ([connections count] == 0) return nil;
	return [connections objectAtIndex:0];
}
- (void)connectionDisconnected:(NSNotification *)notification {
	OOTConnection * connection = [notification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionClosedNotification object:connection];
	[connections removeObject:connection];
}
- (NSArray *)connections {
	return connections;
}

- (void)dealloc {
	for (OOTConnection * connection in connections) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionClosedNotification object:connection];
		[connection close];
	}
	[connections release];
    [super dealloc];
}

@end
