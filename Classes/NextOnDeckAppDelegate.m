#import "NextOnDeckAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Project.h"
#import "Task.h"
#import "UUID.h"
#import "DropboxSDK.h"
#import "JSON.h"

@implementation NextOnDeckAppDelegate
@synthesize window,restClient;

- (BOOL) isPhone
{
	return NO;
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) refresh
{
	if (![[DBSession sharedSession] isLinked]) 
	{
		[self doLogin];
	}
	else 
	{
		[self doRefresh];
	}
}

- (void)loginControllerDidLogin:(DBLoginController*)controller
{
	if ([[DBSession sharedSession] isLinked]) {
		[self doRefresh];
	}
}

- (void)loginControllerDidCancel:(DBLoginController*)controller
{
	NSLog(@"loginControllerDidCancel");
}


- (void) doRefresh
{
	[self.restClient loadMetadata:@"/NextOnDeck" withHash:metadataHash];
}

- (void) doLogin
{
	// implement in subclass...
}

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session {
	[self doLogin];
}

- (void) setUpWindow
{
	// subclass
}

- (void) showInbox
{
	// subclass
}

- (void) showNextOnDeck
{
	// subclass
}

- (void) showProject:(Project*)project
{
	// subclass
}

- (NSArray*) getProjectTasks:(Project*)project
{
	return [project orderedTasks];
}

-(NSArray*) getNextOnDeckTasks:(id)na
{
	return [self nextOnDeckTasks];
}

- (NSArray*)getInboxTasks:(id)na
{
	return [self unassignedTasks];
}
- (DBRestClient*)restClient {
    if (restClient == nil) {
    	restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    	restClient.delegate = self;
    }
    return restClient;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
	formatter=[[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterLongStyle];
	[formatter setTimeStyle:NSDateFormatterLongStyle];
	
	//[formatter setDateFormat:@""];
	
	
	DBSession* dbSession = [[[DBSession alloc]
	  initWithConsumerKey:kDropBoxKey
	  consumerSecret:kDropBoxSecret]
	 autorelease];
	dbSession.delegate=self;
    [DBSession setSharedSession:dbSession];
	
	[self loadArchivedData];
	[self setUpWindow];
    return YES;
}

-(Project*) createNewProject:(NSString*)name summary:(NSString*)summary
{
	Project * newProject=[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
	newProject.uid=[UUID GetUUID];
	newProject.name=name;
	newProject.summary=summary;
	newProject.createdOn=[NSDate date];
	newProject.modifiedOn=newProject.createdOn;
	[newProject save];
	return newProject;
}

-(Project*) getProjectByName:(NSString*)name
{
	NSPredicate * predicate=[NSPredicate predicateWithFormat:@"name=%@",name ];
	
	NSArray * results= [self searchObjects:@"Project" predicate:predicate sortKey:@"createdOn" sortAscending:YES];
	
	if([results count]>0)
	{
		return [results objectAtIndex:0];
	}
	else 
	{
		return nil;
	}
}

-(NSArray *) uncompletedTasks
{
	NSPredicate * predicate=[NSPredicate predicateWithFormat:@"completed=0" ];
	
	return [self searchObjects:@"Task" predicate:predicate sortKey:@"createdOn" sortAscending:YES];
}

-(NSArray *) overdueTasks
{
	NSPredicate * predicate=[NSPredicate predicateWithFormat:@"completed=0 AND dueDate <= @",[NSDate date]];
	
	return [self searchObjects:@"Task" predicate:predicate sortKey:@"createdOn" sortAscending:YES];
}

-(NSArray *) nextOnDeckTasks
{
	NSMutableArray * results=[[[NSMutableArray alloc] init] autorelease];
	
	for(Project * project in [self allProjects])
	{
		Task * nextTask=[project nextOnDeck];
		if(nextTask)
		{
			[results addObject:nextTask];
		}
	}
	[results sortUsingSelector:@selector(createdOn)];
	return results;
}

- (NSArray*) allTasks
{
	return [self searchObjects:@"Task" predicate:nil sortKey:@"createdOn" sortAscending:YES];
}

- (NSArray*) allProjects
{
	return [self searchObjects:@"Project" predicate:nil sortKey:@"createdOn" sortAscending:YES];
}

-(NSArray *) completedTasks
{
	NSPredicate * predicate=[NSPredicate predicateWithFormat:@"completed=1"];
	
	return [self searchObjects:@"Task" predicate:predicate sortKey:@"createdOn" sortAscending:YES];
}

-(NSArray *) unassignedTasks
{
	NSLog(@"unassignedTasks");
	NSPredicate * predicate=[NSPredicate predicateWithFormat:@"project==%@",nil];
	
	return [self searchObjects:@"Task" predicate:predicate sortKey:@"createdOn" sortAscending:NO];
}

-(NSArray *) todayTasks
{
	return [self tasksForDate:[NSDate date]];
}

-(NSArray *) tasksForDate:(NSDate*)date
{
	NSPredicate * predicate=[NSPredicate predicateWithFormat:@"dueDate>=@ AND dueDate<@",date,[date addTimeInterval:60*60*24]];
	
	return [self searchObjects:@"Task" predicate:predicate sortKey:@"createdOn" sortAscending:YES];
}

-(NSArray *) searchObjects: (NSString*) entityName predicate: (NSPredicate *) predicate sortKey: (NSString*) sortKey sortAscending: (BOOL) sortAscending
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
	[request setEntity:entity];
	
	// If a predicate was passed, pass it to the query
	if(predicate != nil)
	{
		[request setPredicate:predicate];
	}
	
	// If a sort key was passed, use it for sorting.
	if(sortKey != nil)
	{
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
		[sortDescriptors release];
		[sortDescriptor release];
	}
	
	NSError *error;
	
	NSArray * results=[[self managedObjectContext] executeFetchRequest:request error:&error];
	
	[request release];
	
	return results;
}

- (NSString *)dataFilePath
{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"archive"];
}

