//
//  JWImageTableViewCell.m
//  TenTu
//
//  Created by JatWaston on 14-11-16.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWImageTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface JWImageTableViewCell()
{
    UIImageView *_titleImageView;
    UILabel *_titleLabel;
    UIImageView *_imageView;
    UILabel *_descriptionLabel;
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
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 310, 100)];
        _imageView.backgroundColor = [UIColor colorWithRed:212/255.0f green:212/255.0f blue:212/255.0f alpha:1.0f];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_imageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 111, 320, 0.5f)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
        
        UIImage *likeImage = [UIImage imageNamed:@"like"];
        UIImage *unlikeImage = [UIImage imageNamed:@"unlike"];
        UIImage *shareImage = [UIImage imageNamed:@"share1"];
        
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        likeBtn.frame = CGRectMake(10, 115, 28, 28);
        [likeBtn setImage:likeImage forState:UIControlStateNormal];
        [self addSubview:likeBtn];
        
        UIButton *unlikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        unlikeBtn.frame = CGRectMake(80, 115, 28, 28);
        [unlikeBtn setImage:unlikeImage forState:UIControlStateNormal];
        [self addSubview:unlikeBtn];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(280, 115, 30, 30);
        [shareBtn setImage:shareImage forState:UIControlStateNormal];
        [self addSubview:shareBtn];
//
//        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//        _descriptionLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:_descriptionLabel];
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
