#import "NextOnDeckAppDelegate_iPad.h"
#import <QuartzCore/QuartzCore.h>
#import "ProjectsViewController.h"
#import "ProjectViewController.h"
#import "Project.h"
#import "Task.h"
#import "MGSplitViewController.h"

@implementation NextOnDeckAppDelegate_iPad
@synthesize splitViewController,projectsViewController,projectViewController;

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

- (void) setUpWindow
{
	NSLog(@"iPad setUpWindow");
	self.projectsViewController=[[ProjectsViewController alloc] initWithNibName:@"ProjectsView" bundle:nil];

	self.projectViewController=[[ProjectViewController alloc] initWithNibName:@"ProjectView" bundle:nil];

	self.splitViewController=[[MGSplitViewController alloc] init];
	self.splitViewController.dividerStyle=MGSplitViewDividerStyleNone;
	self.splitViewController.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
	self.splitViewController.showsMasterInPortrait=YES;
	self.splitViewController.viewControllers=[NSArray arrayWithObjects:projectsViewController,projectViewController,nil];

	self.splitViewController.delegate=self.projectViewController;

	// Add the split view controller's view to the window and display.
	[window addSubview:splitViewController.view];
	[window makeKeyAndVisible];
}


- (void)dealloc {
	
    [splitViewController release];
	[projectsViewController release];
	[projectViewController release];
    
    [super dealloc];
}

@end