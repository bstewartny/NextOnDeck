//
//  ProjectFormViewController.h
//  NextOnDeck
//
//  Created by Robert Stewart on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Project;

@interface ProjectFormViewController : UIViewController {
	IBOutlet UITextField * textField;
	Project * project;
	id delegate;
}
@property(nonatomic,retain) IBOutlet UITextField * textField;
@property(nonatomic,retain) Project * project;
@property(nonatomic,assign) id delegate;

- (IBAction) cancel;
- (IBAction) done;

@end
