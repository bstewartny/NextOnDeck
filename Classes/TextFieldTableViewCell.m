//
//  TextFieldTableViewCell.m
//  NextOnDeck
//
//  Created by Robert Stewart on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TextFieldTableViewCell.h"


@implementation TextFieldTableViewCell
@synthesize nameLabel,textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier name:(NSString*)name maxWidth:(CGFloat)maxWidth
{
	if([super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		UIFont * nameFont=[UIFont boldSystemFontOfSize:14];
		CGSize size=[name sizeWithFont:nameFont];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width + 10, 25)];
		//label.tag           = kLabelTag;
		label.font          = nameFont;
		label.textAlignment = UITextAlignmentRight;
		label.text=name;
		self.nameLabel=label;
		
		[label release];


		CGFloat textFieldWidth= maxWidth-(size.width+10+10+10+10);
		
		UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(size.width+10+10+10, 12, textFieldWidth, 25)];
		tf.clearsOnBeginEditing = NO;
		//[tf setDelegate:self];
		//[tf addTarget:self action:@selector(bottomTextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
		self.textField=tf;
		[tf release];
		
		[self.contentView addSubview:self.nameLabel];
		[self.contentView addSubview:self.textField];
	}
	return self;
}


- (void) dealloc
{
	[nameLabel release];
	[textField release];
	[super dealloc];
}
@end
