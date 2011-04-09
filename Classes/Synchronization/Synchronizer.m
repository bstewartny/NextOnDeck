#import "Synchronizer.h"
#import <CoreData/CoreData.h>
#import "Project.h"
#import "Task.h"

@implementation SyncLog

- (id)init
{
	if(self=[super init])
	{
		messages=[[NSMutableArray alloc] init];
	}
	return self;
}
@synthesize numProjectsUpdated;
@synthesize numProjectsCreated;
@synthesize numProjectsDeleted;
@synthesize numTasksUpdated;
@synthesize numTasksCreated;
@synthesize numTasksDeleted;
@synthesize messages;

- (void) dealloc
{
	[messages release];
	[super dealloc];
}

@end

@implementation Synchronizer

- (void) dealloc
{
	[localTasksMap release];
	[localProjectsMap release];
	//[syncLog release];
	[super dealloc];
}

- (NSDictionary*)createNewUidMap:(NSArray*)objects
{
	NSMutableDictionary * map=[[NSMutableDictionary alloc] init];
	for(id object in objects)
	{
		[map setObject:object forKey:[object uid]];
	}
	return map;
}

- (SyncLog*) syncDatabaseWithLastSyncDate:(NSDate*)theLastSyncDate
						   andRemoteProjects:(NSArray*)remoteProjects 
						   andLocalProjects:(NSArray*)localProjects 
							  andLocalTasks:(NSArray*)localTasks 
					 andManagedObjectContex:(NSManagedObjectContext*)moc
{
	lastSyncDate=theLastSyncDate;
	managedObjectContext=moc;
	[localTasksMap release];
	[localProjectsMap release];
	localTasksMap=[self createNewUidMap:localTasks];
	localProjectsMap=[self createNewUidMap:localProjects];
	//[syncLog release];
	syncLog=[[[SyncLog alloc] init] autorelease];
	
	// go through all remote tasks first
	NSArray * allRemoteTasks=[self collectTasksFromProjects:remoteProjects];
	NSMutableArray * unUpdatedRemoteTasks=[[NSMutableArray alloc] init];
	NSDictionary * remoteTasksMap=[self createNewUidMap:allRemoteTasks];
	
	for(Task * remoteTask in allRemoteTasks)
	{
		if(![self updateLocalTaskWithRemoteTask:remoteTask])
		{
			[unUpdatedRemoteTasks addObject:remoteTask];
		}
	}
	
	NSMutableDictionary * remoteProjectsMap=[[NSMutableDictionary alloc] init];
	
	// now go through all projects
	for(Project * remoteProject in remoteProjects)
	{
		if([remoteProject.uid isEqualToString:@"_inbox"])
		{
			// inbox project
		}
		else 
		{
			[self updateLocalProjectWithRemoteProject:remoteProject];
			[remoteProjectsMap setObject:remoteProject forKey:remoteProject.uid];
		}
	}
	
	[self deleteLocalProjectWithModifiedDatePriorToLastSyncDate:localProjects remoteProjects:remoteProjectsMap];
	
	// go through un-updated tasks again (for tasks with new projects)
	for(Task * remoteTask in unUpdatedRemoteTasks)
	{
		[self updateLocalTaskWithRemoteTask:remoteTask];
	}
	
	[self deleteLocalTasksWithModifiedDatePriorToLastSyncDate:localTasks remoteTasks:remoteTasksMap];
	
	[remoteTasksMap release];
	[remoteProjectsMap release];
	
	[unUpdatedRemoteTasks release];
	
	return syncLog;
}


- (NSArray*) collectTasksFromProjects:(NSArray*)projects
{
	NSMutableArray * tasks=[[NSMutableArray alloc] init];
	
	for(Project * project in projects)
	{
		for(Task * task in project.tasks)
		{
			[tasks addObject:task];
		}
	}
	
	return [tasks autorelease];
}

