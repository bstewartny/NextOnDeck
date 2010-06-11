//
//  ProjectCollection.h
//  NextOnDeck
//
//  Created by Robert Stewart on 6/10/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProjectCollection : NSObject {
	NSMutableArray * projectArrays;
}
@property(nonatomic,retain) NSMutableArray * projectArrays;

- (NSArray*) projects;

@end
