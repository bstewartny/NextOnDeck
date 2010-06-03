//
//  SomedayMaybeProject.m
//  NextOnDeck
//
//  Created by Robert Stewart on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SomedayMaybeProject.h"


@implementation SomedayMaybeProject

- (id) init
{
	if([super init])
	{
		self.name=@"Someday/Maybe";
	}
	return self;
}

- (UIImage*) image
{
	return [UIImage imageNamed:@"money-bag-icon.png"];
}
@end
