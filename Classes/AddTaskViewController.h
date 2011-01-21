//
//  AddTaskViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ProjectPickerViewController.h"
#import "DateViewController.h"

@class Task;
@class Project;

typedef enum
{	
	AddTaskModeSingle,
	AddTaskModeMultiple
}
AddTaskMode;



@interface AddTaskViewController : UIViewController <UITextViewDelegate,DateViewDelegate> {
	IBOutlet UITableView * tableView;
	Task * task;
	NSDate * pickedDate;
	Project * project;
	UITextField * nameTextField;
	UITextView * notesTextView;
	id delegate;
	UIPopoverController * projectPickerPopover;
	UIPopoverController * datePickerPopover;
	//DateViewController * datePicker;
	ProjectPickerViewController * projectPicker;
	BOOL editMode;
	UIView * projectPickerOriginView;
	UIView * datePickerOriginView;
	IBOutlet UINavigationBar * navigationBar;
	IBOutlet UIBarButtonItem * actionButton;
	NSDateFormatter * formatter;
	//UISegmentedControl * prioritySegmentedControl;
	//UISegmentedControl * estimatedTimeSegmentedControl;
	AddTaskMode addTaskMode;
}

@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic,retain) Task * task;
@property(nonatomic,retain) Project * project;
@property(nonatomic,retain) NSDate * pickedDate;

@property(nonatomic,assign) id delegate;
@property(nonatomic,retain) UITextField * nameTextField;
@property(nonatomic,retain)  UITextView * notesTextView;
@property(nonatomic,retain) UIPopoverController * projectPickerPopover;
@property(nonatomic,retain) UIPopoverController * datePickerPopover;

@property(nonatomic,retain) ProjectPickerViewController * projectPicker;
//@property(nonatomic,retain) DateViewController * datePicker;

@property(nonatomic,retain) IBOutlet UINavigationBar * navigationBar;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * actionButton;
@property(nonatomic,retain) NSDateFormatter * formatter;

//@property(nonatomic,retain) UISegmentedControl * prioritySegmentedControl;
//@property(nonatomic,retain) UISegmentedControl * estimatedTimeSegmentedControl;


@property(nonatomic) BOOL editMode;

- (IBAction) cancel;
- (IBAction) done;
- (void) pickedDate:(NSDate*) date;
- (void) cancelledDatePicker;
- (IBAction) actionTouch:(id)sender;
@end
