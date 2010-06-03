//
//  Project.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Project : NSObject <NSCoding>{
	NSString * name;
	NSMutableArray * tasks;
}
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSMutableArray * tasks;


- (int) countUncompleted;
- (UIImage*) image;

@end
