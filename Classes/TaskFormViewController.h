#import <UIKit/UIKit.h>

@class Task;

@interface TaskFormViewController : UIViewController 
{
	Task * task;
	IBOutlet UITextField * nameTextField;
	IBOutlet UITextView * notesTextField;
	id delegate;
}
@property(nonatomic,retain) Task * task;
@property(nonatomic,retain) IBOutlet UITextField * nameTextField;
@property(nonatomic,retain) IBOutlet UITextView * notesTextField;
@property(nonatomic,assign) id delegate;
- (IBAction) cancel;
- (IBAction) done;

@end