- (NSManagedObjectModel*)managedObjectModel 
{
	if (managedObjectModel) return managedObjectModel;
	
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
	
	return managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator 
{
	if (persistentStoreCoordinator) return persistentStoreCoordinator;
	
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"InfoNgen.sqlite"]];
	
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	NSError *error = nil;
	[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
	
	return persistentStoreCoordinator;
}

- (NSManagedObjectContext *) managedObjectContext 
{
    if (managedObjectContext != nil) 
	{
        return managedObjectContext;
    }
	managedObjectContext=[self createNewManagedObjectContext:NSOverwriteMergePolicy];
	
	return managedObjectContext;
}

- (NSManagedObjectContext *) createNewManagedObjectContext:(id)mergePolicy
{
	NSManagedObjectContext * moc=nil;
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		moc = [[NSManagedObjectContext alloc] init];
		[moc setPersistentStoreCoordinator: coordinator];
		[moc setMergePolicy:mergePolicy];
	}
	return moc;
}

- (void) loadArchivedData
{
	NSData * data =[[NSMutableData alloc]
					initWithContentsOfFile:[self dataFilePath]];
	
	if (data) {
		
		NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]
										  initForReadingWithData:data];
		
		lastSyncDate=[[unarchiver decodeObjectForKey:@"lastSyncDate"] retain];
		
		[unarchiver finishDecoding];
		
		[unarchiver	release];
		
		[data release];
	}
}

