//
//  UncompletedTasksProject.m
//  NextOnDeck
//
//  Created by Robert Stewart on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UncompletedTasksProject.h"
#import "Task.h"

@implementation UncompletedTasksProject

- (id) initWithProjects:(NSArray*)projects
{
	if([super init])
	{
		self.projects=projects;
		self.name=@"Uncompleted Tasks";
	}
	return self;
}
- (NSMutableArray*) tasks
{
	NSLog(@"getTasks");
	
	if(tasks)
	{
		[tasks release];
	}
	
	tasks=[[NSMutableArray alloc] init];
	
	for(Project * project in self.projects)
	{
		for(Task * task in project.tasks)
		{
			if(!task.completed)
			{
				[tasks addObject:task];
			}
		}
	}
	
	NSSortDescriptor * descriptor=[[NSSortDescriptor alloc] initWithKey:@"createdOn" ascending:YES];
	
	// now sort by creation date 
	[tasks sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	
	[descriptor release];
	
	return tasks;
}

@end
