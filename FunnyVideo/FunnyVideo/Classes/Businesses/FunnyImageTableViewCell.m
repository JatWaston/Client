//
//  FunnyImageTableViewCell.m
//  FunnyVideo
//
//  Created by zhengzhilin on 14/12/22.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "FunnyImageTableViewCell.h"
#import "JWToolBarView.h"
#import "UtilManager.h"
#import "UIImageView+WebCache.h"

@interface FunnyImageTableViewCell() {
    UIImageView *_imageView;
    UILabel *_title;
    UIView *_lineView;
    JWToolBarView *_toolView;
}

@end

@implementation FunnyImageTableViewCell

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
        view.backgroundColor = [UIColor clearColor];
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
        [view addSubview:_imageView];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor grayColor];
        [view addSubview:_lineView];
        
        _toolView = [[JWToolBarView alloc] initWithFrame:CGRectZero];
        _toolView.type = JWImageTyp;
        [view addSubview:_toolView];
        
    }
    return self;
}

- (void)registerToolBarDelegate:(id)delegate {
    if (_toolView) {
        _toolView.delegate = delegate;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage*)funnyImage {
    return _imageView.image;
}

- (void)initCellData:(NSDictionary*)info indexPath:(NSIndexPath*)index {
    _title.text = [info valueForKey:@"title"];
    
    float offsetHeight = 2.0f;
    float heigth = [[UtilManager shareManager] heightForText:_title.text
                                                    rectSize:CGSizeMake(self.frame.size.width-10.0f, MAXFLOAT)
                                                        font:kCellTitleFont];
    _title.frame = CGRectMake(5, 2.0f, self.frame.size.width-10, heigth);
    
    offsetHeight += heigth+2;
    
    float viewWidth = self.frame.size.width-20;
    float imgWidth = [[info valueForKey:@"image_width"] floatValue];
    float imgHeight = [[info valueForKey:@"image_height"] floatValue];
    if (imgWidth >= viewWidth) {
        float scale = viewWidth/imgWidth*1.0f;
        imgWidth = viewWidth;
        imgHeight = imgHeight*scale;
    }
    
    _imageView.frame = CGRectMake(10, offsetHeight, imgWidth, imgHeight);
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_imageView sd_setImageWithURL:[info valueForKey:@"image_url"]];
    
    offsetHeight += imgHeight+1;
    
    _lineView.frame = CGRectMake(0, offsetHeight, self.frame.size.width, 0.5f);
    
    offsetHeight += 1;
    
    _toolView.frame = CGRectMake(0, offsetHeight, self.frame.size.width, 25);
    
    [_toolView fillingData:info indexPath:index];
}

@end
