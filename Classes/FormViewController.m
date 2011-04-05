#import "FormViewController.h"
#import "FormViewTableViewController.h"

@implementation FormViewController

- (id) initWithTitle:(NSString*)title tag:(NSInteger)tag delegate:(id)delegate names:(NSArray*)names andValues:(NSArray*)values
{
	FormViewTableViewController * tableView=[[FormViewTableViewController alloc] initWithTitle:title tag:tag delegate:delegate names:names andValues:values];
	
	self=[super initWithRootViewController:tableView];
	
	self.modalPresentationStyle=UIModalPresentationFormSheet;
	
	[tableView release];
	
	return self;
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return ![[[UIApplication sharedApplication] delegate] isPhone];
}

@end
