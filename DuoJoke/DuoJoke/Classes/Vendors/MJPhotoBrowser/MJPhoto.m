//
//  MJPhoto.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhoto.h"
#import "UIImage+Util.h"

@implementation MJPhoto
@synthesize description = _description;

#pragma mark 截图
- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView
{
    _srcImageView = srcImageView;
    if (srcImageView.image.images) {
        _placeholder = srcImageView.image.images[0];
    } else {
        _placeholder = srcImageView.image;
    }
    
    //_placeholder = [UIImage imageWithColor:[UIColor blackColor] andSize:srcImageView.image.size];
    if (srcImageView.clipsToBounds) {
        _capture = [self capture:srcImageView];
    }
}

@end