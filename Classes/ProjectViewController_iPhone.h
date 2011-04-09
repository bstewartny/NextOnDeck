#import <UIKit/UIKit.h>


@class Project;
 

@interface ProjectViewController_iPhone : UIViewController{
	Project * project;
	IBOutlet UITableView * taskTableView;
	NSArray * tasks;
	SEL _selector;
	id _target;
	id _object;
	BOOL deleteRowMode;
}
@property(nonatomic,retain) Project * project;
@property(nonatomic,retain) IBOutlet UITableView * taskTableView;

- (void) setTaskSelector:(SEL)selector withObject:(id)object withTarget:(id)target;

- (IBAction)add:(id)sender;

@end
