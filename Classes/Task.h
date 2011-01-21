//
//  Task.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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

- (BOOL) isCompleted;

//- (void) setCompleted:(BOOL)completed;

@end
