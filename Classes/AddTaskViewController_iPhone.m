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
	self.pickedDate=dueDate;
	[self dismissModalViewControllerAnimated:YES];
	[self.tableView reloadData];
}

- (void) cancelledDatePicker
{
	[self dismissModalViewControllerAnimated:YES];
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
					
					[dateView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
					
					[dateView setModalPresentationStyle:UIModalPresentationFormSheet];
					
					[self presentModalViewController:dateView animated:YES];
					
					[dateView release];
					
				}
					break;
					
				case 0:
					// choose project from list
					self.projectPicker = [[ProjectPickerViewController alloc] 
										  initWithStyle:UITableViewStylePlain];
					self.projectPicker.delegate = self;
					
					self.projectPicker.projects=[[[UIApplication sharedApplication] delegate] allProjects];
					
					[projectPicker setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
					
					[projectPicker setModalPresentationStyle:UIModalPresentationFormSheet];
					
					[self presentModalViewController:projectPicker animated:YES];
			}
		}
	}
}

- (void)projectSelected:(Project *)newProject
{
	self.project=newProject;
	[self dismissModalViewControllerAnimated:YES];
	[self.tableView reloadData];
}



@end
