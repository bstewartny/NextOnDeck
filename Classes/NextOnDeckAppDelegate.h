//
//  NextOnDeckAppDelegate.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ProjectsViewController;
@class ProjectViewController;
@class Project;
@class Task;
@class NextOnDeckProject;
@class UncompletedTasksProject;

@interface NextOnDeckAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
	ProjectsViewController *projectsViewController;
    ProjectViewController *projectViewController;
	
	UINavigationController * navigationController;
	
	NSMutableArray * projects;
	
	Project * unassignedTasks;
	
	NextOnDeckProject * nextOnDeckProject;
	UncompletedTasksProject * uncompletedTasksProject;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) NSMutableArray * projects;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet ProjectsViewController *projectsViewController;
@property (nonatomic, retain) IBOutlet ProjectViewController *projectViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic,retain) Project * unassignedTasks;
@property (nonatomic, retain) NextOnDeckProject * nextOnDeckProject;
@property (nonatomic, retain) UncompletedTasksProject * uncompletedTasksProject;



- (void) loadArchivedData;
- (void) saveData;

- (Project*) findProjectForTask:(Task*)task;

@end
