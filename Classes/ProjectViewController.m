    //
//  ProjectViewController.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProjectViewController.h"
#import "TaskViewController.h"
#import "Project.h"
#import "Task.h"
#import "TaskDetailViewController.h"
#import "TaskFormViewController.h"
#import "BlankToolbar.h"
#import "AddTaskViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProjectViewController
@synthesize  popoverController,project,taskTableView,aggregateView;

- (void) viewWillAppear:(BOOL)animated
{
	
	
	
	//self.taskTableView.frame=CGRectInset(self.view.bounds, 10, 10);
	
	//self.taskTableView.layer.cornerRadius=8;
	//self.taskTableView.layer.borderWidth=10;
	//self.taskTableView.layer.shadowRadius=4;
	//self.taskTableView.layer.shadowColor=[UIColor lightGrayColor].CGColor;
	
	
	
	
	
	//[self.taskTableView setNeedsLayout];
	[self.taskTableView reloadData];
	[super viewWillAppear:animated];
}

- (void) sendProjectDataChangedNotification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	if(self.project)
	{
		self.navigationItem.title=self.project.name;
	}
	
	//self.view.backgroundColor=[UIColor grayColor];
	
	//self.view.layer.shadowColor=[UIColor blackColor].CGColor;
	//self.view.layer.shadowOpacity=0.8;
	//self.view.layer.shadowRadius=4;
	//self.view.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
	
	// create a toolbar to have two buttons in the right
	BlankToolbar* tools = [[BlankToolbar alloc] initWithFrame:CGRectMake(0, 0, 250, 44.01)];
	
	tools.backgroundColor=[UIColor clearColor];
	tools.opaque=NO;
	
	// create the array to hold the buttons, which then gets added to the toolbar
	NSMutableArray* buttons = [[NSMutableArray alloc] init];
	
	// create a standard "action" button
	UIBarButtonItem* bi;
	
	// create a spacer to push items to the right
	bi= [[UIBarButtonItem alloc]
		 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[buttons addObject:bi];
	[bi release];
	
	// refresh button
	bi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
	[buttons addObject:bi];
	[bi release];
	
	// create a spacer
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	bi.width=10;
	[buttons addObject:bi];
	[bi release];
	
	// action button
	bi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
	[buttons addObject:bi];
	[bi release];
	
	// create a spacer
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	bi.width=10;
	[buttons addObject:bi];
	[bi release];
	
	// edit button
	bi=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];	
	[buttons addObject:bi];
	[bi release];
	
	// create a spacer
	bi = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	bi.width=10;
	[buttons addObject:bi];
	[bi release];
	
	// add button
	bi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
	[bi setStyle:UIBarButtonItemStyleBordered];
	[buttons addObject:bi];
	[bi release];
	
	// stick the buttons in the toolbar
	[tools setItems:buttons animated:NO];
	
	[buttons release];
	
	// and put the toolbar in the nav bar
	
	UIBarButtonItem * rightView=[[UIBarButtonItem alloc] initWithCustomView:tools];
	
	self.navigationItem.rightBarButtonItem = rightView;
	
	[rightView release];
	
	[tools release];
}

- (void)refresh:(id)sender
{
}

- (void)action:(id)sender
{
}

- (void)edit:(id)sender
{
	UIBarButtonItem * editButton=(UIBarButtonItem*)sender;
	if(self.taskTableView.editing)
	{
		self.taskTableView.editing=NO;
		[editButton setStyle:UIBarButtonItemStyleBordered];
		[editButton setTitle:@"Edit"];
	}
	else 
	{
		self.taskTableView.editing=YES;
		[editButton setTitle:@"Done"];
		[editButton setStyle:UIBarButtonItemStyleDone];
	}
}

