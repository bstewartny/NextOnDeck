//
//  ChooseProjectViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;

@protocol ProjectPickerDelegate
- (void)projectSelected:(Project *)project;
@end



@interface ProjectPickerViewController : UITableViewController {
	NSArray * projects;
	id<ProjectPickerDelegate> delegate;
}
@property(nonatomic,retain) NSArray * projects;
@property(nonatomic,assign) id<ProjectPickerDelegate> delegate;


@end
