//
//  Project.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Project.h"

@implementation Project
@synthesize name,tasks;

- (id) init
{
	if ([super init]) 
	{
		NSMutableArray * tmp=[[NSMutableArray alloc] init];
		self.tasks=tmp;
		[tmp release];
		return self;
	}
	return nil;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:name forKey:@"name"];
	[encoder encodeObject:tasks forKey:@"tasks"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.name=[decoder decodeObjectForKey:@"name"];
		self.tasks=[decoder decodeObjectForKey:@"tasks"];
	}
	return self;
}

- (void) dealloc
{
	[name release];
	[tasks release];
	[super dealloc];
}

@end
