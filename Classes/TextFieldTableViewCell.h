#import <UIKit/UIKit.h>

@interface TextFieldTableViewCell : UITableViewCell {
	UITextField * textField;
	UILabel * nameLabel;
}
@property(nonatomic,retain) UITextField * textField;
@property(nonatomic,retain) UILabel * nameLabel;

@end
