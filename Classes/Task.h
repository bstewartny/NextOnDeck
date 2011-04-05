#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Project;
@interface TempTask : NSObject
{
	NSString * uid;
	NSDate * modifiedOn;
	NSString * name;
	NSDate * createdOn;
	NSDate * completedOn;
	NSDate * dueDate;
	NSNumber * completed;
	NSString * note;
	Project * project;
	
}

@property(nonatomic,retain) NSString * uid;
@property(nonatomic,retain) NSDate * modifiedOn;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSDate * createdOn;
@property(nonatomic,retain) NSDate * completedOn;
@property(nonatomic,retain) NSDate * dueDate;
@property(nonatomic,retain) NSNumber * completed;
@property(nonatomic,retain) NSString * note;
@property(nonatomic,retain) Project * project;
@end


@class Project;
@interface Task : NSManagedObject{
}
@property(nonatomic,retain) NSString * uid;
@property(nonatomic,retain) NSDate * modifiedOn;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSDate * createdOn;
@property(nonatomic,retain) NSDate * completedOn;
@property(nonatomic,retain) NSDate * dueDate;
@property(nonatomic,retain) Project * project;
@property(nonatomic,retain) NSNumber * completed;
@property(nonatomic,retain) NSString * note;

- (BOOL) isOverdue;

- (NSString*) dueDateString;
- (NSString*) completedOnString;

- (BOOL) isCompleted;

@end
