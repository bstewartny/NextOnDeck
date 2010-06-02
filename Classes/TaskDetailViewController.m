    //
//  TaskDetailViewController.m
//  NextOnDeck
//
//  Created by Robert Stewart on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "Task.h"
#import "Project.h"
#import "ProjectPickerViewController.h"

@implementation TaskDetailViewController
@synthesize tableView,task,delegate,projectPickerPopover,projectPicker ;

- (IBAction) cancel
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction) done
{
	//if (self.nameTextField.text && [self.nameTextField.text length]>0) {
		
		//if(task ==nil)
		//{
		//	task=[[Task  alloc] init];
		//}
		
		//self.task.name=self.nameTextField.text;
		//self.task.note=self.notesTextField.text;
		
		if(delegate)
		{
			[delegate taskFormViewDone:self.task];
		}
	//}
	[[self parentViewController] dismissModalViewControllerAnimated:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
		self.title=@"Task Details";
	
		self.navigationItem.title=@"Task Details";
	
		// create action button for this task (to email it, etc.)
	
		UIBarButtonItem * actionButton = [[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self	action:@selector(actionButtonTouched:)];

		self.navigationItem.rightBarButtonItem=actionButton;
	
		[actionButton release];
	 
}

- (void) actionButtonTouched:(id)sender
{
	// show action popup list and/or send as email...
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

-(void) nameTextFieldDone:(id)sender
{
	UITextField *textField=(UITextField *)sender;
	
	if(textField.text && [textField.text length]>0)
	{
		self.task.name=textField.text;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	 	return YES;
}

- (UITableViewCell*) getNameCell
{
	UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	  
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 12, 600, 25)];
	textField.clearsOnBeginEditing = NO;
	textField.text=self.task.name;
	textField.font=[UIFont boldSystemFontOfSize:18];
	textField.delegate=self;
	[textField addTarget:self action:@selector(nameTextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	[cell.contentView addSubview:textField];
	
	[textField release];
	
	return cell;
}

- (UITableViewCell*) getProjectCell
{
	UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	
	cell.textLabel.text=@"Project";
	
	Project * project=[[[UIApplication sharedApplication] delegate] findProjectForTask:task];
	
	 
		cell.detailTextLabel.text=project.name;
	 

	return cell;
}

- (UITableViewCell*) getCreatedOnCell
{
	UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	cell.textLabel.text=@"Created On";
	cell.detailTextLabel.text=[self.task.createdOn description];
	return cell;
}

- (UITableViewCell*) getCompletedOnCell
{
	UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	cell.textLabel.text=@"Completed On";
	
	if(self.task.completed)
	{
		cell.detailTextLabel.text=[self.task.completedOn description];
	}
	else 
	{
		cell.detailTextLabel.text=@"Not completed yet.";
	}

	return cell;
}


- (void)viewWillDisappear:(BOOL)animated
{
	// gather changes user made to properties...
	//self.task.name='';
	//self.task.note='';
	
	[super viewWillDisappear:animated];
}


- (UITableViewCell*) getDueDateCell
{
	UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	
	cell.textLabel.text=@"Due Date";
	cell.detailTextLabel.text=@"(None)";
	return cell;
}

- (UITableViewCell*) getNotesCell
{
	UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	
	UITextView * textView=[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 600, 380)];
	
	textView.text=self.task.note;
	textView.font=[UIFont systemFontOfSize:14];
	
	textView.delegate=self;
	
	[cell.contentView addSubview:textView];
	
	[textView release];
	
	return cell;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	self.task.note=textView.text;
}
 
- (void)textViewDidChange:(UITextView *)textView
{
	self.task.note=textView.text;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	self.task.note=textView.text;
	
	return YES;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	 
		if(indexPath.section==5)
		{
			return 400;
		}
		else 
		{
			return 44;
		}
	 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	 
		if(section==5)
		{
			return @"Task Notes:";
		}
		else 
		{
			return nil;
		}
	 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    
	 
		return 6;
	 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	 
	 
		switch (indexPath.section) {
			
			case 0:
				return [self getNameCell];
			
			case 1:
				return [self getProjectCell];
			
			case 2:
				return [self getCreatedOnCell];
			
			case 3:
				return [self getCompletedOnCell];
			
			case 4:
				return [self getDueDateCell];
			case 5:
				return [self getNotesCell];
				
			default:
				return nil;
		}
	 
}


/* Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the dismissal of the view.
 */
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	
}

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	 
		switch (indexPath.section) {
				
			case 1:
			{
				
				if (projectPicker == nil) {
					self.projectPicker = [[ProjectPickerViewController alloc] 
										 initWithStyle:UITableViewStylePlain];
					self.projectPicker.delegate = self;
					
					NSMutableArray * allProjects=[[NSMutableArray alloc] init];
					
					[allProjects addObject:[[[UIApplication sharedApplication] delegate] unassignedTasks] ];
					
					for (Project * p in [[[UIApplication sharedApplication] delegate] projects]) {
						[allProjects addObject:p];
					}
					
					self.projectPicker.projects=allProjects;
					
					self.projectPickerPopover = [[UIPopoverController alloc] 
												initWithContentViewController:projectPicker];               
				}
				
				[self.projectPickerPopover presentPopoverFromRect:CGRectMake(600, 110, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
			
			}
				break;
				
			case 4:
				
				// choose due date from date picker control
				
				break;
				
				
		}
}

- (void)projectSelected:(Project *)project
{
	Project * current_project=[[[UIApplication sharedApplication] delegate] findProjectForTask:self.task];
	
	if([current_project isEqual:project])
	{
		// do nothing, did not change project
		[self.projectPickerPopover dismissPopoverAnimated:YES];
		
	}
	else 
	{
		// remove task from current project
		[current_project.tasks removeObject:self.task];
		// add task to selected project
		[project.tasks addObject:self.task];
		
		[self.projectPickerPopover dismissPopoverAnimated:YES];
		
		[self.tableView reloadData];
	}
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
	[tableView release];
	[task release];
	[projectPickerPopover release];
	[projectPicker release];
    [super dealloc];
}


@end
