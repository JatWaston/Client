//
//  WallpaperThumbImageView.h
//  Wallpaper
//
//  Created by JatWaston on 14-9-18.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WallpaperThumbDelegate;

@interface WallpaperThumbImageView : UIImageView

@property (nonatomic, weak) id<WallpaperThumbDelegate> delegate;
@property (nonatomic, assign) NSUInteger row; //处于第几个cell
@property (nonatomic, assign) NSUInteger index; //处于cell中的第几个
@property (nonatomic, strong) NSString *downloadURL; //该图片大图的下载地址

@end

@protocol WallpaperThumbDelegate <NSObject>

@optional
- (void)didSelectThumbImageView:(WallpaperThumbImageView*)view;

@end
