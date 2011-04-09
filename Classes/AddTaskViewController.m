#import "AddTaskViewController.h"
#import "Task.h"
#import "Project.h"
#import "DatePickerViewController.h"
#import "UUID.h"

@implementation AddTaskViewController
@synthesize pickedDate,task,formatter,actionButton,editMode,delegate,nameTextField,notesTextView,project,datePickerPopover,projectPickerPopover,projectPicker;//prioritySegmentedControl,estimatedTimeSegmentedControl,

- (id) init
{
	self=[super initWithStyle:UITableViewStyleGrouped];
	if(self)
	{
		
	}
	return self;
}

- (IBAction) cancel
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction) done
{
	switch(addTaskMode)
	{
		case AddTaskModeSingle:
			[self doneSingleMode];
			break;
		case AddTaskModeMultiple:
			[self doneMultiMode];
			break;
	}
}

- (Project*)selectedProject
{
	Project * p=self.project;
	if(p==nil)
	{
		//p=[[[UIApplication sharedApplication] delegate] inboxProject];
	}
	return p;
}

- (void) addNewTask:(NSString*)name note:(NSString*)note dueDate:(NSDate*)dueDate
{
	Project * p=[self selectedProject];
	if(p)
	{
		[p addNewTask:name note:note dueDate:dueDate];
	}
	else 
	{
		Task * t=[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[[[UIApplication sharedApplication] delegate] managedObjectContext]];
		t.uid=[UUID GetUUID];;
		t.name=name;
		t.note=note;
		t.dueDate=dueDate;
		t.createdOn=[NSDate date];
		t.modifiedOn=t.createdOn;
		t.completed=[NSNumber numberWithBool:NO];
		t.project=nil;
		
		[t save];
	}	
}

- (void) doneMultiMode
{
	if(self.notesTextView.text && [self.notesTextView.text length]>0)
	{
		// get multiple names from notes view...
		NSArray * names=[self.notesTextView.text componentsSeparatedByString:@"\n"];
		
		for(NSString * name in names)
		{
			// TODO: strip trailing whitespace and trailing commas from tasks...
			
			if(name==nil || [name length]==0) continue;
			
			[self addNewTask:name note:nil dueDate:self.pickedDate];
		}
		[delegate taskFormViewDone];
	}
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void) doneSingleMode
{
	if (self.nameTextField.text && [self.nameTextField.text length]>0) 
	{
		if(task==nil)
		{
			[self addNewTask:self.nameTextField.text note:self.notesTextView.text dueDate:self.pickedDate];
		}
		else 
		{
			self.task.name=self.nameTextField.text; // TODO: strip trailing whitespace
			self.task.note=self.notesTextView.text;
			self.task.dueDate=self.pickedDate;
			self.task.project=[self selectedProject];
			self.task.modifiedOn=[NSDate date];
			[self.task save];
		}
		
		[delegate taskFormViewDone];
	}
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	
	self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
	
	if(self.editMode)
	{
		self.title=@"Edit Task";
		self.navigationItem.title=@"Edit Task";
	}
	else 
	{
		self.title=@"New Task";
		
		UISegmentedControl * segmentedControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Add One",@"Add Many",nil]];
		segmentedControl.segmentedControlStyle=UISegmentedControlStyleBar;
		[segmentedControl addTarget:self action:@selector(addTaskModeChanged:) forControlEvents:UIControlEventValueChanged];
		segmentedControl.selectedSegmentIndex=0;
		addTaskMode=AddTaskModeSingle;
		self.navigationItem.titleView=segmentedControl;
		
		[segmentedControl release];
		
		[self.actionButton setEnabled:NO];
	}
	
	if(self.task)
	{
		self.pickedDate=self.task.dueDate;
	}
	
	formatter=[[NSDateFormatter alloc] init];
	
	[formatter setDateFormat:@"MMM d, yyyy"];
}

