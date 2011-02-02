#import "TaskFormViewController.h"
#import "Task.h"
#import "Note.h"

@implementation TaskFormViewController
@synthesize task,nameTextField,notesTextField,delegate;

- (IBAction) cancel
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction) done
{
	if (self.nameTextField.text && [self.nameTextField.text length]>0) 
	{
		if(task ==nil)
		{
			task=[[Task  alloc] init];
		}
	
		self.task.name=self.nameTextField.text;
		self.task.note=self.notesTextField.text;
	
		if(delegate)
		{
			[delegate taskFormViewDone:self.task];
		}
	}
	[[self parentViewController] dismissModalViewControllerAnimated:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	NSLog(@"textFieldShouldReturn");
	[theTextField resignFirstResponder];
	[self done];
	return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.nameTextField.delegate=self;
	self.notesTextField.delegate=self;
	[[self nameTextField] becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)dealloc 
{
	[task release];
	[nameTextField release];
	[notesTextField release];
    [super dealloc];
}

@end