- (void) saveData
{
	NSMutableData * data=[[NSMutableData alloc] init];
	
	if(data)
	{
		NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		
		if(lastSyncDate)
		{
			[archiver encodeObject:lastSyncDate forKey:@"lastSyncDate"];
		}
		
		[archiver finishEncoding];
		
		[data writeToFile:[self dataFilePath] atomically:YES];
		
		[archiver release];
		
		[data release];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
	[self saveData];
}


// DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath
{
	NSLog(@"uploadedFile: %@, from: %@",destPath,srcPath);
	
	lastSyncDate=[[NSDate date] retain];
	[self saveData];
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
	
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
	NSLog(@"uploadFileFailedWithError: %@",[error localizedDescription]);
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
	
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
	NSLog(@"loadedFile: %@",destPath);
	
	NSString * json=[NSString stringWithContentsOfFile:destPath encoding:NSUTF8StringEncoding error:nil];
	
	 
	if([json length]>0)
	{
		NSArray * remoteProjects=[self parseJsonProjects:[json JSONValue]];
		
		if([remoteProjects count]>0)
		{
			[self updateDatabaseWithRemoteProjects:remoteProjects];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
			
		}
		else 
		{
			NSLog(@"Got 0 remote projects from server...");
		}
	}
	else 
	{
		NSLog(@"Failed to get JSON from file: %@",destPath);
	}
	[self pushLocalDatabaseToDropBox];
}
	
- (void) pushLocalDatabaseToDropBox
{
	NSLog(@"pushLocalDatabaseToDropBox");
	
	NSString * localJson=[self getJsonFromDatabase];
	
	if([localJson length]>0)
	{
		// write to local file...
		// verify file exists...
		NSString * fromPath=[self localSyncDestPath];
		NSFileManager* fileManager = [[NSFileManager new] autorelease];
        
		if ([[NSFileManager defaultManager] fileExistsAtPath:fromPath]) 
		{
			NSLog(@"File already exists, deleting it first... %@",fromPath);
			
			[fileManager removeItemAtPath:fromPath error:nil];
		}
	
		BOOL success = [fileManager createFileAtPath:fromPath contents:[localJson dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
		
		if(success)
		{
			if ([[NSFileManager defaultManager] fileExistsAtPath:fromPath]) 
			{
				NSLog(@"Uploading JSON database dump to DropBox: %@",fromPath);
				[self.restClient uploadFile:@"nextondeck.json" toPath:@"/NextOnDeck" fromPath:fromPath];
			}
			else 
			{
				NSLog(@"No such file exists: %@",fromPath);
			}

		}
		else {
			NSLog(@"Failed to create file: %@",fromPath);
		}

	}	
	else {
		NSLog(@"Failed to generate JSON from local database");
	}
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
	NSLog(@"loadFileFailedWithError: %@",[error localizedDescription]);
	
	[self pushLocalDatabaseToDropBox];
}

- (NSString*)localSyncDestPath 
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"nextondeck.json"];
}

- (NSString*)localSyncDumpPath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"nextondeck_dump.json"];
}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
    NSLog(@"restClient:loadedMetadata: %@", metadata.path);
	[metadataHash release];
    metadataHash = [metadata.hash retain];
	
	// see if remote json database exists yet...
	/*for (DBMetadata* child in metadata.contents) 
	{
		if(!child.isDirectory && !child.isDeleted)
		{
			NSLog(@"child.path=%@",child.path);
		}
    }*/
	
	// get remote database file
	NSString * localPath=[self localSyncDestPath];
	
	NSLog(@"Downloading nextondeck.json from from DropBox to local path: %@...",localPath);
	
	[self.restClient loadFile:@"/NextOnDeck/nextondeck.json" intoPath:localPath];
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

- (Task*) taskWithUid:(NSString*)uid
{
	NSLog(@"taskWithUid: %@",uid);
	NSArray * results=[self searchObjects:@"Task" predicate:[NSPredicate predicateWithFormat:@"uid==%@",uid] sortKey:nil sortAscending:NO];
	if([results count]>0)
	{
		return [results objectAtIndex:0];
	}
	else 
	{
		return nil;
	}
}

- (Project*)projectWithUid:(NSString*)uid
{
	NSLog(@"projectWithUid: %@",uid);
	NSArray * results=[self searchObjects:@"Project" predicate:[NSPredicate predicateWithFormat:@"uid==%@",uid] sortKey:nil sortAscending:NO];
	if([results count]>0)
	{
		return [results objectAtIndex:0];
	}
	else 
	{
		return nil;
	}
}

