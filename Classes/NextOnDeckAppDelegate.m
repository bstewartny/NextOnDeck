#import "NextOnDeckAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Project.h"
#import "Task.h"

@implementation NextOnDeckAppDelegate
@synthesize window;

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) synchronize
{
	// fetch projects from server
	
	// need to keep revision number in database - increment on sync...
	
	/*
		A = local database
		B = remote database
	 
		if B > A:
			foreach i in B:
				insert or update i in A
			
			foreach j in A:
				if NOT in B:
					if j.modified > B.revisionDate
						insert to B
					else	
						delete j from A
		
		else:
			reverse algorithm
	 
		if only modified A:
			make revision = B (if B>A) and set date
		
		if only modified B:
			make revision = A (if A>B) and set date
	 
		if modified both:
			make same (bigger one) and increment both and set dates
			
		
		DB table:
			revision #
			revision date
	 
		use GUID for UID of projects/tasks
	 
		JSON API on GAE:
			
			get all projects/tasks with revision # and revision date
			add/modify/delete project
			add/modify/delete tasks
			batch commands: add/modify/delete multiple in one request
			update revision # and date
	 
		
		
	 
	 
	 
	 
	 */
	
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[self loadArchivedData];
	
	[self setUpWindow];
	    
    return YES;
}

-(Project*) createNewProject:(NSString*)name summary:(NSString*)summary
{
	NSLog(@"createNewProject: %@",name);
	Project * newProject=[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
	newProject.uid=...;
	newProject.name=name;
	newProject.summary=summary;
	newProject.createdOn=[NSDate date];
	newProject.modifiedOn=newProject.createdOn;
	[newProject save];
	return newProject;
}

-(Project*) getProjectByName:(NSString*)name
{
	NSLog(@"getProjectByName: %@",name);
	NSPredicate * predicate=[NSPredicate predicateWithFormat:@"name=%@",name ];
	
	NSArray * results= [self searchObjects:@"Project" predicate:predicate sortKey:@"createdOn" sortAscending:YES];
	
	if([results count]>0)
	{
		return [results objectAtIndex:0];
	}
	else 
	{
		NSLog(@"No project exists: %@",name);
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
		
		//self.projects=[unarchiver decodeObjectForKey:@"projects"];
		
		[unarchiver finishDecoding];
		
		[unarchiver	release];
		
		[data release];
	}
	//if(projects==nil)
	//{
	//	projects=[[NSMutableArray alloc] init];
	//}
}

- (void) saveData
{
	NSMutableData * data=[[NSMutableData alloc] init];
	
	if(data)
	{
		NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		
		//if(projects!=nil)
		//{
		///	[archiver encodeObject:projects	forKey:@"projects"];
		//}
		
		[archiver finishEncoding];
		
		[data writeToFile:[self dataFilePath] atomically:YES];
		
		[archiver release];
		
		[data release];
		
		NSLog(@"Data saved ...");
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
	[self saveData];
}

- (void)dealloc {
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [window release];
    [super dealloc];
}


@end

