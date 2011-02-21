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
	NSLog(@"DateViewController loadView");
	 
    UIView *theView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = theView;
    [theView release];
	
	NSLog(@"Create table");
	
    UITableView *theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 105.0) style:UITableViewStyleGrouped];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [self.view addSubview:theTableView];
    self.dateTableView = theTableView;
    [theTableView release];
	
	NSLog(@"Create UIDatePicker");
    UIDatePicker *theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 149.0, 320.0, 216.0)];
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker = theDatePicker;
    [theDatePicker release];
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
	
	NSLog(@"Create UINavigationBar");
	
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
	
   // self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	NSLog(@"loadView done");
	
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"viewWillAppear");
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"cellForRowAtIndexPath");
	
	UITableViewCell *cell = nil;
    
	if(indexPath.row==0)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
	if(indexPath.row==1)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
		
		cell.text=@"Tap to use no date";	
	}
	 	
	NSLog(@"cellForRowAtIndexPath done");
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"numberOfRowsInSection");
    return 2;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@"didSelectRowAtIndexPath");
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