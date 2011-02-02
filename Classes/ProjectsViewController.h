#import <UIKit/UIKit.h>
@class BlankToolbar;

@interface ProjectsViewController : UIViewController 
{
	IBOutlet UITableView * tableView;
	IBOutlet BlankToolbar * blankToolbar;
}
@property(nonatomic,retain) UITableView * tableView;
@property(nonatomic,retain) BlankToolbar * blankToolbar;

@end
