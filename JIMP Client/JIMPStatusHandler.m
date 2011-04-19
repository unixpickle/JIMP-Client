//
//  JIMPStatusHandler.m
//  JIMP Client
//
//  Created by Alex Nichol on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JIMPStatusHandler.h"

@interface JIMPStatusHandler (private)

- (void)connectionNewPacket:(NSNotification *)notification;
- (void)connectionDidClose:(NSNotification *)notification;

@end

@implementation JIMPStatusHandler

@synthesize delegate;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}


- (id)initWithConnection:(OOTConnection *)aConnection {
	if ((self = [super init])) {
		statuses = [[NSMutableArray alloc] init];
		connection = [aConnection retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionNewPacket:) name:OOTConnectionHasObjectNotification object:connection];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionDidClose:) name:OOTConnectionClosedNotification object:connection];
	}
	return self;
}


- (OOTStatus *)statusMessageForBuddy:(NSString *)buddy {
	NSString * buddyLowercase = [buddy lowercaseString];
	for (OOTStatus * status in statuses) {
		if ([[[status owner] lowercaseString] isEqual:buddyLowercase]) {
			return status;
		}
	}
	OOTGetStatus * getStatus = [[OOTGetStatus alloc] initWithScreenName:buddy];
	[connection writeObject:getStatus];
	[getStatus release];
	return nil;
}


- (void)setStatus:(OOTStatus *)status {
	[connection writeObject:status];
}


- (void)stopManaging {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionHasObjectNotification object:connection];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OOTConnectionClosedNotification object:connection];
	[connection release];
	connection = nil;
}

- (void)connectionNewPacket:(NSNotification *)notification {
	OOTObject * object = [[notification userInfo] objectForKey:@"object"];
	if ([[object className] isEqual:@"stts"]) {
		OOTStatus * status = [[OOTStatus alloc] initWithObject:object];
		// remove all statuses of this user.
		for (int i = 0; i < [statuses count]; i++) {
			OOTStatus * aStatus = [statuses objectAtIndex:i];
			if ([[[aStatus owner] lowercaseString] isEqual:[[status owner] lowercaseString]]) {
				[statuses removeObjectAtIndex:i];
				i -= 1;
			}
		}
		[statuses addObject:status];
		[delegate statusHandler:self gotStatus:status];
	}
}
- (void)connectionDidClose:(NSNotification *)notification {
	[self stopManaging];
}

- (void)dealloc {
	if (connection) {
		[self stopManaging];
	}
	[statuses release];
    [super dealloc];
}

@end
