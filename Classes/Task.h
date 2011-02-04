#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;
@interface Task : NSManagedObject{
}
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
