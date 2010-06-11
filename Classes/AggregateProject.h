//
//  AggregateProject.h
//  NextOnDeck
//
//  Created by Robert Stewart on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"
@class ProjectCollection;

@interface AggregateProject : Project {
	ProjectCollection * projects;
}
@property(nonatomic,retain) ProjectCollection * projects;

- (id) initWithProjects:(ProjectCollection*)projects;
@end
