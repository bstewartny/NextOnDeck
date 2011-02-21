#import "ProjectsViewController_iPhone.h"
#import "Task.h"
#import "Project.h"
#import <QuartzCore/QuartzCore.h>
#import "BadgedTableViewCell.h"
#import "CustomCellBackgroundView.h"

@implementation ProjectsViewController_iPhone
 
- (void)setupView 
{
    NSLog(@"ProjectsViewController_iPhone setupView");
	 
	self.tableView.allowsSelectionDuringEditing=YES;
	
	UIBarButtonItem * editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
	
	self.navigationItem.leftBarButtonItem=editButton;
	
	[editButton release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"projectDataChanged" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(section==0) return nil;

	UIView * v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
	v.backgroundColor=[UIColor clearColor];
	
	UILabel * label=[[UILabel alloc] init];
	
	label.textColor=[UIColor blackColor];
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
		
	if(indexPath.section==0)
	{
		if(indexPath.row==0)
		{
			[cell.backgroundView setPosition:CustomCellBackgroundViewPositionTop];
			cell.textLabel.text=@"Inbox";
			cell.badgeString=[NSString stringWithFormat:@"%d",[[[[UIApplication sharedApplication] delegate] unassignedTasks] count]];
		}
		else 
		{
			[cell.backgroundView setPosition:CustomCellBackgroundViewPositionBottom];
			cell.textLabel.text=@"Next on deck";
			cell.badgeString=[NSString stringWithFormat:@"%d",[[[[UIApplication sharedApplication] delegate] nextOnDeckTasks] count]];
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


- (void)dealloc {
	[tableView release];
    [super dealloc];
}


@end
