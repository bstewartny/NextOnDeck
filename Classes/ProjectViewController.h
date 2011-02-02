#import <UIKit/UIKit.h>
@class Project;
@class Task;

@interface ProjectViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate>{
	Project * project;
	UIPopoverController * popoverController;
	IBOutlet UITableView * taskTableView;
	//BOOL aggregateView;
	IBOutlet UIToolbar * topToolbar;
}
@property(nonatomic,retain) Project * project;
@property(nonatomic,retain) IBOutlet UITableView * taskTableView;
@property(nonatomic,retain) IBOutlet UIToolbar * topToolbar;
@property (nonatomic, retain) UIPopoverController *popoverController;
//@property(nonatomic) BOOL aggregateView;

- (void) taskFormViewDone;

@end
