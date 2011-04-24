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
+ (void)setFirstStatusHandler:(id)object;

@end

@implementation JIMPStatusHandler

@synthesize delegate;
@synthesize statuses;

//+ (JIMPStatusHandler **)firstStatusHandler {
//	static JIMPStatusHandler * handler = nil;
//	return &handler;
//}
//
//+ (void)setFirstStatusHandler:(id)object {
//	[*[JIMPStatusHandler firstStatusHandler] autorelease];
//	*[JIMPStatusHandler firstStatusHandler] = [object retain];
//}

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}


- (id)initWithConnection:(OOTConnection *)aConnection {
	if ((self = [super init])) {
		statuses = [[NSMutableArray alloc] init];
		queued = [[NSMutableArray alloc] init];
		connection = [aConnection retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionNewPacket:) name:OOTConnectionHasObjectNotification object:connection];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionDidClose:) name:OOTConnectionClosedNotification object:connection];
	}
	return self;
}

- (void)removeBuddyStatuses:(NSArray *)buddyObjects {
	for (int i = 0; i < [statuses count]; i++) {
		OOTStatus * status = [statuses objectAtIndex:i];
		NSString * snLower = [[status owner] lowercaseString];
		BOOL exists = NO;
		for (OOTBuddy * buddy in buddyObjects) {
			if ([[[buddy screenName] lowercaseString] isEqual:snLower]) {
				exists = YES;
				break;
			}
		}
		if (!exists) {
			[statuses removeObjectAtIndex:i];
			i -= 1;
		}
	}
}

- (OOTStatus *)statusMessageForBuddy:(NSString *)buddy {
	if ([queued containsObject:[buddy lowercaseString]]) return nil;
	NSString * buddyLowercase = [buddy lowercaseString];
	for (OOTStatus * status in statuses) {
		if ([[[status owner] lowercaseString] isEqual:buddyLowercase]) {
			return status;
		}
	}
	OOTGetStatus * getStatus = [[OOTGetStatus alloc] initWithScreenName:buddy];
	[queued addObject:[buddy lowercaseString]];
	[connection writeObject:getStatus];
	[getStatus release];
	return nil;
}


- (void)setStatus:(OOTStatus *)status {
	/* 
	 Remove from the queue to make sure that we get our latest
	 status object, otherwise we will have NOTHING to live for!
	*/
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
		OOTStatus * previous = nil;
		for (int i = 0; i < [statuses count]; i++) {
			OOTStatus * aStatus = [statuses objectAtIndex:i];
			if ([[[aStatus owner] lowercaseString] isEqual:[[status owner] lowercaseString]]) {
				previous = [[aStatus retain] autorelease];
				[statuses removeObjectAtIndex:i];
				i -= 1;
			}
		}
		[queued removeObject:[[status owner] lowercaseString]];
		[statuses addObject:status];
		[delegate statusHandler:self gotStatus:status previousStatus:previous];
		[status release];
	}
}
- (void)connectionDidClose:(NSNotification *)notification {
	[self stopManaging];
}

- (void)dealloc {
	if (connection) {
		[self stopManaging];
	}
	[queued release];
	[statuses release];
    [super dealloc];
}

@end
