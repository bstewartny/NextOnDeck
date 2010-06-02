//
//  Task.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	TaskPriorityLow=0,
	TaskPriorityNormal=1,
	TaskPriorityHigh=2
} TaskPriority;



@class Project;
@interface Task : NSObject <NSCoding>{
	NSString * name;
	NSDate * createdOn;
	NSDate * completedOn;
	BOOL completed;
	NSString * note;
	NSDate * dueDate;
	TaskPriority priority;
	NSTimeInterval estimatedTime;
	 
}
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSDate * createdOn;
@property(nonatomic,retain) NSDate * completedOn;
@property(nonatomic,retain) NSDate * dueDate;
@property(nonatomic) TaskPriority priority;
@property(nonatomic) NSTimeInterval estimatedTime;
@property(nonatomic) BOOL completed;
@property(nonatomic,retain) NSString * note;

@end
