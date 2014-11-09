//
//  ProgressImageView.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-22.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "ProgressImageView.h"
#import "UIImageView+WebCache.h"
#import "THProgressView.h"

#define kWidthScale 0.6f

@interface ProgressImageView()
{
    THProgressView *_progressView;
}

@end

@implementation ProgressImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _progressView = [[THProgressView alloc] initWithFrame:CGRectMake((self.frame.size.width-self.frame.size.width * kWidthScale)/2.0f, (self.frame.size.height-20)/2.0f, self.frame.size.width * kWidthScale, 20)];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.borderTintColor = [UIColor whiteColor];
        _progressView.hidden = YES;
        [self addSubview:_progressView];
    }
    return self;
}

- (void)imageWithURL:(NSURL*)imageURL placeholderImage:(UIImage*)placeholder
{
    __block THProgressView *progressView = _progressView;
    [self sd_setImageWithURL:imageURL
            placeholderImage:placeholder
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                        //NSLog(@"receivedSize = %d expectedSize = %d",(int)receivedSize,(int)expectedSize);
                        [self addSubview:progressView];
                        progressView.hidden = NO;
                        [progressView setProgress:(1.0f*receivedSize)/expectedSize];
                        if (receivedSize == expectedSize)
                        {
                            progressView.hidden = YES;
                            [progressView removeFromSuperview];
                        }
        
                    }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       progressView.hidden = YES;
                       [progressView removeFromSuperview];
                       progressView = nil;
                   }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
