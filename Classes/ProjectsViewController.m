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
    
	self.contentSizeForViewInPopover = CGSizeMake(340.0, 600.0);
	self.tableView.allowsSelectionDuringEditing=YES;
	
	blankToolbar.opaque=NO;
	blankToolbar.backgroundColor=[UIColor clearColor];
	
	tableView.opaque=NO;
	tableView.backgroundColor=[UIColor clearColor];
	tableView.backgroundView=nil;
	
	self.view.backgroundColor=[UIColor clearColor];
	
	NSMutableArray * tools=[[NSMutableArray alloc] init];
	
	UIBarButtonItem * editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
	[tools addObject:editButton];
	[editButton release];
	
	[blankToolbar setItems:tools];
	[tools release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"projectDataChanged" object:nil];
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
		[self.tableView setEditing:NO animated:YES];
		[editButton setStyle:UIBarButtonItemStyleBordered];
		[editButton setTitle:@"Edit"];
	}
	else 
	{
		[self.tableView setEditing:YES animated:YES];
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
	[allProjects release];
	allProjects=[[[[UIApplication sharedApplication] delegate] allProjects] retain];
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(section==0) return nil;
	
	UIView * v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
	v.backgroundColor=[UIColor clearColor];
	
	UILabel * label=[[UILabel alloc] init];
	
	label.textColor=[UIColor whiteColor];
	label.text=@"Projects";
	label.backgroundColor=[UIColor clearColor];
	
	[label sizeToFit];
	
	CGRect f=label.frame;
	f.origin.x=15;
	f.origin.y=5;
	label.frame=f;
	
	[v addSubview:label];
	
	[label release];
	
	return [v autorelease];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	switch(section)
	{
		case 0:
			return 2;
		case 1:
			return [allProjects count]+1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    BadgedTableViewCell *cell =nil;// [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
	if (cell == nil) 
	{
        cell = [[[BadgedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.backgroundColor=[UIColor clearColor];
	
	CustomCellBackgroundView * gbView=[[[CustomCellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
	
	cell.backgroundView=gbView;
	
	gbView.fillColor=[UIColor blackColor]; 
	gbView.borderColor=[UIColor grayColor];
	
	cell.backgroundView.alpha=0.3;
	
	cell.textLabel.textColor=[UIColor whiteColor];
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
		if(indexPath.row==[allProjects count])
		{
			// add project row
			if([allProjects count]==0)
			{
				[cell.backgroundView setPosition:CustomCellBackgroundViewPositionSingle];
			}
			else 
			{
				[cell.backgroundView setPosition:CustomCellBackgroundViewPositionBottom];
			}
			cell.textLabel.textColor=[UIColor lightGrayColor];
			cell.textLabel.text=@"Add Project";
		}
		else
		{
			if (indexPath.row==0) 
			{
				[cell.backgroundView setPosition:CustomCellBackgroundViewPositionTop];
			}
			else 
			{
				[cell.backgroundView setPosition:CustomCellBackgroundViewPositionMiddle];
			}
			
			Project  * project=[allProjects objectAtIndex:indexPath.row];
	
			cell.textLabel.text=project.name;
			cell.badgeString=[NSString stringWithFormat:@"%d",[project countUncompleted]];
		}
	}
	
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section==1)
	{
		if (indexPath.row ==[allProjects count]) 
		{
			return UITableViewCellEditingStyleInsert;
		}
		else 
		{
			return UITableViewCellEditingStyleDelete;
		}
	}
	else 
	{
		return UITableViewCellEditingStyleNone;
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return (indexPath.section==1);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.section>0)
	{
		if (editingStyle == UITableViewCellEditingStyleDelete) 
		{
			Project  * project=[allProjects objectAtIndex:indexPath.row];
			[project delete];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
		}
		if(editingStyle==UITableViewCellEditingStyleInsert)
		{
			[self add:nil];
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
			[[[UIApplication sharedApplication] delegate] showInbox];
		}
		else 
		{
			// show next on deck
			[[[UIApplication sharedApplication] delegate] showNextOnDeck];
		}
	}
	else 
	{
		if(indexPath.row==[allProjects count])
		{
			// add new project
			[self add:nil];
		}
		else 
		{
			Project  * project=[allProjects objectAtIndex:indexPath.row];
			[self showProject:project];
		}
	}
}

- (void) showProject:(Project*)project
{
	[[[UIApplication sharedApplication] delegate] showProject:project];
}

- (void) dealloc
{	
	[allProjects release];
	[tableView release];
	[blankToolbar release];
	[super dealloc];
}

@end