- (BOOL) updateLocalTaskWithRemoteTask:(Task*)task
{
	NSLog(@"updateLocalProjectWithRemoteProject: %@",task.name);
	// see if task exists with uid
	
	Task * localTask=[self taskWithUid:task.uid];
	
	if(localTask)
	{
		if([self isDate:task.modifiedOn laterThan:localTask.modifiedOn])
		{
		//if([[task.modifiedOn laterDate:localTask.modifiedOn] isEqual:task.modifiedOn])
		//{
			NSLog(@"Remote task was modified since last sync, overwrite local...");
			
			// see if remote task changed project...
			if(![localTask.project.uid isEqualToString:task.project.uid])
			{
				// verify local project exists...
				Project * project=[self projectWithUid:task.project.uid];
				if(project)
				{
					localTask.project=project;
				}
				else {
					NSLog(@"No such local project exists for modified task, will try again after projects are synced...");
					// we will need to try again after projects have been synced...
					return NO;
				}

			}
			
			
			localTask.name=task.name;
			localTask.modifiedOn=task.modifiedOn;
			localTask.completedOn	=task.completedOn;
			localTask.note=task.note;
			localTask.completed=task.completed;
			localTask.dueDate=task.dueDate;
			
			[localTask save];
			
		}
		else {
			NSLog(@"local task exists but is modified later than remote task");
		}

	}
	else 
	{
		NSLog(@"No such local task exists...");
		if(lastSyncDate==nil || [self isDate:task.modifiedOn laterThan:lastSyncDate])
		{
			NSLog(@"Creating new local task...");
			Project * project=[self projectWithUid:task.project.uid];
			if(project)
			{
				Task * t=[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[self managedObjectContext]];
				t.uid=task.uid;
				t.name=task.name;
				t.note=task.note;
				t.dueDate=task.dueDate;
				t.createdOn=t.createdOn;
				t.modifiedOn=t.modifiedOn;
				t.completed=t.completed;
				t.project=project;
				
				[t save];
			}
			else 
			{
				NSLog(@"No such local project exists for new task, will try again after projects are synced...");
				// we will need to try again after projects have been synced...
				return NO;
			}
		}
		else {
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
		//if([[project.modifiedOn laterDate:localProject.modifiedOn] isEqual:project.modifiedOn])
		//{
		if([self isDate:remoteProject.modifiedOn laterThan:localProject.modifiedOn])
		{
			NSLog(@"Remote project was modified since last sync, overwrite local...");
			
			localProject.name=remoteProject.name;
			localProject.modifiedOn=remoteProject.modifiedOn;
			localProject.notes=remoteProject.notes;
			localProject.summary=remoteProject.summary;
			
			[localProject save];
		}
		else {
			NSLog(@"local project exists but was modified later than remote project");
		}

	}
	else 
	{
		NSLog(@"No such local project exists...");
		 
		if(lastSyncDate==nil || [self isDate:remoteProject.modifiedOn laterThan:lastSyncDate])
		{
			NSLog(@"Creating new local project...");
			
			Project * newProject=[self createNewProject:remoteProject.name summary:remoteProject.summary];
			
			newProject.uid=remoteProject.uid;
			newProject.createdOn=remoteProject.createdOn;
			newProject.modifiedOn=remoteProject.modifiedOn;
			newProject.notes=remoteProject.notes;
			newProject.summary=remoteProject.summary;
			
			[newProject save];
		}
		else {
			NSLog(@"remote project was modified prior to last sync, assume we deleted it...");
		}

	}
	return YES;
}

- (BOOL) deleteLocalProjectWithModifiedDatePriorToLastSyncDate:(NSDictionary*)map
{
	NSLog(@"deleteLocalProjectWithModifiedDatePriorToLastSyncDate");
	if(lastSyncDate)
	{
		for(Project * project in [self allProjects])
		{
			if ([map objectForKey:project.uid]==nil) {
				// no project with this uid exists on remote...
				// if local project was modified prior to last sync, we assume we deleted the project remotely...
				NSLog(@"project.modifiedOn=%@",[project.modifiedOn description]);
				NSLog(@"lastSyncDate=%@",[lastSyncDate description]);
				
				if([self isDate:lastSyncDate laterThan:project.modifiedOn])
				{
				//if([[project.modifiedOn laterDate:lastSyncDate] isEqual:lastSyncDate])
				//{
					NSLog(@"Deleting local project: %@",project.name);
					[project delete];
				}
			}
		}
	}
	return YES;
}

- (BOOL) deleteLocalTasksWithModifiedDatePriorToLastSyncDate:(NSDictionary*)map
{
	NSLog(@"deleteLocalTasksWithModifiedDatePriorToLastSyncDate");
	if(lastSyncDate)
	{
		for(Task * task in [self allTasks])
		{
			if ([map objectForKey:task.uid]==nil) {
				// no project with this uid exists on remote...
				// if local project was modified prior to last sync, we assume we deleted the project remotely...
				if([self isDate:lastSyncDate laterThan:task.modifiedOn])
				{
					NSLog(@"Deleting local task: %@",task.uid);
					[task delete];
				}
			}
		}
	}
	return YES;
}

- (void) updateDatabaseWithRemoteProjects:(NSArray*)projects
{
	NSLog(@"updateDatabaseWithRemoteProjects");
	
	// go through all remote tasks first
	NSArray * allRemoteTasks=[self collectTasksFromProjects:projects];
	NSMutableArray * unUpdatedRemoteTasks=[[NSMutableArray alloc] init];
	NSMutableDictionary * remoteTasksMap=[[NSMutableDictionary alloc] init];
	
	for(Task * task in allRemoteTasks)
	{
		if(![self updateLocalTaskWithRemoteTask:task])
		{
			[unUpdatedRemoteTasks addObject:task];
		}
		[remoteTasksMap setObject:task.uid forKey:task.uid];
	}
	NSMutableDictionary * remoteProjectsMap=[[NSMutableDictionary alloc] init];
	
	// now go through all projects
	for(Project * project in projects)
	{
		if([project.uid isEqualToString:kInboxUID])
		{
			// inbox project
		}
		else 
		{
			[self updateLocalProjectWithRemoteProject:project];
			[remoteProjectsMap setObject:project.uid forKey:project.uid];
		}
	}
	// do we have any projects that dont exist on remote?
		// if any of these have createon dates < last sync date, assume we deleted it remotely (delete locally too)
		// should we warn user before deleting?
		// delete local project
	
	[self deleteLocalProjectWithModifiedDatePriorToLastSyncDate:remoteProjectsMap];
	 
	
	// go through un-updated tasks again (for tasks with new projects)
	
	for(Task * task in unUpdatedRemoteTasks)
	{
		[self updateLocalTaskWithRemoteTask:task];
	}
	
	[self deleteLocalTasksWithModifiedDatePriorToLastSyncDate:remoteTasksMap];
	
	[remoteTasksMap release];
	[remoteProjectsMap release];
	
	[unUpdatedRemoteTasks release];
}

- (NSString*) getJsonFromDatabase
{
	NSLog(@"getJsonFromDatabase");
	
	NSMutableArray * json=[[[NSMutableArray alloc] init] autorelease];
	
	// get inbox projects...
	TempProject * inbox=[[TempProject alloc] init];
	inbox.name=@"Inbox";
	inbox.uid=kInboxUID;
	inbox.modifiedOn=[NSDate date];
	inbox.createdOn=[NSDate date];
	inbox.tasks=[self unassignedTasks];
	
	[json addObject:[self getDictionaryFromProject:inbox]];
	
	[inbox release];
	
	for(Project * project in [self allProjects])
	{
		[json addObject:[self getDictionaryFromProject:project]];
	}
		
	return [json JSONFragment];
}

- (NSDictionary*) getDictionaryFromProject:(Project*)project
{
	NSLog(@"getDictionaryFromProject:%@",project.name);
	
	NSMutableDictionary * dict=[[NSMutableDictionary alloc] init];
	
	[dict setObject:project.uid forKey:@"uid"];
	[dict setObject:project.name forKey:@"name"];
	
	if(project.modifiedOn)
	{
		[dict setObject:[self dateToString:project.modifiedOn] forKey:@"modifiedOn"];
	}
	if(project.createdOn)
	{
		[dict setObject:[self dateToString:project.createdOn] forKey:@"createdOn"];
	}
	if(project.notes)
	{
		[dict setObject:project.notes forKey:@"notes"];
	}
	if(project.summary)
	{	
		[dict setObject:project.summary forKey:@"summary"];
	}
	
	NSMutableArray * tasks=[[NSMutableArray alloc] init];
	
	for(Task * task in project.tasks)
	{
		[tasks addObject:[self getDictionaryFromTask:task]];
	}
	
	[dict setObject:tasks forKey:@"tasks"];
	
	[tasks release];
		
	return [dict autorelease];
}

- (NSString*) dateToString:(NSDate*)date
{
	NSLog(@"dateToString: %@",[date description]);
	
	if(date)
	{
		NSString * s=[formatter stringFromDate:date];
		NSLog(@"date=%@",s);
		
		NSDate * d=[formatter dateFromString:s];
		
		NSLog(@"parsed date to: %@",[d description]);
		
		return s;
	}
	return nil;
}

- (NSDictionary*) getDictionaryFromTask:(Task*)task
{
	NSLog(@"getDictionaryFromTask: %@",task.name);
	
	NSMutableDictionary * dict=[[NSMutableDictionary alloc] init];
	
	[dict setObject:task.uid forKey:@"uid"];
	[dict setObject:task.name forKey:@"name"];
	
	if(task.modifiedOn)
	{
		[dict setObject:[self dateToString:task.modifiedOn] forKey:@"modifiedOn"];
	}
	if(task.createdOn)
	{
		[dict setObject:[self dateToString:task.createdOn] forKey:@"createdOn"];
	}
	if(task.dueDate)
	{
		[dict setObject:[self dateToString:task.dueDate] forKey:@"dueDate"];
	}
	if(task.completedOn)
	{	
		[dict setObject:[self dateToString:task.completedOn] forKey:@"completedOn"];
	}
	if(task.completed)
	{
		[dict setObject:task.completed  forKey:@"completed"];
	}
	if(task.note)
	{
		[dict setObject:task.note forKey:@"note"];
	}

	return [dict autorelease];
}

- (NSArray*) parseJsonProjects:(NSArray*)json
{
	NSLog(@"parseJsonProjects");
	
	NSMutableArray * projects=[[NSMutableArray alloc] init];
	
	for (NSDictionary * dict in json)
	{
		TempProject	* p=[[TempProject alloc] init];
		
		p.name=[dict objectForKey:@"name"];
		
		p.uid=[dict objectForKey:@"uid"];
		p.modifiedOn=[self parseDate:[dict objectForKey:@"modifiedOn"]];
		p.createdOn=[self parseDate:[dict objectForKey:@"createdOn"]];
		p.notes=[dict objectForKey:@"notes"]; 
		p.summary=[dict objectForKey:@"summary"];
		
		NSMutableArray * tasks=[[NSMutableArray alloc] init];
		
		NSArray * tasksArray=[dict objectForKey:@"tasks"];
		if(![tasksArray isKindOfClass:[NSArray class]])
		{
			// what is it then?
			NSLog(@"tasksArray is something else!");
		}
		   
		for(NSDictionary * taskDict in tasksArray)
		{
			TempTask * task=[[TempTask alloc] init];
			
			task.project=p;
			task.uid=[taskDict objectForKey:@"uid"];
			task.modifiedOn=[self parseDate:[taskDict objectForKey:@"modifiedOn"]];
			task.name=[taskDict objectForKey:@"name"];
			task.createdOn=[self parseDate:[taskDict objectForKey:@"createdOn"]];
			task.completedOn=[self parseDate:[taskDict objectForKey:@"completedOn"]];
			task.dueDate=[self parseDate:[taskDict objectForKey:@"dueDate"]];
			task.completed=[NSNumber numberWithInt:[[taskDict objectForKey:@"completed"] intValue]];
			task.note=[taskDict objectForKey:@"note"];
			
			[tasks addObject:task];
			[task release];
		}
		
		p.tasks=tasks;
		
		[tasks release];
	
		[projects addObject:p];
		[p release];
	}
	return [projects autorelease];
}

-(NSDate*)parseDate:(NSString*)d
{
	if([d length]>0)
	{
		return [formatter dateFromString:d];
	}
	else 
	{
		return nil;
	}
}
- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
	NSLog(@"restClient:metadataUnchangedAtPath: %@", path);
    //[self loadRandomPhoto];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
	// possibly folder does not exist, try creating it...
	
	[self.restClient createFolder:@"NextOnDeck"];
	
    //[self displayError];
    //[self setWorking:NO];
}

- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder
{
	NSLog(@"restClient:createdFolder: %@",folder.path);
	
	 
}

// Folder is the metadata for the newly created folder
- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error
{
	NSLog(@"restClient:createFolderFailedWithError: %@",[error localizedDescription]);
}

- (void)dealloc {
	[formatter release];
	[restClient release];
	[metadataHash release];
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [window release];
	[lastSyncDate release];
    [super dealloc];
}

@end

