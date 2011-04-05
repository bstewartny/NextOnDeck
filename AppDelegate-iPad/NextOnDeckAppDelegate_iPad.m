#import "NextOnDeckAppDelegate_iPad.h"
#import <QuartzCore/QuartzCore.h>
#import "ProjectsViewController.h"
#import "ProjectViewController.h"
#import "Project.h"
#import "Task.h"
#import "MGSplitViewController.h"
#import "DropboxSDK.h"

@implementation NextOnDeckAppDelegate_iPad
@synthesize splitViewController,projectsViewController,projectViewController;

- (BOOL) isPhone
{
	return NO;
}

- (void) doLogin
{
	DBLoginController* controller = [[DBLoginController new] autorelease];
	controller.delegate=self;
	[controller presentFromController:splitViewController];
}

- (void) showProjectView:(Project*)project selector:(SEL)selector title:(NSString*)title
{
	[projectViewController setTaskSelector:selector withObject:project withTarget:self];
	projectViewController.project =project;
	projectViewController.title=title;
	[projectViewController.taskTableView reloadData];
}

- (void) showInbox
{
	[self showProjectView:nil selector:@selector(getInboxTasks:) title:@"Inbox - These are unassigned tasks..."];
}

- (void) showNextOnDeck
{
	[self showProjectView:nil selector:@selector(getNextOnDeckTasks:) title:@"Next On Deck - You should perform these tasks next..."];
}

- (void) showProject:(Project*)project
{
	NSString * title;
	if([project.summary length]>0)
	{
		title= [NSString stringWithFormat:@"%@ - %@",project.name,project.summary];
	}
	else 
	{
		title= project.name;
	}
	
	[self showProjectView:project selector:@selector(getProjectTasks:) title:title];
}

- (void) setUpWindow
{
	projectsViewController=[[ProjectsViewController alloc] initWithNibName:@"ProjectsView" bundle:nil];

	projectViewController=[[ProjectViewController alloc] initWithNibName:@"ProjectView" bundle:nil];

	splitViewController=[[MGSplitViewController alloc] init];
	splitViewController.dividerStyle=MGSplitViewDividerStyleNone;
	splitViewController.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
	splitViewController.showsMasterInPortrait=YES;
	splitViewController.viewControllers=[NSArray arrayWithObjects:projectsViewController,projectViewController,nil];
	
	splitViewController.delegate=projectViewController;

	// Add the split view controller's view to the window and display.
	[window addSubview:splitViewController.view];
	[window makeKeyAndVisible];
}

- (void)dealloc 
{	
    [splitViewController release];
	[projectsViewController release];
	[projectViewController release];
    [super dealloc];
}

@end
