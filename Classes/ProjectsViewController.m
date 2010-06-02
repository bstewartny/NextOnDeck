//
//  RootViewController.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ProjectsViewController.h"
#import "ProjectViewController.h"
#import "Task.h"
#import "Project.h"
#import "ProjectFormViewController.h"
#import "NextOnDeckProject.h"

@implementation ProjectsViewController

@synthesize projectViewController,projects,unassignedTasks;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
	  							 
								 
								  
	[self.navigationController.navigationBar.topItem setRightBarButtonItem:addButton animated:NO];
	
	[addButton release];
	
	//UIBarButtonItem * editButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
	UIBarButtonItem * editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
	
	[self.navigationController.navigationBar.topItem setLeftBarButtonItem:editButton animated:NO];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"projectDataChanged" object:nil];
	
	
	[editButton release];
	
}

- (void)handleNotification:(NSNotification*)notification
{
	NSLog(@"handledNotification");
	[self.tableView reloadData];
}

- (void)edit:(id)sender
{
	NSLog(@"edit:");
	UIBarButtonItem * editButton=(UIBarButtonItem*)sender;
	// enter edit mode for table
	if(self.tableView.editing)
	{
		self.tableView.editing=NO;
		
		[editButton setStyle:UIBarButtonItemStyleBordered];
		[editButton setTitle:@"Edit"];
		
	}
	else 
	{
		self.tableView.editing=YES;
		
		[editButton setTitle:@"Done"];
		[editButton setStyle:UIBarButtonItemStyleDone];
		
	}
}

- (void)add:(id)sender
{
	NSLog(@"add:");
	
	ProjectFormViewController * projectFormView=[[ProjectFormViewController alloc] initWithNibName:@"ProjectFormView" bundle:nil];
	
	projectFormView.delegate=self;
	
	[projectFormView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

	[projectFormView setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self.splitViewController presentModalViewController:projectFormView animated:YES];
	
	[projectFormView release];
 }

- (void) projectFormViewDone:(Project*)project
{
	// add new project
	[self.projects addObject:project];
	// redraw
	[self.tableView reloadData];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [self.projects count]+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
	if(indexPath.row==0)
	{
		cell.textLabel.text=@"Next On Deck";
	}
	else
	{
		if(indexPath.row==1)
		{
			cell.textLabel.text=@"Uncompleted Tasks";
		}
		else
		{
			if(indexPath.row==2)
			{
				cell.textLabel.text=@"Unassigned Tasks";
				
				cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[unassignedTasks.tasks count]];
				
			}
			else 
			{
				Project  * project=[self.projects objectAtIndex:indexPath.row-3];
			
				cell.textLabel.text = project.name;
				cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[project.tasks count]];
			}
		}
	}

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row>2);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if(indexPath.row>2)
	{
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			[self.projects removeObjectAtIndex:indexPath.row-3];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		}
	}
    //else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   // }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if(indexPath.row==0)
	{
		projectViewController.project = [[[UIApplication  sharedApplication] delegate] nextOnDeckProject];
		projectViewController.aggregateView=YES;
	}
	else 
	{
		if(indexPath.row==1)
		{
			projectViewController.project = [[[UIApplication  sharedApplication] delegate] uncompletedTasksProject];
			projectViewController.aggregateView=YES;
		}
		else 
		{
			if(indexPath.row==2)
			{
				projectViewController.project = unassignedTasks;
				projectViewController.aggregateView=NO;
			}
			else
			{
				projectViewController.project = [self.projects objectAtIndex:indexPath.row-3];
				projectViewController.aggregateView=NO;
			}
		}
	}
	[projectViewController.taskTableView reloadData];
	[projectViewController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [projectViewController release];
	[projects release];
	[unassignedTasks release];
    [super dealloc];
}


@end

