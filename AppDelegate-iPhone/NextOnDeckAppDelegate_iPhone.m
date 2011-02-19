#import "NextOnDeckAppDelegate_iPhone.h"
#import <QuartzCore/QuartzCore.h>
#import "ProjectsViewController.h"
#import "Project.h"
#import "Task.h"

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
}

- (void) setUpWindow
{
	NSLog(@"iPhone setUpWindow");
	// subclass
	self.projectsViewController=[[ProjectsViewController alloc] initWithNibName:@"ProjectsView" bundle:nil];
	
	// Add the split view controller's view to the window and display.
	[window addSubview:self.projectsViewController.view];
	[window makeKeyAndVisible];
}

- (void)dealloc 
{
	[projectsViewController release];
    [super dealloc];
}

@end