- (void) addTaskModeChanged:(id)sender
{
	UISegmentedControl * segmentedControl=sender;
	
	switch(segmentedControl.selectedSegmentIndex)
	{
		case 0:
			addTaskMode=AddTaskModeSingle;
			break;
		case 1:
			addTaskMode=AddTaskModeMultiple;
			break;
	}
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
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

- (UITableViewCell*) getNameCell
{
	static NSString * cellIdentifier=@"nameCell";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
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
- (UITableViewCell*) completeCell
{
	static NSString * cellIdentifier=@"completeCell";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
		if(![self.task.completed boolValue])
		{
			cell.selectionStyle=UITableViewCellSelectionStyleBlue;
			cell.backgroundColor=[UIColor redColor];
			cell.textLabel.textAlignment=UITextAlignmentCenter;
			cell.textLabel.text=@"Complete";
			cell.textLabel.font=[UIFont boldSystemFontOfSize:20];
							 
			cell.textLabel.textColor=[UIColor whiteColor];
		}
		else {
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
			cell.backgroundColor=[UIColor blueColor];
			cell.textLabel.textAlignment=UITextAlignmentCenter;
			cell.textLabel.text=[NSString stringWithFormat:@"Completed on %@",[formatter stringFromDate:self.task.completedOn]];
			cell.textLabel.font=[UIFont boldSystemFontOfSize:20];
			
			cell.textLabel.textColor=[UIColor whiteColor];
			
		}

		
		
		
	}
	return cell;
}

- (UITableViewCell*) getProjectCell
{
	static NSString * cellIdentifier=@"projectCell";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text=@"Project:";
		cell.textLabel.textColor=[UIColor grayColor];
		cell.textLabel.font=[UIFont systemFontOfSize:18];
	}
	
	if(self.project==nil)
	{
		cell.detailTextLabel.text=@"Inbox";
	}
	else
	{
		cell.detailTextLabel.text=self.project.name;
	}
	
	projectPickerOriginView=cell.detailTextLabel;

	return cell;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (UITableViewCell*) getDueDateCell
{
	static NSString * cellIdentifier=@"dueDateCell";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	
		cell.textLabel.text=@"Due Date:";
		cell.textLabel.textColor=[UIColor grayColor];
		cell.textLabel.font=[UIFont systemFontOfSize:18];
	}

	if(self.pickedDate)
	{
		cell.detailTextLabel.text=[formatter stringFromDate:self.pickedDate];
	}
	else 
	{
		cell.detailTextLabel.text=@"(No due date)";
	}

	datePickerOriginView=cell.detailTextLabel;
	
	return cell;
}

- (UITableViewCell*) getMultiNamesCell
{
	static NSString * cellIdentifier=@"getMultiNamesCell";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 250, 30)];
		label.text=@"Titles (one per line):";
		label.textColor=[UIColor grayColor];
		label.backgroundColor=[UIColor clearColor];
		label.font=[UIFont systemFontOfSize:18];
		
		UITextView * textView=[[UITextView alloc] initWithFrame:CGRectMake(5, 30, 450, 170)];
		
		textView.backgroundColor=[UIColor clearColor];
		textView.font=[UIFont systemFontOfSize:14];
		
		self.notesTextView=textView;
				
		[[self notesTextView] becomeFirstResponder];
		
		[cell.contentView addSubview:textView];
		[cell.contentView addSubview:label];
		
		[label release];
		[textView release];
	}
	
	return cell;
}

