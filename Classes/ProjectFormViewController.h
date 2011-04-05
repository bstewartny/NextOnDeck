#import <UIKit/UIKit.h>
@class Project;

@interface ProjectFormViewController : UITableViewController 
{
	IBOutlet UITextField * textField;
	Project * project;
	id delegate;
}

@property(nonatomic,retain) IBOutlet UITextField * textField;
@property(nonatomic,retain) Project * project;
@property(nonatomic,assign) id delegate;

- (IBAction) cancel;
- (IBAction) done;

@end
