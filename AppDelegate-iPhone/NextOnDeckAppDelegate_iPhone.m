#import "NextOnDeckAppDelegate_iPhone.h"
#import <QuartzCore/QuartzCore.h>
#import "ProjectsViewController.h"
#import "ProjectsViewController_iPhone.h"
#import "Project.h"
#import "Task.h"
#import "ProjectViewController_iPhone.h"
#import "DropboxSDK.h"

@implementation NextOnDeckAppDelegate_iPhone
@synthesize projectsViewController;

- (void) doLogin
{
	DBLoginController* controller = [[DBLoginController new] autorelease];
	controller.delegate=self;
	[controller presentFromController:navController];
}

- (void) showProjectView:(Project*)project selector:(SEL)selector title:(NSString*)title
{
	ProjectViewController_iPhone * projectView=[[ProjectViewController_iPhone alloc] initWithNibName:@"ProjectView-iPhone" bundle:nil];
	
	[projectView setTaskSelector:selector withObject:project withTarget:self];
	
	projectView.project=project;
	projectView.title=title;
	
	[navController pushViewController:projectView animated:YES];
	
	[projectView release];
}

- (void) showInbox
{
	[self showProjectView:nil selector:@selector(getInboxTasks:) title:@"Inbox"];
}

- (BOOL) isPhone
{
	return YES;
}

- (void) showNextOnDeck
{
	[self showProjectView:nil selector:@selector(getNextOnDeckTasks:) title:@"Next On Deck"];
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
	projectsViewController=[[ProjectsViewController_iPhone alloc] initWithNibName:@"ProjectsView-iPhone" bundle:nil];
	navController=[[UINavigationController alloc] initWithRootViewController:self.projectsViewController];
	
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
