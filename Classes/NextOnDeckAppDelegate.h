#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ProjectsViewController;
@class ProjectViewController;
@class Project;
@class Task;
@class MGSplitViewController;
@interface NextOnDeckAppDelegate : NSObject <UIApplicationDelegate> 
{    
    UIWindow *window;
    
    MGSplitViewController *splitViewController;
    
	ProjectsViewController *projectsViewController;
    
	ProjectViewController *projectViewController;
	
	NSManagedObjectModel *managedObjectModel;
    
	NSManagedObjectContext *managedObjectContext;	    
    
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MGSplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet ProjectsViewController *projectsViewController;
@property (nonatomic, retain) IBOutlet ProjectViewController *projectViewController;

- (void) loadArchivedData;
- (void) saveData;

//- (Project*) findProjectForTask:(Task*)task;

@end