- (void)add:(id)sender
{
	AddTaskViewController * taskFormView=[[AddTaskViewController alloc] initWithNibName:@"AddTaskView" bundle:nil];
	
	taskFormView.delegate=self;
	
	if(aggregateView)
	{
		taskFormView.project=[[[UIApplication sharedApplication] delegate] unassignedTasks];
	}
	else
	{
		taskFormView.project=self.project;
	}
	
	[taskFormView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	
	[taskFormView setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self.splitViewController presentModalViewController:taskFormView animated:YES];
	
	[taskFormView release];
}

- (void) taskFormViewDone:(Task*)newTask project:(Project*)newProject editMode:(BOOL)editMode
{
	if(editMode)
	{
		// see if we moved to a different project...
		Project * orig_project=[[[UIApplication sharedApplication] delegate] findProjectForTask:newTask];
		
		if(orig_project)
		{
			if([orig_project isEqual:newProject])
			{
				// no-op
			}
			else 
			{
				[orig_project.tasks removeObject:newTask];
				[newProject.tasks addObject:newTask];
			}
		}
	}
	else 
	{
		// add new task
		[newProject.tasks addObject:newTask];
	}
	
	[self sendProjectDataChangedNotification];

	// redraw
	[self.taskTableView reloadData];
}

- (void) setProject:(Project *)p
{
	if(project!=p)
	{
		[project release];
		project=[p retain];
		self.navigationController.navigationBar.topItem.title=project.name;
	}
	if (popoverController!=nil) {
		[popoverController dismissPopoverAnimated:YES];
	}
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    barButtonItem.title = @"Projects";
	[[self.navigationController.navigationBar.items objectAtIndex:0] setLeftBarButtonItem:barButtonItem animated:YES];
	self.popoverController = pc;
}

- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [[self.navigationController.navigationBar.items objectAtIndex:0] setLeftBarButtonItem:nil animated:YES];
	self.popoverController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [self.project.tasks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
	static NSString *AggCellIdentifier=@"AggCellIdentifier";
	
	NSString * identifier;
	
	if(aggregateView)
	{
		identifier=AggCellIdentifier;
	}
	else 
	{
		identifier=CellIdentifier;
	}

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
	UIButton * toggleButton;
	UILabel * nameLabel;
	UILabel * projectLabel;
	UILabel * dueDateLabel;
	
	if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		toggleButton=[UIButton buttonWithType:UIButtonTypeCustom];
		
		[toggleButton setImage:[UIImage imageNamed:@"Unchecked-Transparent.png"] forState:UIControlStateNormal];
		[toggleButton addTarget:self action:@selector(toggleRow:) forControlEvents:UIControlEventTouchDown];
		toggleButton.tag=1;
		toggleButton.frame=CGRectMake(10, 10, 25, 25);
		
		[cell.contentView addSubview:toggleButton];
		
		if(aggregateView)
		{
			projectLabel=[[UILabel alloc] init];
			projectLabel.font=[UIFont boldSystemFontOfSize:14];
			projectLabel.textColor=[UIColor grayColor];
			projectLabel.tag=4;
			projectLabel.frame=CGRectMake(43, 2, 650, 14);
			
			[cell.contentView addSubview:projectLabel];
			
			nameLabel=[[UILabel alloc] init];
			nameLabel.font=[UIFont boldSystemFontOfSize:20];
			nameLabel.tag=2;
			nameLabel.frame=CGRectMake(43, 16, 650, 28);
			
			[cell.contentView addSubview:nameLabel];
		}
		else 
		{
			nameLabel=[[UILabel alloc] init];
			nameLabel.font=[UIFont boldSystemFontOfSize:20];
			nameLabel.tag=2;
			nameLabel.frame=CGRectMake(43, 8, 650, 28);
			
			[cell.contentView addSubview:nameLabel];
		}
		dueDateLabel=cell.detailTextLabel;
	}
    
	Task * task=[self.project.tasks objectAtIndex:indexPath.row];
	
	toggleButton=(UIButton*)[cell.contentView viewWithTag:1];
	nameLabel=(UILabel*)[cell.contentView viewWithTag:2];
	dueDateLabel=cell.detailTextLabel;//(UILabel*)[cell.contentView viewWithTag:3];
	
	if(aggregateView)
	{
		projectLabel=(UILabel*)[cell.contentView viewWithTag:4];
		
		Project * task_project=[[[UIApplication sharedApplication] delegate] findProjectForTask:task];
		
		if(task_project)
		{
			projectLabel.text =task_project.name;
		}
		else 
		{
			projectLabel.text=@"Inbox";
		}
	}
	
	if(task.completed)
	{
		[toggleButton setImage:[UIImage imageNamed:@"GreenChecked-Transparent.png"] forState:UIControlStateNormal];
		nameLabel.textColor=[UIColor lightGrayColor];
	}
	else 
	{
		[toggleButton setImage:[UIImage imageNamed:@"Unchecked-Transparent.png"] forState:UIControlStateNormal];
		nameLabel.textColor=[UIColor blackColor];
	}
	
	if(!task.completed)
	{
		dueDateLabel.text=[task dueDateString];
		if([task isOverdue])
		{
			dueDateLabel.textColor=[UIColor redColor];
		}
		else 
		{
			dueDateLabel.textColor=[UIColor blueColor];
		}
	}
	
	cell.tag=task;
	
	[nameLabel setText:task.name];
	
    return cell;
}

