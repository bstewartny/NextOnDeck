#import "NextOnDeckAppDelegate_iPhone.h"
#import <QuartzCore/QuartzCore.h>
#import "ProjectsViewController.h"
#import "ProjectsViewController_iPhone.h"
#import "Project.h"
#import "Task.h"
#import "ProjectViewController_iPhone.h"

@implementation NextOnDeckAppDelegate_iPhone
@synthesize projectsViewController;

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
	ProjectViewController_iPhone * projectView=[[ProjectViewController_iPhone alloc] initWithNibName:@"ProjectView-iPhone" bundle:nil];
	
	[projectView setTaskSelector:@selector(getProjectTasks:) withObject:project withTarget:self];
	
	projectView.project=project;
	
	if([project.summary length]>0)
	{
		projectView.title= [NSString stringWithFormat:@"%@ - %@",project.name,project.summary];
	}
	else 
	{
		projectView.title= project.name;
	}
	
	[navController pushViewController:projectView animated:YES];
	
	[projectView release];
}

- (void) setUpWindow
{
	NSLog(@"iPhone setUpWindow");
	// subclass
	
	
	projectsViewController=[[ProjectsViewController_iPhone alloc] initWithNibName:@"ProjectsView-iPhone" bundle:nil];
	navController=[[UINavigationController alloc] initWithRootViewController:self.projectsViewController];
	
	// Add the split view controller's view to the window and display.
	[window addSubview:navController.view];
	
	
	[window makeKeyAndVisible];
}

- (void)dealloc 
{
	[navController release];
	[projectsViewController release];
    [super dealloc];
}

@end
