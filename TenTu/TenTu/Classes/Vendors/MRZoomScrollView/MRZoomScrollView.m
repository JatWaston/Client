//
//  MRZoomScrollView.m
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import "MRZoomScrollView.h"

#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)



@interface MRZoomScrollView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation MRZoomScrollView

@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight);
//        
        [self initImageView];
    }
    return self;
}

- (void)initImageView
{
    self.imageView = [[UIImageView alloc] init];
    
    // The imageView can be zoomed largest size
    self.imageView.frame = CGRectMake(0, 0, MRScreenWidth * 2.5, (MRScreenHeight) * 2.5);
    self.imageView.userInteractionEnabled = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.contentMode =  UIViewContentModeCenter;
    [self addSubview:self.imageView];
//    [imageView release];
    
    // Add gesture,double tap zoom imageView.
    _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [_doubleTapGesture setNumberOfTapsRequired:2];
    [self.imageView addGestureRecognizer:_doubleTapGesture];
//    [doubleTapGesture release];
    
    float minimumScale = self.frame.size.width / self.imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];
    [self setContentSize:CGSizeMake(MRScreenWidth, self.imageView.frame.size.height)];
}

- (void)setImage:(UIImage*)image
{
//    NSLog(@"frame = %@",NSStringFromCGRect(self.frame));
//    float scale = 1.0f*image.size.height/image.size.width;
//    float imageWidth = MIN(image.size.width, 320);
//    float imageHeight = scale*imageWidth;
//    NSLog(@"height = %f",self.frame.size.height);
//    float offY = (self.frame.size.height-MIN(imageHeight, self.frame.size.height))/2.0f;
//    [self.imageView setFrame:CGRectMake((self.frame.size.width-imageWidth)/2,offY, imageWidth, imageHeight)];
    [self.imageView setImage:image];
//    self.contentSize = CGSizeMake(self.frame.size.width, imageHeight);
//    NSLog(@"self.contentSize = %@",NSStringFromCGSize(self.contentSize));
}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale = self.zoomScale * 1.2f;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark - View cycle
- (void)dealloc
{
    [self.imageView removeGestureRecognizer:_doubleTapGesture];
}

@end
