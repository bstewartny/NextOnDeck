#import "NextOnDeckAppDelegate.h"
#import <Foundation/Foundation.h>

@class ProjectsViewController;
@interface NextOnDeckAppDelegate_iPhone : NextOnDeckAppDelegate 
{
	UINavigationController * navController;
	ProjectsViewController *projectsViewController;
}
@property (nonatomic, retain) IBOutlet ProjectsViewController *projectsViewController;

@end
