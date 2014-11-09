//
//  WallpaperThumbImageView.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-18.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "WallpaperThumbImageView.h"

@interface WallpaperThumbImageView()
{
    NSUInteger _row;
    NSUInteger _index;
    NSString *_downloadURL;
    __weak id<WallpaperThumbDelegate> _delegate;
}

@end

@implementation WallpaperThumbImageView

@synthesize row = _row;
@synthesize index = _index;
@synthesize downloadURL = _downloadURL;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectThumbImageView:)])
    {
        [self.delegate didSelectThumbImageView:self];
    }
    
}

@end
