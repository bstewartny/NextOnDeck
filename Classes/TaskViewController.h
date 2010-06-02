//
//  TaskViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Task;

@interface TaskViewController : UIViewController {
	Task * task;
	IBOutlet UITextView * notesTextView;
	IBOutlet UILabel * createdOnLabel;
	IBOutlet UILabel * completedOnLabel;
	IBOutlet UILabel * nameLabel;
	
}
@property(nonatomic,retain) Task * task;
@property(nonatomic,retain) IBOutlet UITextView * notesTextView;
@property(nonatomic,retain) IBOutlet UILabel * createdOnLabel;
@property(nonatomic,retain) IBOutlet UILabel * completedOnLabel;
@property(nonatomic,retain) IBOutlet UILabel * nameLabel;

@end
