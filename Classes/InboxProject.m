//
//  InboxProjecgt.m
//  NextOnDeck
//
//  Created by Robert Stewart on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InboxProject.h"


@implementation InboxProject

- (id) init
{
	if([super init])
	{
		self.name=@"Inbox";
	}
	return self;
}

- (UIImage*) image
{
	return [UIImage imageNamed:@"All-mail-icon.png"];
}
@end
