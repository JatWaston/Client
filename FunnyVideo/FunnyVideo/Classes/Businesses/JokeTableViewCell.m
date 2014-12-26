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
        view.backgroundColor = [UIColor clearColor];
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
        
    }
    
    return self;
}

- (void)registerToolBarDelegate:(id)delegate {
    if (_toolView) {
        _toolView.delegate = delegate;
    }
}

- (void)initCellData:(NSDictionary*)info indexPath:(NSIndexPath*)index {
    _content.text = [info valueForKey:@"content"];
//    float heigth = [[UtilManager shareManager] heightForText:_content.text
//                                                    rectSize:CGSizeMake(self.frame.size.width-10, MAXFLOAT)
//                                                        font:kCellTitleFont];
    CGSize titleSize = [_content.text sizeWithFont:kCellTitleFont constrainedToSize:CGSizeMake(self.frame.size.width-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    _content.frame = CGRectMake(5, 2.0f, self.frame.size.width-10, titleSize.height);
    
    float offsetHeight = 2.0f;
    
    offsetHeight += titleSize.height+1;
    
    _lineView.frame = CGRectMake(0, offsetHeight, self.frame.size.width, 0.5f);
    
    offsetHeight += 1;
    
    _toolView.frame = CGRectMake(0, offsetHeight, self.frame.size.width, 30);
    
    [_toolView fillingData:info indexPath:index];
    
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
