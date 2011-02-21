#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;
@interface Project : NSManagedObject{
}
@property(nonatomic,retain) NSString * uid;
@property(nonatomic,retain) NSDate * modifiedOn;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * notes;
@property(nonatomic,retain) NSString * summary;
@property(nonatomic,retain) NSSet * tasks;
@property(nonatomic,retain) NSDate * createdOn;
 

- (int) countUncompleted;
- (NSArray*) orderedTasks;
- (Task*) nextOnDeck;
@end
