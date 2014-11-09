//
//  UIImage+Util.h
//  MobileExperience
//
//  Created by fuyongle on 14-5-28.
//  Copyright (c) 2014年 NetDragon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIImageRoundedCornerTopLeft = 1,
    UIImageRoundedCornerTopRight = 1 << 1,
    UIImageRoundedCornerBottomRight = 1 << 2,
    UIImageRoundedCornerBottomLeft = 1 << 3,
    UIImageRoundedCornerAll = 0x0f,
} UIImageRoundedCorner;

@interface UIImage (Util)

+ (UIImage *)captureImage:(UIView *)view;                           //view快照
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;  //纯颜色图片
+ (UIImage *)grayscaleImageForImage:(UIImage *)image;               //生成黑白图片

- (UIImage *)imageWithRoundedRectWithRadius:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask;
- (UIImage *)imageWithGrayScale;

@end