- (BOOL) updateLocalTaskWithRemoteTask:(Task*)remoteTask
{
	NSLog(@"updateLocalProjectWithRemoteProject: %@",remoteTask.name);
	// see if task exists with uid
	
	Task * localTask=[self taskWithUid:remoteTask.uid];
	
	if(localTask)
	{
		if([self isDate:remoteTask.modifiedOn laterThan:localTask.modifiedOn])
		{
			NSLog(@"Remote task was modified since last sync, overwrite local...");
			
			// see if remote task changed project...
			if(![localTask.project.uid isEqualToString:remoteTask.project.uid])
			{
				NSLog(@"Task project changed...");
				// verify local project exists...
				if(remoteTask.project==nil ||
				   remoteTask.project.uid==@"_inbox")
				{
					// remote task is inbox task
					localTask.project=nil;
				}
				else 
				{
					
					Project * project=[self projectWithUid:remoteTask.project.uid];
					if(project)
					{
						localTask.project=project;
					}
					else 
					{
						NSLog(@"No such local project exists for modified task, will try again after projects are synced...");
						// we will need to try again after projects have been synced...
						return NO;
					}
				}
			}
			
			localTask.name=remoteTask.name;
			localTask.modifiedOn=remoteTask.modifiedOn;
			localTask.completedOn=remoteTask.completedOn;
			localTask.note=remoteTask.note;
			localTask.completed=remoteTask.completed;
			localTask.dueDate=remoteTask.dueDate;
			NSString * projectName;
			if(localTask.project)
			{
				projectName=localTask.project.name;
			}
			else {
				projectName=@"Inbox";
				
			}
			syncLog.numTasksUpdated++;
			[syncLog.messages addObject:@"Updated task '%@' in project '%@'",localTask.name,projectName];
			
			[localTask save];
		}
		else 
		{
			NSLog(@"local task exists but is modified later than remote task");
		}
	}
	else 
	{
		NSLog(@"No such local task exists...");
		if(lastSyncDate==nil || [self isDate:remoteTask.modifiedOn laterThan:lastSyncDate])
		{
			NSLog(@"Creating new local task...");
			Project * project=[self projectWithUid:remoteTask.project.uid];
			if(project)
			{
				Task * newTask=[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:managedObjectContext];
				
				newTask.uid=remoteTask.uid;
				newTask.name=remoteTask.name;
				newTask.note=remoteTask.note;
				newTask.dueDate=remoteTask.dueDate;
				newTask.createdOn=remoteTask.createdOn;
				newTask.modifiedOn=remoteTask.modifiedOn;
				newTask.completed=remoteTask.completed;
				newTask.project=project;
				
				syncLog.numTasksCreated++;
				NSString * projectName;
				if(newTask.project)
				{
					projectName=newTask.project.name;
				}
				else {
					projectName=@"Inbox";
					
				}

				[syncLog.messages addObject:@"Added task '%@' to project '%@'",newTask.name,projectName];
				
				[newTask save];
			}
			else 
			{
				NSLog(@"No such local project exists for new task, will try again after projects are synced...");
				// we will need to try again after projects have been synced...
				return NO;
			}
		}
		else 
		{
			NSLog(@"remote task was modified prior to last sync, assume we deleted it...");
		}
	}
	
	return YES;
}

- (BOOL) isDate:(NSDate*)a laterThan:(NSDate*)b
{
	if(a)
	{
		if(b)
		{
			if([a isEqualToDate:b])
			{
				NSLog(@"isLaterDate: %@ is EQUAL to %@",[a description],[b description]);
				return NO;
			}
			if([[a laterDate:b] isEqual:a])
			{
				NSLog(@"isLaterDate: %@ is later than %@",[a description], [b description]);
				return YES;
			}
			else 
			{
				NSLog(@"isLaterDate: %@ is NOT later than %@",[a description], [b description]);
				return NO;
			}
		}
	}
	return NO;
}

