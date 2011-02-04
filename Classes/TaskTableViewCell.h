#import <UIKit/UIKit.h>

@class BadgeView;

@interface TaskTableViewCell : UITableViewCell 
{
	UILabel * nameLabel;
	UILabel * noteLabel;
	UIButton * checkButton;
	BadgeView * badge;
	NSString *badgeString;
	UIColor *badgeColor;
	UIColor *badgeColorHighlighted;
}
@property(nonatomic,retain) UILabel * nameLabel;
@property(nonatomic,retain) UILabel * noteLabel;
@property(nonatomic,retain) UIButton * checkButton;
@property (readonly, retain) BadgeView *badge;
@property (nonatomic, retain) NSString *badgeString;
@property (nonatomic, retain) UIColor *badgeColor;
@property (nonatomic, retain) UIColor *badgeColorHighlighted;

@end
