#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;
@interface TempProject : NSObject
{
	NSString * uid;
	NSDate * modifiedOn;
	NSString * name;
	NSString * notes;
	NSString * summary;
	NSArray * tasks;
	NSDate * createdOn;
}

@property(nonatomic,retain) NSString * uid;
@property(nonatomic,retain) NSDate * modifiedOn;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * notes;
@property(nonatomic,retain) NSString * summary;
@property(nonatomic,retain) NSArray * tasks;
@property(nonatomic,retain) NSDate * createdOn;



@end


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
