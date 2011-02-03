#import "ProjectFormViewController.h"
#import "Project.h"
 
@implementation ProjectFormViewController
@synthesize textField,project,delegate,summaryField;

- (IBAction) cancel
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction) done
{
	if (self.textField.text && [self.textField.text length]>0) {
		
		if(project==nil)
		{
			self.project=[[[UIApplication sharedApplication] delegate] createNewProject:textField.text summary:summaryField.text];
		}
		else 
		{
			self.project.name=self.textField.text;
			self.project.summary=self.summaryField.text;
		}
			
		[delegate projectFormViewDone];
	}
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	[theTextField resignFirstResponder];
	[self done];
	return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.textField.delegate=self;
	[[self textField] becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
	[textField release];
	[summaryField release];
	[project release];
    [super dealloc];
}

@end
