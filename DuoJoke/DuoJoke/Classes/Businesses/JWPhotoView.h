//
//  JWPhotoView.h
//  图片浏览器示例
//
//  Created by JatWaston on 14-10-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWPhotoView;

@protocol JWPhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(JWPhotoView *)photoView;
- (void)photoViewSingleTap:(JWPhotoView *)photoView;
- (void)photoViewDidEndZoom:(JWPhotoView *)photoView;
@end

@class MJPhoto;

@interface JWPhotoView : UIScrollView

@property (nonatomic, strong) MJPhoto *photo;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<JWPhotoViewDelegate> photoViewDelegate;

@end

