//
//  Task.m
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Task.h"

@implementation Task
@synthesize name,createdOn,completedOn,note,completed,dueDate;//,estimatedTime,priority;

- (BOOL) isCompleted
{
	return [self.completed boolValue];
}

/*- (void) setCompleted:(BOOL)completed
{
	self.completed=[NSNumber numberWithBool:completed];
}*/

- (void) save
{
	[[self managedObjectContext] save];
}

- (void) delete	
{
	[[self managedObjectContext] deleteObject:self];
}

- (BOOL) isOverdue
{
	if(self.dueDate)
	{
		NSTimeInterval sinceNow=[self.dueDate timeIntervalSinceNow];
		if(sinceNow>0) return NO;
		if(sinceNow<0) return YES;
	}
	
	return NO;
}

- (NSString*) completedOnString
{
	if(self.completedOn==nil)
	{
		return nil;
	}
	else 
	{
		NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
		
		[formatter setDateFormat:@"MMM d, yyyy"];
		
		NSString * tmp=[formatter stringFromDate:self.completedOn];
		
		[formatter release];
		
		return [@"Completed " stringByAppendingString:tmp];
	}
}

- (NSString*) dueDateString
{
	if(self.dueDate==nil)
	{
		return nil;
	}
	else 
	{
		NSTimeInterval sinceNow=[self.dueDate timeIntervalSinceNow];
		
		if(sinceNow>0)
		{
			// due date is in the future
			if(sinceNow < 60*60*24)
			{
				// due tommorow
				return @"Due Tommorow";
			}
			else 
			{
				// format for the specified date
				
				NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
				
				[formatter setDateFormat:@"MMM d, yyyy"];
				
				NSString * tmp=[formatter stringFromDate:self.dueDate];
				
				[formatter release];
				
				return tmp;
			}
		}
		else 
		{
			// past due
			if(sinceNow > -60*60*24)
			{
				// due today
				return @"Due Today";
			}
			else 
			{
				int days=floor((-sinceNow)/(60*60*24));
				if(days<2)
				{
					return @"Due Yesterday";
				}
				else 
				{
					return [NSString stringWithFormat:@"%d days overdue",days];
				}
			}
		}
	}
}

@end
