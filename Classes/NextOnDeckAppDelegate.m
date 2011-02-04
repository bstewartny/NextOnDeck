#import "NextOnDeckAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ProjectsViewController.h"
#import "ProjectViewController.h"
#import "Project.h"
#import "Task.h"
#import "MGSplitViewController.h"

@implementation NextOnDeckAppDelegate
@synthesize window, splitViewController,projectsViewController,projectViewController;

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) showInbox
{
	[projectViewController setTaskSelector:@selector(getInboxTasks:) withObject:nil withTarget:self];
	projectViewController.project =nil;
	projectViewController.title=@"Inbox - These are unassigned tasks...";
	[projectViewController.taskTableView reloadData];
}

- (void) showNextOnDeck
{
	[projectViewController setTaskSelector:@selector(getNextOnDeckTasks:) withObject:nil withTarget:self];
	projectViewController.project =nil;
	
	projectViewController.title=@"Next On Deck - You should perform these tasks next...";
	[projectViewController.taskTableView reloadData];
}

- (void) showProject:(Project*)project
{
	[projectViewController setTaskSelector:@selector(getProjectTasks:) withObject:project withTarget:self];
	projectViewController.project = project;
	
	if([project.summary length]>0)
	{
		projectViewController.title= [NSString stringWithFormat:@"%@ - %@",project.name,project.summary];
	}
	else 
	{
		projectViewController.title= project.name;
	}
	
	[projectViewController.taskTableView reloadData];
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
	
	self.projectsViewController=[[ProjectsViewController alloc] initWithNibName:@"ProjectsView" bundle:nil];
	
	self.projectViewController=[[ProjectViewController alloc] initWithNibName:@"ProjectView" bundle:nil];
	
	self.splitViewController=[[MGSplitViewController alloc] init];
	self.splitViewController.dividerStyle=MGSplitViewDividerStyleNone;
	self.splitViewController.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
	
	self.splitViewController.viewControllers=[NSArray arrayWithObjects:projectsViewController,projectViewController,nil];
	
	self.splitViewController.delegate=self.projectViewController;
	
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    
    return YES;
}

-(Project*) createNewProject:(NSString*)name summary:(NSString*)summary
{
	NSLog(@"createNewProject: %@",name);
	Project * newProject=[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
	newProject.name=name;
	newProject.summary=summary;
	newProject.createdOn=[NSDate date];
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
    [splitViewController release];
	[projectsViewController release];
	[projectViewController release];
    [window release];
    [super dealloc];
}


@end

