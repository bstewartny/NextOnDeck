//
//  TaskDetailViewController.m
//  NextOnDeck
//
//  Created by Robert Stewart on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddTaskViewController.h"
#import "Task.h"
#import "Project.h"
#import "DatePickerViewController.h"
@implementation AddTaskViewController
@synthesize tableView,task,navigationBar,prioritySegmentedControl,estimatedTimeSegmentedControl,formatter,actionButton,editMode,delegate,nameTextField,notesTextView,project,datePickerPopover,datePicker,projectPickerPopover,projectPicker;

- (IBAction) cancel
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction) done
{
	if (self.nameTextField.text && [self.nameTextField.text length]>0) {
	
		if(task ==nil)
		{
			task=[[Task  alloc] init];
		}
		
		self.task.name=self.nameTextField.text;
		self.task.note=self.notesTextView.text;
		self.task.priority=self.prioritySegmentedControl.selectedSegmentIndex;
		
		switch(self.estimatedTimeSegmentedControl.selectedSegmentIndex)
		{
			case 0:// 2 min
				self.task.estimatedTime=120;
				break;
			case 1:// 15 min
				self.task.estimatedTime=240;
				break;
			case 2:// 1 hr
				self.task.estimatedTime=3600;
				break;
			case 3:// 2 hr
				self.task.estimatedTime=3600*2;
				break;
			case 4:// 4 hr
				self.task.estimatedTime=3600*4;
				break;
			case 5:// 1 day
				self.task.estimatedTime=3600*24;
				break;
		}
		
		
		
		if(delegate)
		{
			[delegate taskFormViewDone:self.task project:self.project editMode:self.editMode];
		}
	}
	[[self parentViewController] dismissModalViewControllerAnimated:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if(self.editMode)
	{
		self.title=@"Edit Task";
		self.navigationItem.title=@"Edit Task";
		self.navigationBar.topItem.title=@"Edit Task";
	}
	else 
	{
		self.title=@"New Task";
		self.navigationItem.title=@"New Task";
		self.navigationBar.topItem.title=@"New Task";
		
		[self.actionButton setEnabled:NO];
		

	}
	
	
	formatter=[[NSDateFormatter alloc] init];
	
	[formatter setDateFormat:@"MMM d, yyyy h:mm a"];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	[theTextField resignFirstResponder];
		
	if(!self.editMode)
	{
		[self done];
	}
		
	return YES;
}

- (UITableViewCell*) getPriorityCell
{
	static NSString * cellIdentifier=@"priorityCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		cell.textLabel.text=@"Priority:";
		cell.textLabel.textColor=[UIColor grayColor];
		cell.textLabel.font=[UIFont systemFontOfSize:18];
		
		prioritySegmentedControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Low",@"Normal",@"High",nil]];
		
		prioritySegmentedControl.frame=CGRectMake(120,8,350,30);
		
		[cell.contentView addSubview:prioritySegmentedControl];
	}
	
	if(self.task)
	{
		prioritySegmentedControl.selectedSegmentIndex=self.task.priority;
	}
	else 
	{
		prioritySegmentedControl.selectedSegmentIndex=TaskPriorityNormal;
	}

	
	
	return cell;
}

- (UITableViewCell*) getEstimatedTimeCell
{
	static NSString * cellIdentifier=@"estimatedTimeCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		cell.textLabel.text=@"Est. Time:";
		cell.textLabel.textColor=[UIColor grayColor];
		cell.textLabel.font=[UIFont systemFontOfSize:18];
		
		estimatedTimeSegmentedControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"2min",@"15min",@"1hr",@"2hr",@"4hr",@"1day",nil]];
		
		estimatedTimeSegmentedControl.frame=CGRectMake(120,8,350,30);
		
		[cell.contentView addSubview:estimatedTimeSegmentedControl];
	}
	
	if(self.task)
	{
		int minutes=[self.task estimatedTimeMinutes];
		switch (minutes) {
			case 2:
				estimatedTimeSegmentedControl.selectedSegmentIndex=0;
				break;
			case 15:
				estimatedTimeSegmentedControl.selectedSegmentIndex=1;
				break;
			case 60:
				estimatedTimeSegmentedControl.selectedSegmentIndex=2;
				break;
			case 120:
				estimatedTimeSegmentedControl.selectedSegmentIndex=3;
				break;
			case 240:
				estimatedTimeSegmentedControl.selectedSegmentIndex=4;
				break;
			case 1440:
				estimatedTimeSegmentedControl.selectedSegmentIndex=5;
				break;
			default:
				estimatedTimeSegmentedControl.selectedSegmentIndex=1; // default to 15 mins
				break;
		}
	}
	
	return cell;
}

