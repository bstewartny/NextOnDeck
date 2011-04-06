//
//  Synchronizer.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/6/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface SyncLog : NSObject
{
	int numProjectsUpdated;
	int numProjectsCreated;
	int numProjectsDeleted;
	int numTasksUpdated;
	int numTasksCreated;
	int numTasksDeleted;
	NSArray * messages;
}
@property(nonatomic) int numProjectsUpdated;
@property(nonatomic) int numProjectsCreated;
@property(nonatomic) int numProjectsDeleted;
@property(nonatomic) int numTasksUpdated;
@property(nonatomic) int numTasksCreated;
@property(nonatomic) int numTasksDeleted;
@property(nonatomic,retain) NSArray * messages;

@end

@interface Synchronizer : NSObject 
{
	NSManagedObjectContext * managedObjectContext;
	NSMutableDictionary * localProjectsMap;
	NSMutableDictionary * localTasksMap;
	NSDate * lastSyncDate;
	SyncLog * syncLog;
}

- (SyncLog*) syncDatabaseWithLastSyncDate:(NSDate*)theLastSyncDate
						andRemoteProjects:(NSArray*)remoteProjects 
						 andLocalProjects:(NSArray*)localProjects 
							andLocalTasks:(NSArray*)localTasks 
				   andManagedObjectContex:(NSManagedObjectContext*)moc;


@end
