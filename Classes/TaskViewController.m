    //
//  TaskViewController.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TaskViewController.h"
#import "Task.h"
 

@implementation TaskViewController
@synthesize task,notesTextView,createdOnLabel,completedOnLabel,nameLabel;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"viewDidLoad");
	
	notesTextView.text=task.note;
	nameLabel.text=task.name;
	
	createdOnLabel.text=[task.createdOn description];
	if(task.completed)
	{
		completedOnLabel.text=[task.completedOn description];
	}
	else 
	{
		completedOnLabel.text=@"Not completed yet.";
	}
    [super viewDidLoad];
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
	[task release];
	[notesTextView release];
	[createdOnLabel release];
	[completedOnLabel release];
	[nameLabel release];
    [super dealloc];
}

@end
