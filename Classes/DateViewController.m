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
	self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [theView release];
	
	UITableView *theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 140.0) style:UITableViewStyleGrouped];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [self.view addSubview:theTableView];
    self.dateTableView = theTableView;
    [theTableView release];
	
	UIDatePicker *theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 140.0, 320.0, 250.0)];
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker = theDatePicker;
    [theDatePicker release];
	self.datePicker.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
	
	
	//UINavigationBar *navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320.0,44)];
	
	//[self.view addSubview:navBar];
	
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
    
	//UINavigationItem * navItem=[[UINavigationItem alloc] initWithTitle:nil];
	//[navBar pushNavigationItem:navItem animated:NO];
	//[navItem release];
	
	//navBar.topItem.leftBarButtonItem=cancelButton;
	//navBar.topItem.rightBarButtonItem=saveButton;
	
	//[navBar release];
	
	if(self.navigationController==nil)
	{
		self.navigationItem.leftBarButtonItem=cancelButton;
	}
	
	self.navigationItem.rightBarButtonItem=saveButton;
	self.navigationItem.title=@"Due Date";
	
	[cancelButton release];
	
	[saveButton release];
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
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
    
	if(indexPath.section==0)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
		cell.textLabel.textAlignment=UITextAlignmentCenter;
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MMMM dd, yyyy"];
		
		if(date)
		{
			cell.textLabel.text= [formatter stringFromDate:date];
		}
		else 
		{
			cell.textLabel.text=@"No date selected.";
		}

		[formatter release];
	}
	if(indexPath.section==1)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
		cell.textLabel.textAlignment=UITextAlignmentCenter;
		cell.textLabel.text=@"Tap here to use no date";	
	}
	 	
	 return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	 return 1;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.section==0)
	{
		self.date = [datePicker date];
		[self.delegate pickedDate:date];
	}
	
	if(indexPath.section==1)
	{
		// use no due date
		// select row
		// set due date to nil
		self.date=nil;
		[self.delegate pickedDate:nil];
	}
}
@end