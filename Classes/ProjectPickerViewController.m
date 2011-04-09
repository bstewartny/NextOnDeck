#import "ProjectPickerViewController.h"
#import "Project.h"

@implementation ProjectPickerViewController
@synthesize projects,project,delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.clearsSelectionOnViewWillAppear = NO;
	self.contentSizeForViewInPopover = CGSizeMake(250.0, 350.0);
	self.navigationItem.title=@"Projects";
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [self.projects count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}

	cell.accessoryType=UITableViewCellAccessoryNone;
	
	if(indexPath.row>0)
	{
		Project * p=[projects objectAtIndex:indexPath.row-1];
	
		cell.textLabel.text=p.name;
	
		if([p isEqual:project])
		{
			cell.accessoryType=UITableViewCellAccessoryCheckmark;
		}
	}
	else 
	{
		cell.textLabel.text=@"Inbox";
		if(project==nil)
		{
			cell.accessoryType=UITableViewCellAccessoryCheckmark;
		}
	}

	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	if(indexPath.row>0)
	{
		self.project=[projects objectAtIndex:indexPath.row-1];
	}
	else 
	{
		self.project=nil;
	}
	
	[self.tableView reloadData];
	
	if(delegate)
	{
		[delegate projectSelected:self.project];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}
 
- (void)dealloc 
{
	[projects release];
	[project release];
    [super dealloc];
}

@end
