//
//  Task.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Task.h"

@implementation Task
@synthesize name,createdOn,completedOn,note,completed,dueDate,estimatedTime,priority;

- (id) init
{
	if([super init])
	{
		self.createdOn=[NSDate date];
		self.priority=TaskPriorityNormal;
		return self;
	}
	return nil;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:createdOn forKey:@"createdOn"];
	[encoder encodeObject:completedOn forKey:@"completedOn"];
	[encoder encodeObject:note forKey:@"note"];
	[encoder encodeBool:completed forKey:@"completed"];
	[encoder encodeObject:dueDate forKey:@"dueDate"];
	[encoder encodeInt:priority forKey:@"priority"];
	[encoder encodeDouble:estimatedTime forKey:@"estimatedTime"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.name=[decoder decodeObjectForKey:@"name"];
		self.createdOn=[decoder decodeObjectForKey:@"createdOn"];
		self.completedOn=[decoder decodeObjectForKey:@"completedOn"];
		self.note=[decoder decodeObjectForKey:@"note"];
		self.completed=[decoder decodeBoolForKey:@"completed"];
		self.dueDate=[decoder decodeObjectForKey:@"dueDate"];
		self.priority=[decoder decodeIntForKey:@"priority"];
		self.estimatedTime=[decoder decodeDoubleForKey:@"estimatedTime"];
	}
	return self;
}
 
- (void) dealloc
{
	[name release];
	[createdOn release];
	[completedOn release];
	[note release];
	[dueDate release];
	[super dealloc];
}

@end
