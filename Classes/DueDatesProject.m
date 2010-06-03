//
//  DueDatesProject.m
//  NextOnDeck
//
//  Created by Robert Stewart on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DueDatesProject.h"
#import "Project.h"
#import "Task.h"

@implementation DueDatesProject

- (id) initWithProjects:(NSArray*)projects
{
	if([super init])
	{
		self.projects=projects;
		self.name=@"Scheduled Tasks";
	}
	return self;
}
- (UIImage*) image
{
	return [UIImage imageNamed:@"iCal-icon.png"];
}
- (NSMutableArray*) tasks
{
	if(tasks)
	{
		[tasks release];
	}
	
	tasks=[[NSMutableArray alloc] init];
	
	for(Project * project in self.projects)
	{
		for(Task * task in project.tasks)
		{
			if(task.dueDate)
			{
				[tasks addObject:task];
			}
		}
	}
	
	NSSortDescriptor * descriptor=[[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
	
	// now sort by creation date 
	[tasks sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	
	[descriptor release];
	
	return tasks;
}

@end
