//
//  DateViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 10/20/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DateViewDelegate <NSObject>
@required
- (void)pickedDate:(NSDate *)newDate;
- (void) cancelledDatePicker;
@end

@interface DateViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UIDatePicker            *datePicker;
    UITableView             *dateTableView;
    NSDate                  *date;
	
    id <DateViewDelegate>   delegate;   // weak ref
}
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UITableView *dateTableView;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign)  id <DateViewDelegate> delegate;
-(IBAction)dateChanged;
@end