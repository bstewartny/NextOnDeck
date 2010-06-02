//
//  RootViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectViewController;
@class Project;

@interface ProjectsViewController : UITableViewController {
    ProjectViewController *projectViewController;
	NSMutableArray * projects;
	Project * unassignedTasks;
}

@property (nonatomic, retain) IBOutlet ProjectViewController *projectViewController;
@property (nonatomic,retain) NSMutableArray * projects;
@property (nonatomic,retain) Project * unassignedTasks;

@end