- (UITableViewCell*) getNameCell
{
	static NSString * cellIdentifier=@"nameCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 12, 400, 25)];
		textField.clearsOnBeginEditing = NO;
		textField.font=[UIFont boldSystemFontOfSize:18];
		textField.delegate=self;
		
		self.nameTextField=textField;
		
		if(!self.editMode)
		{
			[[self nameTextField] becomeFirstResponder];
		}
		
		[textField addTarget:self action:@selector(nameTextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
		
		cell.textLabel.text=@"Title:";
		cell.textLabel.font=[UIFont systemFontOfSize:18];
		cell.textLabel.textColor=[UIColor grayColor];
		
		if(self.editMode)
		{
			if(self.task)
			{
				textField.text=self.task.name;
			}
		}
		
		[cell.contentView addSubview:textField];
		
		[textField release];
	}
	return cell;
}

- (UITableViewCell*) getProjectCell
{
	static NSString * cellIdentifier=@"projectCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	
		cell.textLabel.text=@"Project:";
		cell.textLabel.textColor=[UIColor grayColor];
		cell.textLabel.font=[UIFont systemFontOfSize:18];
	
	}
	
	cell.detailTextLabel.text=self.project.name;
	
	projectPickerOriginView=cell.detailTextLabel;

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
	static NSString * cellIdentifier=@"dueDateCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
	
	
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	
		cell.textLabel.text=@"Due Date:";
		cell.textLabel.textColor=[UIColor grayColor];
		cell.textLabel.font=[UIFont systemFontOfSize:18];

	}
	if(self.task.dueDate)
	{
		cell.detailTextLabel.text=[formatter stringFromDate:self.task.dueDate];
	}
	else
	{
		cell.detailTextLabel.text=@"(None)";
	}
	
	datePickerOriginView=cell.detailTextLabel;
	
	return cell;
}

- (UITableViewCell*) getNotesCell
{
	static NSString * cellIdentifier=@"notesCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
		UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
		label.text=@"Notes:";
		label.textColor=[UIColor grayColor];
		label.backgroundColor=[UIColor clearColor];
		label.font=[UIFont systemFontOfSize:18];
		
		//cell.textLabel.text=@"Notes:";
		//cell.textLabel.frame=CGRectMake(5, 5, 100, 30);
		UITextView * textView=[[UITextView alloc] initWithFrame:CGRectMake(5, 30, 450, 170)];
	
		textView.backgroundColor=[UIColor clearColor];
		textView.font=[UIFont systemFontOfSize:14];
	
		self.notesTextView=textView;
		
		//textView.delegate=self;
	
		if(self.editMode)
		{
			if(self.task)
			{
				textView.text=self.task.note;
			}
		}
	
		
		[cell.contentView addSubview:textView];
		[cell.contentView addSubview:label];
		
		[label release];
		[textView release];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section==2)
	{
		return 210;
	}
	else 
	{
		return 44;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
		case 0:
			return 1;
		case 1:
			return 4;
		case 2:
			return 1;
		default:
			return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		switch (indexPath.section) {
				
			case 0:
				return [self getNameCell];
				
			case 1:
			{
				switch (indexPath.row) {
					case 0:
						return [self getProjectCell];
					case 1:
						return [self getPriorityCell];
					case 2:
						return [self getDueDateCell];
					case 3:
						return [self getEstimatedTimeCell];
					default:
						return nil;
				}
			}
					
			case 2:
				return [self getNotesCell];
				
			default:
				return nil;
		}
}


- (void) pickedDueDate:(NSDate*)dueDate
{
	self.task.dueDate=dueDate;
	[self.datePickerPopover dismissPopoverAnimated:YES];

	[self.tableView reloadData];
}
- (void) cancelledDatePicker
{
	[self.datePickerPopover dismissPopoverAnimated:YES];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

		switch (indexPath.section) {
				
			case 1:
				
			{
				switch (indexPath.row) {
					case 2:
						// choose due date from date picker control
						//if(datePicker==nil)
						//{
							self.datePicker=[[DatePickerViewController alloc] initWithNibName:@"DatePickerView" bundle:nil];
							
							
							self.datePickerPopover=[[UIPopoverController alloc]
													initWithContentViewController:datePicker];
						//}
						
						self.datePicker.dueDate=self.task.dueDate;
						self.datePicker.delegate=self;
						if(self.task.dueDate)
						{
							self.datePicker.datePicker.date=self.task.dueDate;
						}
						else 
						{
							self.datePicker.datePicker.date=[NSDate date];
						}
						[self.datePicker release];
						
						[self.datePickerPopover presentPopoverFromRect:CGRectMake(5,5,20,20) inView:datePickerOriginView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
						
						break;
					case 0:
						// choose project from list
						//if (projectPicker == nil) {
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
						//}
						[self.projectPicker release];
						
						//[self.projectPickerPopover presentPopoverFromRect:CGRectMake(450, 150, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
						[self.projectPickerPopover presentPopoverFromRect:CGRectMake(5, 5, 20, 20) inView:projectPickerOriginView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
						
				}
			}
				
		}
}

- (void)projectSelected:(Project *)newProject
{
	self.project=newProject;
	
	[self.projectPickerPopover dismissPopoverAnimated:YES];
		
	[self.tableView reloadData];
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
- (IBAction) actionTouch:(id)sender
{
	
}

- (void)dealloc {
	[tableView release];
	[task release];
	[nameTextField release];
	[notesTextView release];
	[project release];
	[projectPickerPopover release];
	[datePickerPopover release];
	[projectPicker release];
	[datePicker release];
	[navigationBar release];
	[actionButton release];
	[formatter release];
	[prioritySegmentedControl release];
	[estimatedTimeSegmentedControl release];
    [super dealloc];
}


@end
