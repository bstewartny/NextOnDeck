#import "Project.h"
#import "Task.h"

@implementation Project
@dynamic name,tasks,notes,summary,createdOn;

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

- (void) addNewTask:(NSString*)name note:(NSString*)note dueDate:(NSDate *)dueDate
{
	Task * task=[NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[self managedObjectContext]];
	
	task.name=name;
	task.note=note;
	task.dueDate=dueDate;
	task.createdOn=[NSDate date];
	task.completed=[NSNumber numberWithBool:NO];
	task.project=self;
	
	[task save];	
}

- (Task*) nextOnDeck
{
	for(Task * task in [self orderedTasks])
	{
		if(![task isDeleted])
		{
			if(![task isCompleted])
			{
				return task;
			}
		}
	}
	return nil;
}

- (NSArray*) orderedTasks
{
	NSMutableArray * tmp=[[NSMutableArray alloc] init];
	
	for(Task * t in self.tasks)
	{
		if(![t isDeleted])
		{
			[tmp addObject:t];
		}
	}
	
	[tmp sortUsingSelector:@selector(createdOn)];
	
	return [tmp autorelease];
}

- (int) countUncompleted
{
	int count=0;
	 
	for(Task * t in self.tasks)
	{
		if(![t isDeleted])
		{
			if(![t isCompleted])
			{
				count++;
			}
		}
	}
	 
	return count;
}

@end
