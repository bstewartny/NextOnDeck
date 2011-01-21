    //
//  DateViewController.m
//  NextOnDeck
//
//  Created by Robert Stewart on 10/20/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "DateViewController.h"

@implementation DateViewController
@synthesize datePicker;
@synthesize dateTableView;
@synthesize date;
@synthesize delegate;

-(IBAction)dateChanged
{
    self.date = [datePicker date];
    [dateTableView reloadData];
}

-(IBAction)cancel
{
	[self.delegate cancelledDatePicker];
}

-(IBAction)save
{
	self.date = [datePicker date];
    [self.delegate pickedDate:date];
}
- (void)loadView
{
    UIView *theView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = theView;
    [theView release];
	
	
    UITableView *theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 105.0) style:UITableViewStyleGrouped];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [self.view addSubview:theTableView];
    self.dateTableView = theTableView;
    [theTableView release];
	
    UIDatePicker *theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 149.0, 320.0, 216.0)];
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker = theDatePicker;
    [theDatePicker release];
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
	
	UINavigationBar *navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320.0,44)];
	
	[self.view addSubview:navBar];
	
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Cancel" 
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel)];
    
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save" 
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(save)];
    
	UINavigationItem * navItem=[[UINavigationItem alloc] initWithTitle:nil];
	[navBar pushNavigationItem:navItem animated:NO];
	[navItem release];
	
	navBar.topItem.leftBarButtonItem=cancelButton;
	navBar.topItem.rightBarButtonItem=saveButton;
	
	[navBar release];
	
	[cancelButton release];
	
	[saveButton release];
	
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 365.0);
}

- (void)viewWillAppear:(BOOL)animated
{
	if(self.date==nil) self.date=[NSDate date];
	[self.datePicker setDate:date animated:NO];
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for reinforcemented orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [datePicker release];
    [dateTableView release];
    [date release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
    
	if(indexPath.row==0)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MMMM dd, yyyy"];
		
		if(date)
		{
			cell.text = [formatter stringFromDate:date];
		}
		else 
		{
			cell.text="No date selected.";
		}

		[formatter release];
	}
	if(indexPath.row==1)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
		
		cell.text=@"Tap to use no date";	
	}
	 	
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.row==1)
	{
		// use no due date
		// select row
		// set due date to nil
		self.date=nil;
		[self.delegate pickedDate:nil];
	}
}
@end