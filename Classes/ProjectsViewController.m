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
#import "FormViewController.h"

#define kAddProjectFormTag 99

@implementation ProjectsViewController
@synthesize tableView, blankToolbar;

- (void)viewDidLoad 
{
	[super viewDidLoad];
	[self setupView];
}

- (void) setupView
{
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
	
	[tools addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
	
	[tools addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)] autorelease]];
	
	
	
	
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

- (void) formViewDidCancel:(int)tag
{
	// dismiss
	[[self getParentViewController] dismissModalViewControllerAnimated:YES];
}

- (void) formViewDidFinish:(int)tag withValues:(NSArray*)values
{
	if(tag==kAddProjectFormTag)
	{
		NSString * projectName=[values objectAtIndex:0];
		
		// create new project
		if([projectName length]>0)
		{
			Project * newProject=[[[UIApplication sharedApplication] delegate] createNewProject:projectName summary:nil];
		}
		
		// dismiss
		[[self getParentViewController] dismissModalViewControllerAnimated:YES];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"projectDataChanged" object:nil];
		
		[self.tableView reloadData];
	}
}

- (IBAction)refresh:(id)sender
{
	[[[UIApplication sharedApplication] delegate] refresh];
}

- (IBAction)add:(id)sender
{
	FormViewController * projectFormView=[[FormViewController alloc] initWithTitle:@"Add Project" tag:kAddProjectFormTag delegate:self names:[NSArray arrayWithObject:@"Project Name"] andValues:nil];
	
	[[self getParentViewController] presentModalViewController:projectFormView animated:YES];
	
	[projectFormView release];
}

- (UIViewController*) getParentViewController
{
	return [[[UIApplication sharedApplication] delegate] splitViewController];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	[allProjects release];
	allProjects=[[[[UIApplication sharedApplication] delegate] allProjects] retain];
	return 3;
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
			return 1;
		case 1:
			return 1;
		case 2:
			return [allProjects count]+1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //static NSString *CellIdentifier = @"CellIdentifier";
    
    AlphaBadgedTableViewCell *cell =nil;// [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
	if (cell == nil) 
	{
        cell = [[[AlphaBadgedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
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
		[cell.backgroundView setPosition:CustomCellBackgroundViewPositionSingle];
		cell.textLabel.text=@"Inbox";
		cell.badgeString=[NSString stringWithFormat:@"%d",[[[[UIApplication sharedApplication] delegate] unassignedTasks] count]];
	}
	
	if(indexPath.section==1)
	{
		[cell.backgroundView setPosition:CustomCellBackgroundViewPositionSingle];
		cell.textLabel.text=@"Next on deck";
		cell.badgeString=[NSString stringWithFormat:@"%d",[[[[UIApplication sharedApplication] delegate] nextOnDeckTasks] count]];
	}
	
	if(indexPath.section>1)
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
	if(indexPath.section==2)
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
    return (indexPath.section==2);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.section>1)
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
	NSLog(@"didSelectRowAtIndexPath:%@",[indexPath description]);
	
	if(indexPath.section==0)
	{
		 
			// show inbox
			[[[UIApplication sharedApplication] delegate] showInbox];
	}
	if(indexPath.section==1)
	{
			// show next on deck
			[[[UIApplication sharedApplication] delegate] showNextOnDeck];
		
	}
	if(indexPath.section>1)
	{
		if(indexPath.row==[allProjects count])
		{
			[aTableView deselectRowAtIndexPath:indexPath animated:YES];
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

