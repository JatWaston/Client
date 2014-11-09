//
//  JWPhotoView.m
//  图片浏览器示例
//
//  Created by JatWaston on 14-10-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "JWPhotoView.h"
#import "MJPhoto.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoLoadingView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "YLImageView.h"

@interface JWPhotoView() <UIScrollViewDelegate>
{
    YLImageView *_imageView;
    MJPhoto *_photo;
    MJPhotoLoadingView *_photoLoadingView;
    BOOL _isAnimationing;
}

@end

@implementation JWPhotoView
@synthesize photo = _photo;
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        // 图片
        _imageView = [[YLImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        _isAnimationing = NO;
        
        // 进度条
        _photoLoadingView = [[MJPhotoLoadingView alloc] init];
        [self addSubview:_photoLoadingView];
        
        // 属性
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
//        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//        doubleTap.numberOfTapsRequired = 2;
//        [self addGestureRecognizer:doubleTap];

    }
    return self;
}

- (void)setPhoto:(MJPhoto *)photo
{
    //self.imageView.image = nil;
    [[SDImageCache sharedImageCache] clearMemory];
    _photo = photo;
    //_isAnimationing = NO;
    [_photoLoadingView removeFromSuperview]; //去除loading
    [self showImage];
}

- (void)showImage
{
    //NSLog(@"_photo.srcImageView.image = %@",_photo.srcImageView.image);
    //_imageView.image = _photo.srcImageView.image;
    
    if (_photo.firstShow) { // 首次显示
        _imageView.image = _photo.placeholder; // 占位图片
        //_photo.srcImageView.image = nil;
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        // 不是gif，就马上开始下载
        if (![_photo.url.absoluteString hasSuffix:@"gif"]) {
            __block JWPhotoView *photoView = self;
            __block MJPhoto *photo = _photo;
            __block MJPhotoLoadingView *photoLoadingView = _photoLoadingView;
            
            [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                photo.image = image;
                [photoLoadingView removeFromSuperview];
                // 调整frame参数
                [photoView adjustFrame];
            }];
        }
    } else {
        [self photoStartLoad];
    }
    
    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    if (_photo.image) {
        self.scrollEnabled = YES;
        _imageView.image = _photo.image;
    } else {
        self.scrollEnabled = NO;
        // 直接显示进度条
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];
        
        __block JWPhotoView *photoView = self;
        __block MJPhotoLoadingView *loading = _photoLoadingView;
        [_imageView sd_setImageWithURL:_photo.url placeholderImage:[UIImage imageNamed:@"defaultPic.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (receivedSize > kMinProgress) {
                loading.progress = (float)receivedSize/expectedSize;
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //NSLog(@"cacheType = %d",(int)cacheType);
            [photoView photoDidFinishLoadWithImage:image];
        }];
    }
}

- (void)adjustFrame
{
    if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    if (_imageView.image.images) {
        imageSize = ((UIImage*)_imageView.image.images[0]).size;
    }
    
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
    if (minScale > 1) {
        minScale = 1.0;
    }
    CGFloat maxScale = 2.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
    } else {
        imageFrame.origin.y = 0;
    }
    if (_photo.firstShow) {
        if (_isAnimationing == NO) {
            //NSLog(@"size = %@",NSStringFromCGSize(_photo.srcImageView.frame.size));
            _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.frame toView:nil];
            //NSLog(@"begin frame = %@",NSStringFromCGRect(_imageView.frame));
            [UIView animateWithDuration:0.3f animations:^{
                _isAnimationing = YES;
                _imageView.frame = imageFrame;
            } completion:^(BOOL finished) {
                // 设置底部的小图片
                _photo.firstShow = NO;
                _isAnimationing = NO;
                _photo.srcImageView.image = _photo.placeholder;
                [self photoStartLoad];
            }];
        }

    } else {
        //NSLog(@"set frame = %@",NSStringFromCGRect(_imageView.frame));
        _imageView.frame = imageFrame;
        
    }

    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
//        if (image.images) {
//            NSData *gifData = UIImagePNGRepresentation(image);
//            FLAnimatedImage *animationImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
//            _imageView.animatedImage = animationImage;
//        }
        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    // 移除进度条
    [_photoLoadingView removeFromSuperview];
    self.contentOffset = CGPointZero;
    
    CGFloat duration = 0.15;
    if (_photo.srcImageView.clipsToBounds) {
        [self performSelector:@selector(reset) withObject:nil afterDelay:duration];
    }
    [UIView animateWithDuration:duration + 0.1 animations:^{
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }
    } completion:^(BOOL finished) {
        _photo.srcImageView.image = _photo.placeholder;
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
            [self.photoViewDelegate photoViewDidEndZoom:self];
        }
    }];
}

- (void)reset
{
    //_imageView.image = _photo.srcImageView.image;
    _imageView.image = _photo.capture; //裁剪
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

//实现图片在缩放过程中居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0f;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0f;
    _imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
    
}



@end
