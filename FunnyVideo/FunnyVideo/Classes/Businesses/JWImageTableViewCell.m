//
//  JWImageTableViewCell.m
//  TenTu
//
//  Created by JatWaston on 14-11-16.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWImageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Colours.h"

@interface JWImageTableViewCell()
{
    UIImageView *_titleImageView;
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UILabel *_title;
    UIButton *_likeBtn;
    UIButton *_unlikeBtn;
    UIButton *_shareBtn;
}

@end

@implementation JWImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, 140)];
        view.layer.borderWidth = 0.3f;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 310, 100)];
        _imageView.backgroundColor = [UIColor colorWithRed:212/255.0f green:212/255.0f blue:212/255.0f alpha:1.0f];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_imageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 111, 320, 0.5f)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
        
        UIImage *like_unpress = [UIImage imageNamed:@"icon_like_unpressed"];
        UIImage *like_press = [UIImage imageNamed:@"icon_like_pressed"];
        UIImage *like_disabled = [UIImage imageNamed:@"icon_like_disabled"];
        
        UIImage *unlike_unpress = [UIImage imageNamed:@"icon_unlike_unpressed"];
        UIImage *unlike_press = [UIImage imageNamed:@"icon_unlike_pressed"];
        UIImage *unlike_disabled = [UIImage imageNamed:@"icon_unlike_disabled"];
        
        UIImage *shareImage = [UIImage imageNamed:@"icon_more"];
        
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //likeBtn.backgroundColor = [UIColor skyBlueColor];
        likeBtn.frame = CGRectMake(10, 113, 80, 30);
        likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [likeBtn setImage:like_unpress forState:UIControlStateNormal];
        [likeBtn setImage:like_press forState:UIControlStateHighlighted];
        [likeBtn setImage:like_press forState:UIControlStateSelected];
        [likeBtn setImage:like_disabled forState:UIControlStateDisabled];
        //likeBtn.titleLabel.font = font;
        [likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [likeBtn setTitle:@"1000" forState:UIControlStateNormal];
        [self addSubview:likeBtn];
        
        UIButton *unlikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //unlikeBtn.backgroundColor = [UIColor skyBlueColor];
        unlikeBtn.frame = CGRectMake(100, 113, 80, 30);
        unlikeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        unlikeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [unlikeBtn setImage:unlike_unpress forState:UIControlStateNormal];
        [unlikeBtn setImage:unlike_press forState:UIControlStateHighlighted];
        [unlikeBtn setImage:unlike_press forState:UIControlStateSelected];
        [unlikeBtn setImage:unlike_disabled forState:UIControlStateDisabled];
        //unlikeBtn.titleLabel.font = font;
        [unlikeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [unlikeBtn setTitle:@"1000" forState:UIControlStateNormal];
        [self addSubview:unlikeBtn];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //shareBtn.backgroundColor = [UIColor skyBlueColor];
        shareBtn.frame = CGRectMake(220, 113, 80, 30);
        shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [shareBtn setImage:shareImage forState:UIControlStateNormal];
        //shareBtn.titleLabel.textColor = [UIColor blackColor];
        [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [shareBtn setTitle:@"1000" forState:UIControlStateNormal];
        [self addSubview:shareBtn];

        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        _title.backgroundColor = [UIColor clearColor];
        [self addSubview:_title];
    }
    
    return self;
}

- (void)initCellData:(NSDictionary*)info
{
    [_imageView sd_setImageWithURL:[info valueForKey:@"image_url"]];
    //_descriptionLabel.text = [info valueForKey:@"descript"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
