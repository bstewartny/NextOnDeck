#import <UIKit/UIKit.h>

@class Project;

@protocol ProjectPickerDelegate
- (void)projectSelected:(Project *)project;
@end
@class Project;
@interface ProjectPickerViewController : UITableViewController {
	NSArray * projects;
	Project * project;
	id<ProjectPickerDelegate> delegate;
}
@property(nonatomic,retain) Project * project;
@property(nonatomic,retain) NSArray * projects;
@property(nonatomic,assign) id<ProjectPickerDelegate> delegate;


@end
