//
//  AggregateProject.m
//  NextOnDeck
//
//  Created by Robert Stewart on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AggregateProject.h"
#import "ProjectCollection.h"

@implementation AggregateProject
@synthesize projects;

- (id) initWithProjects:(ProjectCollection*)projects
{
	if([super init])
	{
		self.projects=projects;
		self.name=@"Next On Deck";
	}
	return self;
}

- (void) dealloc
{
	[projects release];
	[super dealloc];
}
@end
