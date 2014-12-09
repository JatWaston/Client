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
#import "UtilManager.h"
#import "JWToolBarView.h"

#define kPlayImageWidth  45.0f
#define kPlayImageHeight 45.0f

@interface JWImageTableViewCell()
{
    UIImageView *_imageView;
    UIButton *_playButton;
    UILabel *_title;
    UIButton *_likeBtn;
    UIButton *_unlikeBtn;
    UIButton *_shareBtn;
    UIView *_lineView;
    
    UILabel *_timeLabel;
    JWToolBarView *_toolView;
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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, self.frame.size.height-20)];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.layer.borderWidth = 0.5f;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font = kCellTitleFont;
        _title.numberOfLines = 0;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        _title.backgroundColor = [UIColor clearColor];
        _title.textColor = kCellTitleColor;
        //_title.textColor = [UIColor grayColor];
        [view addSubview:_title];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor colorWithRed:212/255.0f green:212/255.0f blue:212/255.0f alpha:1.0f];
        //_imageView.userInteractionEnabled = YES;
        //_imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [view addSubview:_imageView];
        
        UIImage *playNormalImg = [UIImage imageNamed:@"fun_play_normal"];
        UIImage *playPressImg = [UIImage imageNamed:@"fun_play_hover"];
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:playNormalImg forState:UIControlStateNormal];
        [_playButton setImage:playPressImg forState:UIControlStateHighlighted];
        [_imageView addSubview:_playButton];
        
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        [_imageView addSubview:_timeLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor grayColor];
        [view addSubview:_lineView];
        
        _toolView = [[JWToolBarView alloc] initWithFrame:CGRectZero];
        [view addSubview:_toolView];
        
#if 0
        UIImage *like_unpress = [UIImage imageNamed:@"icon_like_unpressed"];
        UIImage *like_press = [UIImage imageNamed:@"icon_like_pressed"];
        UIImage *like_disabled = [UIImage imageNamed:@"icon_like_disabled"];
        
        UIImage *unlike_unpress = [UIImage imageNamed:@"icon_unlike_unpressed"];
        UIImage *unlike_press = [UIImage imageNamed:@"icon_unlike_pressed"];
        UIImage *unlike_disabled = [UIImage imageNamed:@"icon_unlike_disabled"];
        
        UIImage *shareImage = [UIImage imageNamed:@"icon_more"];
        
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //likeBtn.backgroundColor = [UIColor skyBlueColor];
        //likeBtn.frame = CGRectMake(10, heightOffset, 80, 30);
        _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_likeBtn setImage:like_unpress forState:UIControlStateNormal];
        [_likeBtn setImage:like_press forState:UIControlStateHighlighted];
        [_likeBtn setImage:like_press forState:UIControlStateSelected];
        [_likeBtn setImage:like_disabled forState:UIControlStateDisabled];
        //likeBtn.titleLabel.font = font;
        [_likeBtn setTitleColor:kToolButtonTitleColor forState:UIControlStateNormal];
        //[_likeBtn setTitle:@"1000" forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = kToolButtonFont;
        [view addSubview:_likeBtn];
        
        _unlikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //unlikeBtn.backgroundColor = [UIColor skyBlueColor];
        //unlikeBtn.frame = CGRectMake(100, heightOffset, 80, 30);
        _unlikeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _unlikeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_unlikeBtn setImage:unlike_unpress forState:UIControlStateNormal];
        [_unlikeBtn setImage:unlike_press forState:UIControlStateHighlighted];
        [_unlikeBtn setImage:unlike_press forState:UIControlStateSelected];
        [_unlikeBtn setImage:unlike_disabled forState:UIControlStateDisabled];
        _unlikeBtn.titleLabel.font = kToolButtonFont;
        [_unlikeBtn setTitleColor:kToolButtonTitleColor forState:UIControlStateNormal];
        //[_unlikeBtn setTitle:@"1000" forState:UIControlStateNormal];
        [view addSubview:_unlikeBtn];
        
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //shareBtn.backgroundColor = [UIColor skyBlueColor];
        //shareBtn.frame = CGRectMake(220, heightOffset, 80, 30);
        _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_shareBtn setImage:shareImage forState:UIControlStateNormal];
        //shareBtn.titleLabel.textColor = [UIColor blackColor];
        _shareBtn.titleLabel.font = kToolButtonFont;
        [_shareBtn setTitleColor:kToolButtonTitleColor forState:UIControlStateNormal];
        //[_shareBtn setTitle:@"1000" forState:UIControlStateNormal];
        [view addSubview:_shareBtn];
#endif
        
        
    }
    
    return self;
}

- (void)initCellData:(NSDictionary*)info
{
    _title.text = [info valueForKey:@"title"];
    float offsetHeight = 2.0f;
    float heigth = [[UtilManager shareManager] heightForText:_title.text
                                                    rectSize:CGSizeMake(self.frame.size.width-135.0f, 1000)
                                                        font:kCellTitleFont];
    if (heigth > 85.0f) {
        offsetHeight = (heigth-85.0f)/2.0f;
    } else {
        heigth = 85.0f;
    }
    _title.frame = CGRectMake(135.0f, 0, self.frame.size.width-135.0f, heigth);
    
    float imgWidth = 135.0f;
    float imgHeight = 85.0f;
    //float viewWidth = [UIScreen mainScreen].bounds.size.width;
    
    _imageView.frame = CGRectMake(0, offsetHeight, imgWidth, imgHeight);
    [_imageView sd_setImageWithURL:[info valueForKey:@"coverImgURL"]];
    
    _playButton.frame = CGRectMake((imgWidth-kPlayImageWidth)/2.0f, (imgHeight-kPlayImageHeight)/2.0f, kPlayImageWidth, kPlayImageHeight);
    //_playImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    _timeLabel.frame = CGRectMake(imgWidth-40, imgHeight-20, 40, 20);
    _timeLabel.text = [info valueForKey:@"videoTime"];
    
    offsetHeight += imgHeight+1;
    
    _lineView.frame = CGRectMake(0, offsetHeight, self.frame.size.width, 0.5f);
    
    offsetHeight += 1;
    
    _toolView.frame = CGRectMake(0, offsetHeight, self.frame.size.width, 30);
    
    [_toolView fillingData:info];
    

//
//    _likeBtn.frame = CGRectMake(10, offsetHeight, 80, 30);
//    _unlikeBtn.frame = CGRectMake(100, offsetHeight, 80, 30);
//    _shareBtn.frame = CGRectMake(220, offsetHeight, 80, 30);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
