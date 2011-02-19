#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"

@class Project;
@class Task;

@interface ProjectViewController : UIViewController <UIPopoverControllerDelegate,MGSplitViewControllerDelegate>{
	Project * project;
	UIPopoverController * popoverController;
	IBOutlet UITableView * taskTableView;
	//BOOL aggregateView;
	IBOutlet UIToolbar * topToolbar;
	IBOutlet UIView * wrapperView;
	NSArray * tasks;
	SEL _selector;
	id _target;
	id _object;
	
	UIToolbar * leftToolbar;
}
@property(nonatomic,retain) Project * project;
@property(nonatomic,retain) IBOutlet UITableView * taskTableView;
@property(nonatomic,retain) IBOutlet UIToolbar * topToolbar;
@property(nonatomic,retain) IBOutlet UIView * wrapperView;
@property(nonatomic,retain) UIToolbar * leftToolbar;
@property (nonatomic, retain) UIPopoverController *popoverController;
//@property(nonatomic) BOOL aggregateView;

- (void) taskFormViewDone;
- (void) setTaskSelector:(SEL)selector withObject:(id)object withTarget:(id)target;

@end
