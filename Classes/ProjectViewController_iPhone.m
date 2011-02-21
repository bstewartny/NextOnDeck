#import "ProjectViewController_iPhone.h"
#import "Project.h"
#import "Task.h"
#import "TaskDetailViewController.h"
#import "BlankToolbar.h"
#import "AddTaskViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TaskTableViewCell.h"
#import "AddTaskViewController_iPhone.h"
@implementation ProjectViewController_iPhone
@synthesize  project,taskTableView;

- (void) viewWillAppear:(BOOL)animated
{
	[self.taskTableView reloadData];
	[super viewWillAppear:animated];
}

- (void) sendProjectDataChangedNotification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	
	// create the array to hold the buttons, which then gets added to the toolbar
	//NSMutableArray* buttons = [[NSMutableArray alloc] init];
	
	// create a standard "action" button
	UIBarButtonItem* bi;
	
		
	// edit button
	//bi=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];	
	//[buttons addObject:bi];
	//
	//self.navigationItem.rightBarButtonItem=bi;
	//[bi release];
	
	// create a spacer
	//bi = [[UIBarButtonItem alloc]
	//	  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	//bi.width=10;
	//[buttons addObject:bi];
	//[bi release];
	
	// add button
	bi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
	self.navigationItem.rightBarButtonItem=bi;
	//[bi setStyle:UIBarButtonItemStyleBordered];
	
	//[buttons addObject:bi];
	[bi release];
	
	// stick the buttons in the toolbar
	//[topToolbar setItems:buttons animated:NO];
	
	//[buttons release];
}

- (void)edit:(id)sender
{
	UIBarButtonItem * editButton=(UIBarButtonItem*)sender;
	if(self.taskTableView.editing)
	{
		[self.taskTableView setEditing:NO animated:YES];
		[editButton setStyle:UIBarButtonItemStyleBordered];
		[editButton setTitle:@"Edit"];
	}
	else 
	{
		[self.taskTableView setEditing:YES animated:YES];
		[editButton setTitle:@"Done"];
		[editButton setStyle:UIBarButtonItemStyleDone];
	}
}

- (void)add:(id)sender
{
	AddTaskViewController_iPhone * taskFormView=[[AddTaskViewController_iPhone alloc] initWithNibName:@"AddTaskView" bundle:nil];
	
	taskFormView.delegate=self;
	
	taskFormView.project=self.project;
	
	[taskFormView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	
	[taskFormView setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self presentModalViewController:taskFormView animated:YES];
	
	[taskFormView release];
}

- (void) taskFormViewDone
{
	[self sendProjectDataChangedNotification];
	[self.taskTableView reloadData];
}

- (void) setProject:(Project *)p
{
	if(project!=p)
	{
		[project release];
		project=[p retain];
		[tasks release];
		tasks=nil;
	}
	 
}

- (void) loadTasks
{
	[tasks release];
	tasks=[[_target performSelector:_selector withObject:_object] retain];
}
/*
- (void)splitViewController: (MGSplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc 
{
    barButtonItem.title = @"Projects";
	NSLog(@"set lefttoolbar button") ;
	
	[leftToolbar setItems:[NSArray arrayWithObjects:barButtonItem,[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],nil]];
	
	//[[self.navigationController.navigationBar.items objectAtIndex:0] setLeftBarButtonItem:barButtonItem animated:YES];
	self.popoverController = pc;
}

- (void)splitViewController: (MGSplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem 
{
    //[[self.navigationController.navigationBar.items objectAtIndex:0] setLeftBarButtonItem:nil animated:YES];
	NSLog(@"remove lefttoolbar button") ;
	
	[leftToolbar setItems:nil];
	
	self.popoverController = nil;
}

*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return NO;
}
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
    [self loadTasks];	
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [tasks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"TaskTableViewCellIdentifier";
	
    TaskTableViewCell *cell = nil;//(TaskTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) 
	{
        cell = [[[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		[cell.checkButton addTarget:self action:@selector(toggleRow:) forControlEvents:UIControlEventTouchDown];
	}
    
	Task * task=[tasks objectAtIndex:indexPath.row];
	
	cell.noteLabel.text=task.note;
	cell.nameLabel.text=task.name;
	
	if([task isCompleted])
	{
		[cell.checkButton setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
		
		cell.nameLabel.textColor=[UIColor lightGrayColor];
		
		cell.badgeString=[task completedOnString];
		
		cell.badgeColor=[UIColor greenColor];
	}
	else 
	{
		[cell.checkButton setImage:[UIImage imageNamed:@"Unchecked-Transparent.png"] forState:UIControlStateNormal];
		
		cell.nameLabel.textColor=[UIColor blackColor];
		
		cell.badgeString=[task dueDateString];
		
		if([task isOverdue])
		{
			cell.badgeColor=[UIColor redColor];
		}
		else 
		{
			cell.badgeColor=[UIColor blueColor];
		}
	}
	
	cell.tag=task;
	
    return cell;
}

- (void)toggleRow:(id)sender
{
	Task * task=(Task*)([[sender superview] superview]).tag;
	
	UIButton * button=(UIButton*)sender;
	
	if (![task isCompleted]) 
	{
		[button setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
		task.completed=[NSNumber numberWithBool:YES];
		task.completedOn=[NSDate date];
	}
	else 
	{
		[button setImage:[UIImage imageNamed:@"Unchecked-Transparent.png"] forState:UIControlStateNormal];
		task.completed=[NSNumber numberWithBool:NO];
		task.completedOn=nil;
	}
	[task save];
	
	[self.taskTableView reloadData];
	
    [self sendProjectDataChangedNotification];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		Task * task=[tasks objectAtIndex:indexPath.row];
		[task delete];
		[self loadTasks];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[self sendProjectDataChangedNotification];
	}
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	AddTaskViewController * taskViewController=[[AddTaskViewController alloc] initWithNibName:@"AddTaskView" bundle:nil];
	
	taskViewController.editMode=YES;
	
	Task * task=[tasks objectAtIndex:indexPath.row];
	
	taskViewController.delegate=self;
	
	taskViewController.task=task;
	
	taskViewController.project=task.project;
	
	[taskViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	
	[taskViewController setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self presentModalViewController:taskViewController animated:YES];
	
	[taskViewController release];
}

/*
 - (BOOL) tableView:(UITableView*)tableView
 canMoveRowAtIndexPath:(NSIndexPath*)indexPath
 {
 if(self.aggregateView)
 {
 return NO;
 }
 else
 {
 return YES;
 }
 }
 
 - (void)tableView:(UITableView*)tableView 
 moveRowAtIndexPath:(NSIndexPath*)fromIndexPath
 toIndexPath:(NSIndexPath*)toIndexPath
 {
 NSUInteger fromRow=[fromIndexPath row];
 NSUInteger toRow=[toIndexPath row];
 
 Task * task1=[[self.project.tasks objectAtIndex:fromRow] retain];
 
 [self.project.tasks removeObjectAtIndex:fromRow];
 [self.project.tasks insertObject:task1 atIndex:toRow];
 
 [task1 release];
 }
 */

- (void) setTaskSelector:(SEL)selector withObject:(id)object withTarget:(id)target
{
	_selector=selector;
	_object=object;
	_target=target;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return self.title;
}


- (void)dealloc {
	[tasks release];
	 
    [project release];
	[taskTableView release];
	 
    [super dealloc];
}

@end
