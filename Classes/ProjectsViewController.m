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

@synthesize projectViewController,userProjects,builtinProjects;

- (void)viewDidLoad {
    [super viewDidLoad];
	//self.tableView.
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
	[self.navigationController.navigationBar.topItem setRightBarButtonItem:addButton animated:NO];
	[addButton release];
	UIBarButtonItem * editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
	[self.navigationController.navigationBar.topItem setLeftBarButtonItem:editButton animated:NO];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"projectDataChanged" object:nil];
	[editButton release];
}

- (void)handleNotification:(NSNotification*)notification
{
	[self.tableView reloadData];
}

- (void)edit:(id)sender
{
	UIBarButtonItem * editButton=(UIBarButtonItem*)sender;
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
	ProjectFormViewController * projectFormView=[[ProjectFormViewController alloc] initWithNibName:@"ProjectFormView" bundle:nil];
	projectFormView.delegate=self;
	[projectFormView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	[projectFormView setModalPresentationStyle:UIModalPresentationFormSheet];
	[self.splitViewController presentModalViewController:projectFormView animated:YES];
	[projectFormView release];
}

- (void) projectFormViewDone:(Project*)project
{
	[self.userProjects addObject:project];
	// show new project in detail view
	
	
	[self.tableView reloadData];
	
	//[self showProject:project];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	//[self.tableView setBackgroundView:nil];
   // self.tableView.backgroundColor=[UIColor blackColor];
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch(section)
	{
		case 0:
			return nil;
		case 1:
			return @"Projects";
	}
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	switch(section)
	{
		case 0:
			return [self.builtinProjects count];
		case 1:
			return [self.userProjects count];
	}
}

- (Project*) getProjectForIndexPath:(NSIndexPath*)indexPath{
	switch(indexPath.section)
	{
		case 0:
			return [self.builtinProjects objectAtIndex:indexPath.row];
		case 1:
			return [self.userProjects objectAtIndex:indexPath.row];
		default:
			return nil;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	Project  * project=[self getProjectForIndexPath:indexPath];
			
	cell.textLabel.text=project.name;
	cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",[project countUncompleted]];
		 
	cell.imageView.image=[project image];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section>0); 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section>0){
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			[self.userProjects removeObjectAtIndex:indexPath.row];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
		}
	}
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	Project  * project=[self getProjectForIndexPath:indexPath];
	[self showProject:project];
}

- (void) showProject:(Project*)project
{
	projectViewController.project = project;
	projectViewController.aggregateView=[project isKindOfClass:[AggregateProject class]];
	[projectViewController.taskTableView reloadData];
	[projectViewController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [projectViewController release];
	[userProjects release];
	[builtinProjects release];
	[super dealloc];
}


@end

