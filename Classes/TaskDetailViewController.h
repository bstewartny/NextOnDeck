//
//  TaskDetailViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectPickerViewController.h"

@class Task;
 
@interface TaskDetailViewController : UIViewController <UITextViewDelegate,UIPopoverControllerDelegate,ProjectPickerDelegate> {
	IBOutlet UITableView * tableView;
	Task * task;
	UITextField * nameTextField;
	UITextView * notesTextView;
	id delegate;
	UIPopoverController * projectPickerPopover;
	ProjectPickerViewController * projectPicker;
	
	
}

@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic,retain) Task * task;
@property(nonatomic,assign) id delegate;
@property(nonatomic,retain) UIPopoverController * projectPickerPopover;
@property(nonatomic,retain) ProjectPickerViewController * projectPicker;

@end
