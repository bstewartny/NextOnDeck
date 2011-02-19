#import "NextOnDeckAppDelegate.h"
#import <Foundation/Foundation.h>

@class ProjectsViewController;
@interface NextOnDeckAppDelegate_iPhone : NextOnDeckAppDelegate 
{
	ProjectsViewController *projectsViewController;
}
@property (nonatomic, retain) IBOutlet ProjectsViewController *projectsViewController;

@end