- (UITableViewCell*) getNotesCell
{
	static NSString * cellIdentifier=@"notesCell";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
		UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
		label.text=@"Notes:";
		label.textColor=[UIColor grayColor];
		label.backgroundColor=[UIColor clearColor];
		label.font=[UIFont systemFontOfSize:18];
		
		UITextView * textView=[[UITextView alloc] initWithFrame:CGRectMake(5, 30, 450, 120)];
	
		textView.backgroundColor=[UIColor clearColor];
		textView.font=[UIFont systemFontOfSize:14];
	
		self.notesTextView=textView;
		
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
	if(addTaskMode==AddTaskModeMultiple)
	{
		if(indexPath.section==0)
		{
			return 210;
		}
		else 
		{
			return 44;
		}
	}
	else 
	{
		if(indexPath.section==2)
		{
			return 150;
		}
		else 
		{
			return 44;
		}
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
	if(addTaskMode==AddTaskModeMultiple)
	{
		return 2;
	}
	else 
	{
		if(self.editMode)
			return 4;
		else {
			return 3;
		}

		 
	}
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
    if(addTaskMode==AddTaskModeMultiple)
	{
		switch (section) 
		{
		case 0:
			return 1;
		case 1:
			return 2;
		default:
			return 1;
		}
	}
	else 
	{
		switch (section) 
		{
			case 0:
				return 1;
			case 1:
				return 2;
			case 2:
				return 1;
			default:
				return 1;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(addTaskMode==AddTaskModeMultiple)
	{
		switch (indexPath.section) 
		{
			case 0:
				return [self getMultiNamesCell];
				
			case 1:
			{
				switch (indexPath.row) 
				{
					case 0:
						return [self getProjectCell];
					case 1:
						return [self getDueDateCell];
					default:
						return nil;
				}
			}
				
			default:
				return nil;
		}
	}
	else
	{
		switch (indexPath.section) 
		{
			case 0:
				return [self getNameCell];
				
			case 1:
			{
				switch (indexPath.row) 
				{
					case 0:
						return [self getProjectCell];
					case 1:
						return [self getDueDateCell];
					default:
						return nil;
				}
			}
					
			case 2:
				return [self getNotesCell];
				
			default:
				return [self completeCell];
				
				//return nil;
		}
	}
}

- (void) pickedDate:(NSDate*)dueDate
{
	self.pickedDate=dueDate;
	[self.datePickerPopover dismissPopoverAnimated:YES];

	[self.tableView reloadData];
}

- (void) cancelledDatePicker
{
	[self.datePickerPopover dismissPopoverAnimated:YES];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	switch (indexPath.section) 
	{
		case 1:
		{
			switch (indexPath.row) 
			{
				case 1:
				{
					self.datePickerPopover=nil;
					
					// choose due date from date picker control
					DateViewController * dateView=[[DateViewController alloc] init];
					
					dateView.delegate=self;
					
					dateView.date=self.pickedDate;
					
					dateView.contentSizeForViewInPopover = CGSizeMake(320.0, 365.0);
					UIPopoverController * datePopover=[[UIPopoverController alloc]
													   initWithContentViewController:dateView];
						
					self.datePickerPopover=datePopover;
					
					[datePopover release];
					
					[dateView release];
					
					[self.datePickerPopover presentPopoverFromRect:CGRectMake(5,5,20,20) inView:datePickerOriginView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
				}
					break;
				
				case 0:
					// choose project from list
					self.projectPicker = [[ProjectPickerViewController alloc] 
											  initWithStyle:UITableViewStylePlain];
					self.projectPicker.delegate = self;
						
					self.projectPicker.projects=[[[UIApplication sharedApplication] delegate] allProjects];
						
					self.projectPickerPopover = [[UIPopoverController alloc] 
													 initWithContentViewController:projectPicker];               
					
					[self.projectPicker release];
					
					[self.projectPickerPopover presentPopoverFromRect:CGRectMake(5, 5, 20, 20) inView:projectPickerOriginView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
					
			}
		}
			break;
		case 3:
			if(![self.task.completed boolValue])
			{
				self.task.completed=[NSNumber numberWithBool:YES];
				self.task.completedOn=[NSDate date];
				//[self.task save];
				[self done];
			}
			break;
			
	}
}

- (void)projectSelected:(Project *)newProject
{
	self.project=newProject;
	
	[self.projectPickerPopover dismissPopoverAnimated:YES];
		
	[self.tableView reloadData];
}

- (IBAction) actionTouch:(id)sender
{
	
}

- (void)dealloc 
{
	 
	[task release];
	[nameTextField release];
	[notesTextView release];
	[project release];
	[projectPickerPopover release];
	[datePickerPopover release];
	[projectPicker release];
	[pickedDate release];
	 
	[actionButton release];
	[formatter release];
    [super dealloc];
}


@end