- (BOOL) updateLocalProjectWithRemoteProject:(Project*)remoteProject 
{
	NSLog(@"updateLocalProjectWithRemoteProject: %@",remoteProject.name);
	// see if project exists with uid
	
	Project * localProject=[self projectWithUid:remoteProject.uid];
	
	if(localProject)
	{
		if([self isDate:remoteProject.modifiedOn laterThan:localProject.modifiedOn])
		{
			NSLog(@"Remote project was modified since last sync, overwrite local...");
			
			localProject.name=remoteProject.name;
			localProject.modifiedOn=remoteProject.modifiedOn;
			localProject.notes=remoteProject.notes;
			localProject.summary=remoteProject.summary;
			
			
			
			
			[localProject save];
			
			syncLog.numProjectsUpdated++;
			[syncLog.messages addObject:@"Updated project '%@'",localProject.name];
			
		}
		else 
		{
			NSLog(@"local project exists but was modified later than remote project");
		}
	}
	else 
	{
		NSLog(@"No such local project exists...");
		
		if(lastSyncDate==nil || [self isDate:remoteProject.modifiedOn laterThan:lastSyncDate])
		{
			NSLog(@"Creating new local project...");
			
			Project * newProject=[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
			
			newProject.uid=remoteProject.uid;
			newProject.name=remoteProject.name;
			newProject.createdOn=remoteProject.createdOn;
			newProject.modifiedOn=remoteProject.modifiedOn;
			newProject.notes=remoteProject.notes;
			newProject.summary=remoteProject.summary;
			
			// save so we can see it when updating tasks again
			[localProjectsMap setObject:newProject forKey:newProject.uid];
			
			[newProject save];
			
			syncLog.numProjectsCreated++;
			[syncLog.messages addObject:@"Created project '%@'",newProject.name];
		}
		else 
		{
			NSLog(@"remote project was modified prior to last sync, assume we deleted it...");
		}
	}
	return YES;
}

- (BOOL) deleteLocalProjectWithModifiedDatePriorToLastSyncDate:(NSArray*)localProjects remoteProjects:(NSDictionary*)remoteProjectsMap
{
	NSLog(@"deleteLocalProjectWithModifiedDatePriorToLastSyncDate");
	if(lastSyncDate)
	{
		for(Project * localProject in localProjects)
		{
			// see if local project exists in remote projects
			if ([remoteProjectsMap objectForKey:localProject.uid]==nil) {
				// no project with this uid exists on remote...
				// if local project was modified prior to last sync, we assume we deleted the project remotely...
				if([self isDate:lastSyncDate laterThan:localProject.modifiedOn])
				{
					NSLog(@"Deleting local project: %@",localProject.name);
					
					syncLog.numProjectsDeleted++;
					[syncLog.messages addObject:@"Deleted project '%@'",localProject.name];
					
					[localProject delete];
					
				}
			}
		}
	}
	return YES;
}

- (BOOL) deleteLocalTasksWithModifiedDatePriorToLastSyncDate:(NSArray*)localTasks remoteTasks:(NSDictionary*)remoteTasksMap
{
	NSLog(@"deleteLocalTasksWithModifiedDatePriorToLastSyncDate");
	if(lastSyncDate)
	{
		for(Task * localTask in localTasks)
		{
			// see if local task exists in remote tasks
			if ([remoteTasksMap objectForKey:localTask.uid]==nil) 
			{
				// no task with this uid exists on remote...
				// if local task was modified prior to last sync, we assume we deleted the task remotely...
				if([self isDate:lastSyncDate laterThan:localTask.modifiedOn])
				{
					NSLog(@"Deleting local task: %@",localTask.uid);
					
					syncLog.numProjectsDeleted++;
					[syncLog.messages addObject:@"Deleted task '%@'",localTask.name];
					
					[localTask delete];
				}
			}
		}
	}
	return YES;
}

- (Task*) taskWithUid:(NSString*)uid
{
	NSLog(@"taskWithUid: %@",uid);
	Task * task=[localTasksMap objectForKey:uid];
	
	if(task)
	{
		NSLog(@"Found task with uid: %@",uid);
		return task;
	}
	else 
	{
		NSLog(@"No such task found with uid: %@",uid);
		return nil;
	}
}

- (Project*)projectWithUid:(NSString*)uid
{
	NSLog(@"projectWithUid: %@",uid);
	
	Project * project=[localProjectsMap objectForKey:uid];
	
	if(project)
	{
		NSLog(@"Found project with uid: %@",uid);
		return project;
	}
	else 
	{
		NSLog(@"No such project found with uid: %@",uid);
		return nil;
	}
}

@end
