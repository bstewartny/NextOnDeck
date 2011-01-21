//
//  NextOnDeckAppDelegate.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ProjectsViewController;
@class ProjectViewController;
@class Project;
@class Task;
//@class NextOnDeckProject;
//@class UncompletedTasksProject;
///@class DueDatesProject;
//@class OverdueProject;
//@class InboxProject;
//@class SomedayMaybeProject;


@interface NextOnDeckAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
	ProjectsViewController *projectsViewController;
    ProjectViewController *projectViewController;
	
	UINavigationController * navigationController;
	
	NSMutableArray * projects;
	
	//InboxProject * unassignedTasks;
	//SomedayMaybeProject * somedayMaybeTasks;
	//
	//NextOnDeckProject * nextOnDeckProject;
	//UncompletedTasksProject * uncompletedTasksProject;
	//DueDatesProject * dueDatesProject;
	//OverdueProject * overdueProject;
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) NSMutableArray * projects;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet ProjectsViewController *projectsViewController;
@property (nonatomic, retain) IBOutlet ProjectViewController *projectViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
//@property (nonatomic,retain) InboxProject * unassignedTasks;
//@property (nonatomic,retain) SomedayMaybeProject * somedayMaybeTasks;
//@property (nonatomic, retain) NextOnDeckProject * nextOnDeckProject;
//@property (nonatomic, retain) UncompletedTasksProject * uncompletedTasksProject;
//@property (nonatomic, retain) DueDatesProject * dueDatesProject;
//@property (nonatomic, retain) OverdueProject * overdueProject;


- (void) loadArchivedData;
- (void) saveData;

- (Project*) findProjectForTask:(Task*)task;

@end
