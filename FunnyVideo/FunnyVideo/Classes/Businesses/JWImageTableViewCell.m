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
        _toolView.type = JWVideoType;
        [view addSubview:_toolView];
        
        
    }
    
    return self;
}

- (void)initCellData:(NSDictionary*)info
{
    _title.text = [info valueForKey:@"title"];
    float offsetHeight = 2.0f;
    float heigth = [[UtilManager shareManager] heightForText:_title.text
                                                    rectSize:CGSizeMake(self.frame.size.width-135.0f, MAXFLOAT)
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