- (void)toggleRow:(id)sender
{
	Task * task=(Task*)([[sender superview] superview]).tag;
	
	UIButton * button=(UIButton*)sender;
	
	if (!task.completed) 
	{
		[button setImage:[UIImage imageNamed:@"GreenChecked-Transparent.png"] forState:UIControlStateNormal];
		task.completed=YES;
		task.completedOn=[NSDate date];
	}
	else 
	{
		[button setImage:[UIImage imageNamed:@"Unchecked-Transparent.png"] forState:UIControlStateNormal];
		task.completed=NO;
		task.completedOn=nil;
	}
	
	// if in aggregate view then setting row to completed should remove it from the table
	// since we only show uncompleted tasks in the aggregate views
	if(self.aggregateView)
	{
		[self.taskTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	}
	else 
	{
		[self.taskTableView reloadData];
	}

	//	if(task.completed)
//		{
			//[self.taskTableView deleteRowsAtIndexPaths:<#(NSArray *)indexPaths#> withRowAnimation:UITableViewRowAnimationFade];
	
			//[self.taskTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//		}
//	}
	
	[self sendProjectDataChangedNotification];
	
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.aggregateView)
	{
		return NO;
	}
	else
	{
		return YES;
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if(!self.aggregateView)
	{
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			[self.project.tasks removeObjectAtIndex:indexPath.row];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
			[self sendProjectDataChangedNotification];
			
		}
	}
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
	AddTaskViewController * taskViewController=[[AddTaskViewController alloc] initWithNibName:@"AddTaskView" bundle:nil];
	
	taskViewController.editMode=YES;
	
	Task * task=[self.project.tasks objectAtIndex:indexPath.row];
	
	taskViewController.delegate=self;
	
	taskViewController.task=task;
	
	if(aggregateView)
	{
		taskViewController.project=[[[UIApplication sharedApplication] delegate] unassignedTasks];
	}
	else
	{
		taskViewController.project=self.project;
	}
	
	[taskViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	
	[taskViewController setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self.splitViewController presentModalViewController:taskViewController animated:YES];
	
	[taskViewController release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	TaskDetailViewController * taskViewController=[[TaskDetailViewController alloc] initWithNibName:@"TaskDetailView" bundle:nil];
	
	Task * task=[self.project.tasks objectAtIndex:indexPath.row];
	
	taskViewController.task=task;
	
	[self.navigationController pushViewController:taskViewController animated:YES];
	
	[taskViewController release];
}

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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.popoverController = nil;
}

- (void)dealloc {
	[popoverController release];
    [project release];
	[taskTableView release];
	
    [super dealloc];
}

@end
