//
//  NextOnDeckAppDelegate.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NextOnDeckAppDelegate.h"


#import "ProjectsViewController.h"
#import "ProjectViewController.h"
#import "Project.h"
#import "Task.h"
#import "NextOnDeckProject.h"

@implementation NextOnDeckAppDelegate

@synthesize window, splitViewController, nextOnDeckProject, uncompletedTasksProject,projectsViewController, unassignedTasks,projectViewController,navigationController,projects;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[self loadArchivedData];
	
	self.projectsViewController=[[ProjectsViewController alloc] init];
	UINavigationController *projectsNavigationController = [[UINavigationController alloc] initWithRootViewController:projectsViewController];
    projectsNavigationController.navigationBar.topItem.title=@"Projects";
	
	self.projectsViewController.projects=self.projects;
	self.projectsViewController.unassignedTasks=self.unassignedTasks;
	
	self.projectViewController=[[ProjectViewController alloc] initWithNibName:@"ProjectView" bundle:nil];
	
	NSMutableArray * allProjects=[NSMutableArray arrayWithArray:self.projects];
	
	[allProjects addObject:self.unassignedTasks];
	
	nextOnDeckProject=[[NextOnDeckProject alloc] initWithProjects:allProjects];
	uncompletedTasksProject=[[UncompletedTasksProject alloc] initWithProjects:allProjects];
	
	self.projectsViewController.projectViewController=self.projectViewController;
	self.projectViewController.project=nextOnDeckProject;
	self.projectViewController.aggregateView=YES;
	
	self.navigationController=[[UINavigationController alloc] initWithRootViewController:projectViewController];
	
	self.splitViewController=[[UISplitViewController alloc] init];
	
	self.splitViewController.viewControllers=[NSArray arrayWithObjects:projectsNavigationController,navigationController,nil];
	self.splitViewController.delegate=self.projectViewController;
	
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    
    return YES;
}

- (Project*) findProjectForTask:(Task*)task
{
	// a hack way to get the project for a task...
	for(Project * project in self.projects)
	{
		for(Task * t in project.tasks)
		{
			if([t isEqual:task])
			{
				return project;
			}
		}
	}
	return unassignedTasks;
}


- (NSString *)dataFilePath
{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"archive"];
}

- (void) loadArchivedData
{
	NSData * data =[[NSMutableData alloc]
					initWithContentsOfFile:[self dataFilePath]];
	
	if (data) {
		
		NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]
										  initForReadingWithData:data];
		
		self.projects=[unarchiver decodeObjectForKey:@"projects"];
		
		self.unassignedTasks=[unarchiver decodeObjectForKey:@"unassignedTasks"];
		
		[unarchiver finishDecoding];
		
		[unarchiver	release];
		
		[data release];
	}
	if(projects==nil)
	{
		projects=[[NSMutableArray alloc] init];
	}
	if(unassignedTasks==nil)
	{
		unassignedTasks=[[Project alloc] init];
		unassignedTasks.name=@"Unassigned";
	}
}

- (void) saveData
{
	NSMutableData * data=[[NSMutableData alloc] init];
	
	if(data)
	{
		NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		
		if(projects!=nil)
		{
			[archiver encodeObject:projects	forKey:@"projects"];
		}
		
		[archiver encodeObject:unassignedTasks forKey:@"unassignedTasks"];
		
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


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [splitViewController release];
	[navigationController release];
	[projectsViewController release];
	[projectViewController release];
    [window release];
	[projects release];
	[unassignedTasks release];
	[nextOnDeckProject release];
	[uncompletedTasksProject release];
    [super dealloc];
}


@end

