//
//  SettingCell.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-21.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "SettingCell.h"



@interface SettingCell()
{
    UILabel *_titleLabel;
    UILabel *_descriptionLabel;
    
    UIImageView *_arrowImageView;
}

@end

@implementation SettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.92f green:0.33f blue:0.10f alpha:1.0f];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-200, self.frame.size.height)];
        //_titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kCellTitleColor;
        [self.contentView addSubview:_titleLabel];
        
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, self.frame.size.width-250, self.frame.size.height)];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textAlignment = NSTextAlignmentRight;
        _descriptionLabel.textColor = kCellTitleColor;
        [self.contentView addSubview:_descriptionLabel];
        
//        UIImage *arrowImage = [UIImage imageNamed:@"icon_setting_arrow"];
//        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-10, (self.frame.size.height-15)/2.0f, 8, 15)];
//        _arrowImageView.image = arrowImage;
//        _arrowImageView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_arrowImageView];
        
        
    }
    return self;
}

- (void)updateData:(NSDictionary*)dic
{
//    _iconImageView.image = [UIImage imageNamed:[dic valueForKey:kIconKey]];
    _titleLabel.text = [dic valueForKey:kTitleKey];
    NSString *description = [dic valueForKey:kDescriptionKey];
    if ([description length] == 0)
    {
//        self.accessoryType = UITableViewCellAccessoryDetailButton;
        _arrowImageView.hidden = NO;
        _descriptionLabel.hidden = YES;
    }
    else
    {
        _arrowImageView.hidden = YES;
        _descriptionLabel.hidden = NO;
        _descriptionLabel.text = description;
    }
}

- (void)updateDescription:(NSString*)description
{
    _arrowImageView.hidden = YES;
    _descriptionLabel.hidden = NO;
    _descriptionLabel.text = description;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
