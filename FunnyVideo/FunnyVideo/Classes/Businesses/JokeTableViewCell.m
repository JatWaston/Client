//
//  JokeTableViewCell.m
//  FunnyVideo
//
//  Created by JatWaston on 14/12/2.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JokeTableViewCell.h"
#import "UtilManager.h"
#import "JWToolBarView.h"

@interface JokeTableViewCell()
{
    UILabel *_content;
    //UILabel *_title;
    UIButton *_likeBtn;
    UIButton *_unlikeBtn;
    UIButton *_shareBtn;
    UIView *_lineView;
    JWToolBarView *_toolView;
}

@end

@implementation JokeTableViewCell

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
        
        
        _content = [[UILabel alloc] initWithFrame:CGRectZero];
        _content.font = kCellTitleFont;
        _content.numberOfLines = 0;
        _content.lineBreakMode = NSLineBreakByWordWrapping;
        _content.backgroundColor = [UIColor clearColor];
        _content.textColor = kCellTitleColor;
        [view addSubview:_content];
        
        
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor grayColor];
        [view addSubview:_lineView];
        
        _toolView = [[JWToolBarView alloc] initWithFrame:CGRectZero];
        _toolView.type = JWJokeType;
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

- (void)initCellData:(NSDictionary*)info {
    _content.text = [info valueForKey:@"content"];
    float offsetHeight = 2.0f;
    float heigth = [[UtilManager shareManager] heightForText:_content.text
                                                    rectSize:CGSizeMake(self.frame.size.width-10, 1000)
                                                        font:kCellTitleFont];
    
    _content.frame = CGRectMake(5, 2.0f, self.frame.size.width-10, heigth);
    
    offsetHeight += heigth+1;
    
    _lineView.frame = CGRectMake(0, offsetHeight, self.frame.size.width, 0.5f);
    
    offsetHeight += 1;
    
    _toolView.frame = CGRectMake(0, offsetHeight, self.frame.size.width, 30);
    
    [_toolView fillingData:info];
    
//    [_likeBtn setTitle:[info valueForKey:@"likeCount"] forState:UIControlStateNormal];
//    [_unlikeBtn setTitle:[info valueForKey:@"unlikeCount"] forState:UIControlStateNormal];
//    [_shareBtn setTitle:[info valueForKey:@"shareCount"] forState:UIControlStateNormal];
//    
//    _likeBtn.frame = CGRectMake(10, offsetHeight, 80, 30);
//    _unlikeBtn.frame = CGRectMake(100, offsetHeight, 80, 30);
//    _shareBtn.frame = CGRectMake(220, offsetHeight, 80, 30);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
