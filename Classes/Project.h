//
//  Project.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Project : NSManagedObject{
}

@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * notes;
@property(nonatomic,retain) NSString * description;
@property(nonatomic,retain) NSSet * tasks;
@property(nonatomic,retain) NSDate * createdOn;

- (int) countUncompleted;

@end
