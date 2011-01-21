//
//  Project.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Project.h"
#import "Task.h"

@implementation Project
@synthesize name,tasks,notes,description,createdOn;

- (void) save
{
	[[self managedObjectContext] save];
}

- (void) delete	
{
	[[self managedObjectContext] deleteObject:self];
}
- (void) addNewTask:(NSString*)name note:(NSString*)note dueDate:(NSDate *)dueDate
{
	Task * task=[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[self managedObjectContext]];
	
	task.name=name;
	task.note=note;
	task.dueDate=dueDate;
	task.createdOn=[NSDate date];
	task.completed=[NSNumber numberWithBool:NO];
	task.project=self;
	
	[task save];
	
}
- (int) countUncompleted
{
	int count=0;
	 
	for(Task * t in self.tasks)
	{
		if(!t.completed)
		{
			count++;
		}
	}
	 
	return count;
}


@end
