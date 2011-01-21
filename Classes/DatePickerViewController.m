    //
//  DatePickerViewController.m
//  NextOnDeck
//
//  Created by Robert Stewart on 5/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"


@implementation DatePickerViewController
@synthesize tableView,datePicker,dueDate,delegate,formatter;

- (IBAction) done
{
	[delegate pickedDueDate:self.dueDate];
}
- (IBAction) dateValueChanged
{
	NSLog(@"dateValueChanged");
	self.dueDate=self.datePicker.date;
}
- (IBAction) cancel
{
	[delegate cancelledDatePicker];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
	//self.datePicker.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	//[self.view addSubview:self.datePicker];
	
	if(dueDate!=nil)
	{
		self.datePicker.date=dueDate;
	}
	
	[self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
	
	self.contentSizeForViewInPopover = CGSizeMake(350.0, 420.0);

	formatter=[[NSDateFormatter alloc] init];

	[formatter setDateFormat:@"MMM d, yyyy"];
	
}

- (void) dateChanged:(id)sender
{
	self.dueDate=self.datePicker.date;
	if(dueDateLabel)
	{
		dueDateLabel.text=[formatter stringFromDate:self.dueDate];
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell;
	if(indexPath.row==0)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.textLabel.text=@"Due Date:";
		if(self.dueDate)
		{
			cell.detailTextLabel.text=[formatter stringFromDate:self.dueDate];
		}
		else {
			cell.detailTextLabel.text=@"(None)";
		}
		dueDateLabel=cell.detailTextLabel;
	}
	if(indexPath.row==1)
	{

		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle=UITableViewCellSelectionStyleBlue;
		cell.textLabel.text=@"No Due Date";
	}
	if(indexPath.row==2)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		[cell.contentView addSubview:datePicker];
		
		//cell.textLabel.text=@"No Due Date";
	}
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.row==1)
	{
		// use no due date
		// select row
		// set due date to nil
		self.dueDate=nil;
		//[self.datePicker setDate:nil];
		// change label to show no due date...
		dueDateLabel.text=@"(None)";
	}
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
	[tableView release];
	[dueDate release];
	[datePicker release];
	[formatter release];
    [super dealloc];
}


@end
