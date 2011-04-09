#import "AddTaskViewController_iPhone.h"
#import "Task.h"
#import "Project.h"
#import "DatePickerViewController.h"

@implementation AddTaskViewController_iPhone

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void) pickedDate:(NSDate*)dueDate
{
	NSLog(@"pickedDate: %@",[dueDate description]);
	
	self.pickedDate=dueDate;
	[self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}

- (void) cancelledDatePicker
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	switch (indexPath.section) 
	{
		case 1:
		{
			switch (indexPath.row) 
			{
				case 1:
				{
					// choose due date from date picker control
					DateViewController * dateView=[[DateViewController alloc] init];
					
					dateView.delegate=self;
					
					dateView.date=self.pickedDate;
					
					[self.navigationController pushViewController:dateView animated:YES];
					
					[dateView release];
					
				}
					break;
					
				case 0:
					// choose project from list
					self.projectPicker = [[ProjectPickerViewController alloc] 
										  initWithStyle:UITableViewStylePlain];
					self.projectPicker.delegate = self;
					self.projectPicker.project=self.project;
					
					self.projectPicker.projects=[[[UIApplication sharedApplication] delegate] allProjects];
					
					//[projectPicker setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
					
					//[projectPicker setModalPresentationStyle:UIModalPresentationFormSheet];
					
					//[self presentModalViewController:projectPicker animated:YES];
					[self.navigationController pushViewController:self.projectPicker animated:YES];
			}
		}
			break;
		case 3:
			[super tableView:aTableView didSelectRowAtIndexPath:indexPath];
			break;
	}
}

- (void)projectSelected:(Project *)newProject
{
	self.project=newProject;
	//[self dismissModalViewControllerAnimated:YES];
	[self.tableView reloadData];
}



@end
