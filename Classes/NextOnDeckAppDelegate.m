//
//  NextOnDeckAppDelegate.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NextOnDeckAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#import "ProjectsViewController.h"
#import "ProjectViewController.h"
#import "Project.h"
#import "Task.h"
#import "NextOnDeckProject.h"
#import "UncompletedTasksProject.h"
#import "DueDatesProject.h"
#import "OverdueProject.h"
#import "SomedayMaybeProject.h"
#import "InboxProject.h"

@implementation NextOnDeckAppDelegate

@synthesize window, splitViewController, somedayMaybeTasks,overdueProject,dueDatesProject,nextOnDeckProject, uncompletedTasksProject,projectsViewController, unassignedTasks,projectViewController,navigationController,projects;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[self loadArchivedData];
	
	self.projectsViewController=[[ProjectsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *projectsNavigationController = [[UINavigationController alloc] initWithRootViewController:projectsViewController];
    //projectsNavigationController.navigationBar.topItem.title=@"Projects";
	//projectsNavigationController.navigationBar.barStyle=UIBarStyleBlack;
	
	NSMutableArray * allProjects=[NSMutableArray arrayWithArray:self.projects];
	[allProjects addObject:self.unassignedTasks];
	
	nextOnDeckProject=[[NextOnDeckProject alloc] initWithProjects:allProjects];
	uncompletedTasksProject=[[UncompletedTasksProject alloc] initWithProjects:allProjects];
	dueDatesProject=[[DueDatesProject alloc] initWithProjects:allProjects];
	overdueProject=[[OverdueProject alloc] initWithProjects:allProjects];
	
	NSMutableArray * builtinProjects=[NSMutableArray new];
	[builtinProjects addObject:unassignedTasks];
	[builtinProjects addObject:overdueProject];
	[builtinProjects addObject:nextOnDeckProject];
	[builtinProjects addObject:dueDatesProject];
	[builtinProjects addObject:somedayMaybeTasks];
	
	self.projectsViewController.userProjects=self.projects;
	self.projectsViewController.builtinProjects=builtinProjects;
	
	[builtinProjects release];
	
	self.projectViewController=[[ProjectViewController alloc] initWithNibName:@"ProjectView" bundle:nil];
	
	self.projectsViewController.projectViewController=self.projectViewController;
	self.projectViewController.project=nextOnDeckProject;
	self.projectViewController.aggregateView=YES;
	
	self.navigationController=[[UINavigationController alloc] initWithRootViewController:projectViewController];
	//navigationController.navigationBar.barStyle=UIBarStyleBlack;
	
	//self.navigationController.view.backgroundColor=[UIColor grayColor];
	//self.navigationController.view.layer.cornerRadius=8;
	//self.navigationController.view.layer.borderWidth=10;
	//self.navigationController.view.layer.shadowRadius=4;
	//self.navigationController.view.layer.shadowColor=[UIColor grayColor].CGColor;
	
	
	self.splitViewController=[[UISplitViewController alloc] init];
	
	self.splitViewController.viewControllers=[NSArray arrayWithObjects:projectsNavigationController,navigationController,nil];
	//self.splitViewController.viewControllers=[NSArray arrayWithObjects:projectsViewController,navigationController,nil];
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
	
	for(Task * t in somedayMaybeTasks.tasks)
	{	
		if([t isEqual:task])
		{
			return somedayMaybeTasks;
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
		self.somedayMaybeTasks=[unarchiver decodeObjectForKey:@"somedayMaybeTasks"];
		
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
		unassignedTasks=[[InboxProject alloc] init];
		 
	}
	if(somedayMaybeTasks==nil)
	{
		somedayMaybeTasks=[[SomedayMaybeProject alloc] init];
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
		[archiver encodeObject:somedayMaybeTasks forKey:@"somedayMaybeTasks"];
		
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
	[somedayMaybeTasks release];
	[overdueProject release];
	[dueDatesProject release];
    [super dealloc];
}


@end

