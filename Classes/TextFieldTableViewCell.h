//
//  TextFieldTableViewCell.h
//  NextOnDeck
//
//  Created by Robert Stewart on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldTableViewCell : UITableViewCell {
	UITextField * textField;
	UILabel * nameLabel;
}
@property(nonatomic,retain) UITextField * textField;
@property(nonatomic,retain) UILabel * nameLabel;

@end
