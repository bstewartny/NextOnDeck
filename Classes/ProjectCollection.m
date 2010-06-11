//
//  ProjectCollection.m
//  NextOnDeck
//
//  Created by Robert Stewart on 6/10/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "ProjectCollection.h"
#import "Project.h"

@implementation ProjectCollection
@synthesize projectArrays;

- (id) init
{
	if([super init])
	{
		projectArrays=[[NSMutableArray alloc] init];
	}
	return self;
}

- (NSArray*) projects
{
	NSMutableArray * tmp=[[[NSMutableArray alloc] init] autorelease];
	
	for(NSArray * projects in projectArrays)
	{
		for(Project * project in projects)
		{
			[tmp addObject:project];
		}
	}

	return tmp;
}

- (void) dealloc
 {
	 [projectArrays release];
	 [super dealloc];
 }
@end
