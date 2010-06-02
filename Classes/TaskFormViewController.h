//
//  TaskFormViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface TaskFormViewController : UIViewController 
{
	Task * task;
	IBOutlet UITextField * nameTextField;
	IBOutlet UITextView * notesTextField;
	id delegate;
}
@property(nonatomic,retain) Task * task;
@property(nonatomic,retain) IBOutlet UITextField * nameTextField;
@property(nonatomic,retain) IBOutlet UITextView * notesTextField;
@property(nonatomic,assign) id delegate;
- (IBAction) cancel;
- (IBAction) done;

@end
