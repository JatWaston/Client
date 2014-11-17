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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 310, 100)];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_imageView];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 119, 320, 1)];
//        lineView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:lineView];
        
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
