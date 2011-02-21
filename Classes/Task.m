#import "Task.h"

@implementation Task
@dynamic name,createdOn,completedOn,note,completed,dueDate,modifiedOn,uid;//,estimatedTime,priority;

- (BOOL) isCompleted
{
	return [self.completed boolValue];
}

- (void) save
{
	NSError * error=nil;
	[[self managedObjectContext] save:&error];
}

- (void) delete	
{
	[[self managedObjectContext] deleteObject:self];
	NSError * error=nil;
	[[self managedObjectContext] save:&error];
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
