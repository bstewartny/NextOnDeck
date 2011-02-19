#import "NextOnDeckAppDelegate.h"
#import <Foundation/Foundation.h>

@class ProjectsViewController;
@class ProjectViewController;
@class MGSplitViewController;
@interface NextOnDeckAppDelegate_iPad : NextOnDeckAppDelegate 
{
	MGSplitViewController *splitViewController;
	ProjectsViewController *projectsViewController;
	ProjectViewController *projectViewController;
}
@property (nonatomic, retain) IBOutlet MGSplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet ProjectsViewController *projectsViewController;
@property (nonatomic, retain) IBOutlet ProjectViewController *projectViewController;

@end
