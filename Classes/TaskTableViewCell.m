#import "TaskTableViewCell.h"
#import "BadgeView.h"

@implementation TaskTableViewCell
@synthesize nameLabel,badge,noteLabel,checkButton,badgeString, badgeColor, badgeColorHighlighted;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
	{
		checkButton=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
		
		checkButton.frame=CGRectMake(0, 0, 50, 55);
		
		checkButton.contentMode=UIViewContentModeCenter;
		
		[self.contentView addSubview:checkButton];
		
		nameLabel=[[UILabel alloc] init];
		nameLabel.font=[UIFont boldSystemFontOfSize:20];
		nameLabel.frame=CGRectMake(50, 8, 650, 22);
		nameLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
		
		[self.contentView addSubview:nameLabel];
		
		noteLabel=[[UILabel alloc] init];
		noteLabel.font=[UIFont systemFontOfSize:14];
		noteLabel.textColor=[UIColor grayColor];
		noteLabel.frame=CGRectMake(50, 30, 650, 16);
		noteLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
		
		[self.contentView addSubview:noteLabel];

		badge = [[BadgeView alloc] initWithFrame:CGRectZero];
		badge.parent = self;
		
		[self.contentView addSubview:self.badge];
	}
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	if(self.badgeString)
	{
		//force badges to hide on edit.
		//if(self.editing)
		//	[self.badge setHidden:YES];
		//else
		//	[self.badge setHidden:NO];
		
		CGSize badgeSize = [self.badgeString sizeWithFont:[UIFont boldSystemFontOfSize: 14]];
		
		CGRect badgeframe;
		
		badgeframe = CGRectMake(self.contentView.frame.size.width - (badgeSize.width+16) - 10, round((self.contentView.frame.size.height - 18) / 2), badgeSize.width+16, 18);
	
		[self.badge setFrame:badgeframe];
		[badge setBadgeString:self.badgeString];
		[badge setParent:self];
		
		if ((self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width) >= badgeframe.origin.x)
		{
			CGFloat badgeWidth = self.nameLabel.frame.size.width - badgeframe.size.width - 10.0;
			
			self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, badgeWidth, self.nameLabel.frame.size.height);
		}
		
		if ((self.noteLabel.frame.origin.x + self.noteLabel.frame.size.width) >= badgeframe.origin.x)
		{
			CGFloat badgeWidth = self.noteLabel.frame.size.width - badgeframe.size.width - 10.0;
			
			self.noteLabel.frame = CGRectMake(self.noteLabel.frame.origin.x, self.noteLabel.frame.origin.y, badgeWidth, self.noteLabel.frame.size.height);
		}
		//set badge highlighted colours or use defaults
		if(self.badgeColorHighlighted)
			badge.badgeColorHighlighted = self.badgeColorHighlighted;
		else 
			badge.badgeColorHighlighted = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
		
		//set badge colours or impose defaults
		if(self.badgeColor)
			badge.badgeColor = self.badgeColor;
		else
			badge.badgeColor = [UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000];
	}
	else
	{
		[self.badge setHidden:YES];
	}
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[badge setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	if(selected)
	{
		self.backgroundView.alpha=0.5;
	}
	else 
	{
		self.backgroundView.alpha=0.3;
	}
	[badge setNeedsDisplay];
}

/*- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	if (editing) {
		badge.hidden = YES;
		[badge setNeedsDisplay];
		[self setNeedsDisplay];
	}
	else 
	{
		badge.hidden = NO;
		[badge setNeedsDisplay];
		[self setNeedsDisplay];
	}
}*/

- (void)dealloc 
{
	[badge release];
	[badgeColor release];
	[badgeString release];
	[badgeColorHighlighted release];
	[nameLabel release];
	[noteLabel release];
	[checkButton release];
    [super dealloc];
}


@end
