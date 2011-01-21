//
//  NextOnDeckProject.m
//  NextOnDeck
//
//  Created by Robert Stewart on 5/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NextOnDeckProject.h"
#import "Task.h"
#import "ProjectCollection.h"

@implementation NextOnDeckProject

- (id) initWithProjects:(ProjectCollection*)projects
{
	if([super init])
	{
		self.projects=projects;
		self.name=@"Next On Deck";
		self.description=@"These tasks should be performed next.";
	}
	return self;
}
- (UIImage*) image
{
	return [UIImage imageNamed:@"Baseball-icon.png"];
}
- (NSMutableArray*) tasks
{
	NSLog(@"getTasks");
	// get next task for each project...
	// show next uncompleted task for each project
	if(tasks)
	{
		[tasks release];
	}
	
	tasks=[[NSMutableArray alloc] init];
	
	for(Project * project in self.projects.projects)
	{
		for(Task * task in project.tasks)
		{
			if(!task.completed)
			{
				[tasks addObject:task];
				break;
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
