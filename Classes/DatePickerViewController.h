//
//  DatePickerViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 5/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerViewController : UIViewController {
	IBOutlet UITableView * tableView;
	IBOutlet UIDatePicker * datePicker;
	NSDate * dueDate;
	UILabel * dueDateLabel;
	id delegate;
	NSDateFormatter * formatter;
	
}
@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic,retain) IBOutlet UIDatePicker * datePicker;
@property(nonatomic,retain) NSDate * dueDate;
@property(nonatomic,assign) id delegate;
@property(nonatomic,retain) NSDateFormatter * formatter;



- (IBAction) done;
- (IBAction) cancel;


@end
