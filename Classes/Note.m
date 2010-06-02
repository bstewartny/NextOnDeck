//
//  Note.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Note.h"


@implementation Note
@synthesize text;

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:text forKey:@"text"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if(self==[super init])
	{
		self.text=[decoder decodeObjectForKey:@"text"];
	}
	return self;
}

- (void) dealloc
{
	[text release];
	[super dealloc];
}
@end
