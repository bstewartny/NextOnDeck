#import "ProjectsViewController_iPhone.h"
#import "Task.h"
#import "Project.h"
#import <QuartzCore/QuartzCore.h>
#import "BadgedTableViewCell.h"
#import "CustomCellBackgroundView.h"
#import "FormViewController.h"
#define kEditProjectFormTag 101

@implementation ProjectsViewController_iPhone
 
- (UIViewController*) getParentViewController
{
	return self.parentViewController;
}

- (void)setupView 
{
    self.tableView.allowsSelectionDuringEditing=YES;
	
	UIBarButtonItem * editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
	
	self.navigationItem.leftBarButtonItem=editButton;
	
	[editButton release];
	
	//self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)] autorelease];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"projectDataChanged" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section<2) return nil;
	return @"Projects";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	// edit project name
	Project  * project=[allProjects objectAtIndex:indexPath.row];
	
	if(project)
	{
		editingProject=project;
		FormViewController * projectFormView=[[FormViewController alloc] initWithTitle:@"Edit Project" tag:kEditProjectFormTag delegate:self names:[NSArray arrayWithObject:@"Project Name"] andValues:[NSArray arrayWithObject:project.name]];
		
		[[self getParentViewController] presentModalViewController:projectFormView animated:YES];
		
		[projectFormView release];
	}
}

- (void) formViewDidFinish:(int)tag withValues:(NSArray*)values
{
	if(tag==kEditProjectFormTag)
	{
		NSString * projectName=[values objectAtIndex:0];
		if([projectName length]>0)
		{
			if(editingProject)
			{
				editingProject.name=projectName;
				[editingProject save];
				editingProject=nil;
			}
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
		
		[self.tableView reloadData];
	}
	else 
	{
		[super formViewDidFinish:tag withValues:values];
	}
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    BadgedTableViewCell * cell = [[[BadgedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
	
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	cell.badgeColor=[UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000];
	cell.badgeColorHighlighted=[UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000];
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.editingAccessoryType=UITableViewCellAccessoryNone;
	
	if(indexPath.section==0)
	{
		cell.textLabel.text=@"Inbox";
		cell.badgeString=[NSString stringWithFormat:@"%d",[[[[UIApplication sharedApplication] delegate] unassignedTasks] count]];
	}
	
	if(indexPath.section==1)
	{
		cell.textLabel.text=@"Next on deck";
		cell.badgeString=[NSString stringWithFormat:@"%d",[[[[UIApplication sharedApplication] delegate] nextOnDeckTasks] count]];
	}
	
	if(indexPath.section==2)
	{
		if(indexPath.row==[allProjects count])
		{
			// add project row
			cell.textLabel.textColor=[UIColor lightGrayColor];
			cell.textLabel.text=@"Add Project";
			cell.accessoryType=UITableViewCellAccessoryNone;
		}
		else
		{
			cell.editingAccessoryType=UITableViewCellAccessoryDetailDisclosureButton;
			Project  * project=[allProjects objectAtIndex:indexPath.row];
			cell.textLabel.text=project.name;
			cell.badgeString=[NSString stringWithFormat:@"%d",[project countUncompleted]];
		}
	}
	
	return cell;
}

- (void)dealloc 
{
	[tableView release];
    [super dealloc];
}

@end
