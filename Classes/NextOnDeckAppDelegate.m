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

- (void) showProject:(Project*)project
{
	projectViewController.project = project;
	[projectViewController.taskTableView reloadData];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[self loadArchivedData];
	
	self.projectsViewController=[[ProjectsViewController alloc] initWithNibName:@"ProjectsView" bundle:nil];
	
	//UINavigationController *projectsNavigationController = [[UINavigationController alloc] initWithRootViewController:projectsViewController];
	
	//ProjectCollection * allProjects=[[ProjectCollection alloc] init];
	
	//[allProjects.projectArrays addObject:self.projects];
	
	//NSMutableArray * builtinProjects=[NSMutableArray new];
//
	//[builtinProjects addObject:[self inboxProject]];
	//[builtinProjects addObject:[self somedayProject]];
	
	//self.projectsViewController.userProjects=self.projects;
	//self.projectsViewController.builtinProjects=builtinProjects;
	
	//[builtinProjects release];
	
	self.projectViewController=[[ProjectViewController alloc] initWithNibName:@"ProjectView" bundle:nil];
	
	//self.projectsViewController.projectViewController=self.projectViewController;
	//self.projectViewController.project=[self inboxProject];
	//self.projectViewController.aggregateView=YES;
	
	//self.navigationController=[[UINavigationController alloc] initWithRootViewController:ç];
	
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
/*
-(Project*) inboxProject
{
	return [self createNewProject:@"_inbox" description:@"These tasks are not added to any projects."]; 
}

-(Project*) somedayProject
{
	return [self createNewProject:@"_someday" description:@"These tasks are for the future."]; 
}*/

-(Project*) createNewProject:(NSString*)name description:(NSString*)description
{
	NSLog(@"createNewProject: %@",name);
	//Project * existing=[self getProjectByName:name];
	//if(existing) return existing;
	Project * newProject=[NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:[self managedObjectContext]];
	newProject.name=name;
	newProject.description=description;
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
	NSPredicate * predicate=[NSPredicate predicateWithFormat:@"project=NULL"];
	
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
	
	NSMutableArray *mutableFetchResults = [[[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy] autorelease];
	
	[request release];
	
	return mutableFetchResults;
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
	managedObjectContext=[self createNewManagedObjectContext:NSMergeByPropertyStoreTrumpMergePolicy];
	
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
	//[navigationController release];
	[projectsViewController release];
	[projectViewController release];
    [window release];
	//[projects release];
    [super dealloc];
}


@end

