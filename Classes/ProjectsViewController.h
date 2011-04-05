#import <UIKit/UIKit.h>
@class BlankToolbar;

@interface ProjectsViewController : UIViewController 
{
	IBOutlet UITableView * tableView;
	IBOutlet BlankToolbar * blankToolbar;
	NSArray * allProjects;
}
@property(nonatomic,retain) UITableView * tableView;
@property(nonatomic,retain) BlankToolbar * blankToolbar;

- (IBAction) refresh:(id)sender;
- (IBAction) add:(id)sender;

@end
