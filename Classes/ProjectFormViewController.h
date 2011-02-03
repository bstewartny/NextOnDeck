#import <UIKit/UIKit.h>
@class Project;

@interface ProjectFormViewController : UIViewController {
	IBOutlet UITextField * textField;
	IBOutlet UITextField * summaryField;
	Project * project;
	id delegate;
}
@property(nonatomic,retain) IBOutlet UITextField * textField;
@property(nonatomic,retain) IBOutlet UITextField * summaryField;
@property(nonatomic,retain) Project * project;
@property(nonatomic,assign) id delegate;

- (IBAction) cancel;
- (IBAction) done;

@end
