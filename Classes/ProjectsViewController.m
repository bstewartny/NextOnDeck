#import "ProjectsViewController.h"
#import "ProjectViewController.h"
#import "Task.h"
#import "Project.h"
#import "ProjectFormViewController.h"
#import "NextOnDeckProject.h"
#import <QuartzCore/QuartzCore.h>
#import "BadgedTableViewCell.h"
#import "CustomCellBackgroundView.h"
#import "BlankToolbar.h"

@implementation ProjectsViewController
@synthesize tableView, blankToolbar;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    //self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	blankToolbar.opaque=NO;
	blankToolbar.backgroundColor=[UIColor clearColor];
	
	tableView.opaque=NO;
	tableView.backgroundColor=[UIColor clearColor];
	tableView.backgroundView=nil;
	
	self.view.backgroundColor=[UIColor clearColor];
	
	
	NSMutableArray * tools=[[NSMutableArray alloc] init];
	
	UIBarButtonItem * addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
	[tools addObject:addButton];
	[addButton release];
	
	UIBarButtonItem * spacer=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[tools addObject:spacer];
	[spacer release];
	
	UIBarButtonItem * editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
	[tools addObject:editButton];
	[editButton release];
	
	[blankToolbar setItems:tools];
	[tools release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"projectDataChanged" object:nil];
	//[editButton release];
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
	[[[[UIApplication sharedApplication] delegate] splitViewController] presentModalViewController:projectFormView animated:YES];
	[projectFormView release];
}

- (void) projectFormViewDone
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
	
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
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
			return 2;
		case 1:
			return [[[[UIApplication sharedApplication] delegate] allProjects] count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    BadgedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
	if (cell == nil) 
	{
        cell = [[[BadgedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.backgroundColor=[UIColor clearColor];
	
	CustomCellBackgroundView * gbView=[[[CustomCellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
	
	cell.backgroundView=gbView;
	
	gbView.fillColor=[UIColor blackColor]; 
	gbView.borderColor=[UIColor grayColor];
	
	cell.backgroundView.alpha=0.5;
	
	if(indexPath.section==0)
	{
		if(indexPath.row==0)
		{
			[cell.backgroundView setPosition:CustomCellBackgroundViewPositionTop];
			cell.textLabel.text=@"Inbox";
			cell.badgeString=@"123";
		}
		else 
		{
			[cell.backgroundView setPosition:CustomCellBackgroundViewPositionBottom];
			cell.textLabel.text=@"Next on deck";
		}
	}
	else 
	{
		NSArray * allProjects=[[[UIApplication sharedApplication] delegate] allProjects];
		
		if (indexPath.row==0) 
		{
			[cell.backgroundView setPosition:CustomCellBackgroundViewPositionTop];
		}
		else 
		{
			if(indexPath.row==[allProjects count]-1)
			{
				[cell.backgroundView setPosition:CustomCellBackgroundViewPositionBottom];
			}
			else 
			{
				[cell.backgroundView setPosition:CustomCellBackgroundViewPositionMiddle];
			}
		}

		Project  * project=[allProjects objectAtIndex:indexPath.row];
			
		cell.textLabel.text=project.name;
		cell.badgeString=[NSString stringWithFormat:@"%d",[project countUncompleted]];
	}
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return (indexPath.section>0); 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.section>0)
	{
		if (editingStyle == UITableViewCellEditingStyleDelete) 
		{
			Project  * project=[[[[UIApplication sharedApplication] delegate] allProjects] objectAtIndex:indexPath.row];
			[project delete];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
		}
	}
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	if(indexPath.section==0)
	{
		if(indexPath.row==0)
		{
			// show inbox
		}
		else 
		{
			// show next on deck
		}
	}
	else 
	{
		Project  * project=[[[[UIApplication sharedApplication] delegate] allProjects] objectAtIndex:indexPath.row];
		[self showProject:project];
	}
}

- (void) showProject:(Project*)project
{
	[[[UIApplication sharedApplication] delegate] showProject:project];
}

- (void) dealloc
{	
	[tableView release];
	[blankToolbar release];
	[super dealloc];
}

@end

