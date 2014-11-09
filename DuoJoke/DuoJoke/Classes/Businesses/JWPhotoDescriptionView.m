//
//  JWPhotoDescriptionView.m
//  DuoJoke
//
//  Created by JatWaston on 14-10-28.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWPhotoDescriptionView.h"
#import "UILabel+ContentSize.h"

#define kOffX 10
#define kOffY 10
#define kPageHeight 20.0f
#define kDescriptionFontSize 15.0f

@interface JWPhotoDescriptionView()
{
    UILabel *_descriptionLabel;
    UILabel *_page;
}

@end

@implementation JWPhotoDescriptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
        self.userInteractionEnabled = NO; //忽略点击事件
        
        _page = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kPageHeight)];
        _page.backgroundColor = [UIColor clearColor];
        _page.textColor = [UIColor whiteColor];
        _page.textAlignment = NSTextAlignmentCenter;
        _page.font = [UIFont boldSystemFontOfSize:kDescriptionFontSize];
        [self addSubview:_page];
        
        _descriptionLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descriptionLabel.font = [UIFont boldSystemFontOfSize:kDescriptionFontSize];
        [self addSubview:_descriptionLabel];
    }
    return self;
}

- (void)updateDescription:(NSString*)description
{
    _descriptionLabel.text = description;
    float height = [_descriptionLabel contentSize].height;
    float offY = self.frame.size.height + self.frame.origin.y - height - 2*kOffY - 15;
    self.frame = CGRectMake(self.frame.origin.x, offY, self.frame.size.width, height+2*kOffY+15);
    _descriptionLabel.frame = CGRectMake(kOffX, kOffY, self.bounds.size.width-2*kOffX, 20+height);
    
}

- (void)updatePage:(NSString*)page
{
    _page.text = page;
}

@end
