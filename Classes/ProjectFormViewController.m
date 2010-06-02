    //
//  ProjectFormViewController.m
//  NextOnDeck
//
//  Created by Robert Stewart on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProjectFormViewController.h"
#import "Project.h"
 
@implementation ProjectFormViewController
@synthesize textField,project,delegate;

- (IBAction) cancel
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction) done
{
	if (self.textField.text && [self.textField.text length]>0) {
		
		if(project==nil)
		{
			project=[[Project alloc] init];
		}
	
		self.project.name=self.textField.text;
	
		if(delegate)
		{
			[delegate projectFormViewDone:self.project];
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
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.textField.delegate=self;
	[[self textField] becomeFirstResponder];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[textField release];
	[project release];
    [super dealloc];
}


@end
