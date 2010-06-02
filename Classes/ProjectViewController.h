//
//  ProjectViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Project;
@class Task;

@interface ProjectViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate>{
	Project * project;
	UIPopoverController * popoverController;
	IBOutlet UITableView * taskTableView;
	BOOL aggregateView;
}
@property(nonatomic,retain) Project * project;
@property(nonatomic,retain) IBOutlet UITableView * taskTableView;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property(nonatomic) BOOL aggregateView;

- (void) taskFormViewDone:(Task*)newTask project:(Project*)newProject;

@end
