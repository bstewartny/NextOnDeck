//
//  AggregateProject.h
//  NextOnDeck
//
//  Created by Robert Stewart on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface AggregateProject : Project {
	NSArray * projects;
}
@property(nonatomic,retain) NSArray * projects;

- (id) initWithProjects:(NSArray*)projects;
@end
