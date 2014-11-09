//
//  JWPhotoBrowserController.m
//  DuoJoke
//
//  Created by JatWaston on 14-10-27.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWPhotoBrowserController.h"
#import "SwipeView.h"
#import "MJPhoto.h"
#import "SDWebImageManager+MJ.h"
#import "MJPhotoView.h"
#import "MJPhotoToolbar.h"
#import "MJPhotoToolbar.h"

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface JWPhotoBrowserController () <SwipeViewDataSource,SwipeViewDelegate,MJPhotoViewDelegate>
{
    SwipeView *_swipeView;
    NSUInteger _currentPage;
    NSMutableArray *_items;
    MJPhotoToolbar *_toolbar;
}

- (void)createScrollView;

@end

@implementation JWPhotoBrowserController
@synthesize items = _items;
@synthesize currentPage = _currentPage;

- (void)loadView
{
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentPage = 0;
    [self createScrollView];
    [self createToolbar];
}

- (void)showBrowser
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
}

- (void)hiddenBrowser
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)createToolbar
{
    CGFloat barHeight = 44;
    CGFloat barY = self.view.frame.size.height - barHeight;
    _toolbar = [[MJPhotoToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.photos = self.items;
    [self.view addSubview:_toolbar];
}

- (void)createScrollView
{
    _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    _swipeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeView.backgroundColor = [UIColor blackColor];
    _swipeView.dataSource = self;
    _swipeView.delegate = self;
    _swipeView.pagingEnabled = YES;
    [self.view addSubview:_swipeView];
    //[_swipeView scrollToPage:_currentPage duration:0.0f];
}

- (void)setItems:(NSMutableArray *)items
{
    _items = items;
    
//    if (photos.count > 1) {
//        _visiblePhotoViews = [NSMutableSet set];
//        _reusablePhotoViews = [NSMutableSet set];
//    }
    
    for (int i = 0; i<[_items count]; i++) {
        MJPhoto *photo = self.items[i];
        photo.index = i;
        photo.firstShow = i == _currentPage;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [self.items count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[MJPhotoView alloc] init];
        ((MJPhotoView*)view).photoViewDelegate = self;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    MJPhoto *photo = [self.items objectAtIndex:index];
    NSLog(@"photo = %@",photo);
    CGRect bounds = _swipeView.bounds;
    CGRect photoViewFrame = bounds;
//    photoViewFrame.size.width -= (2 * kPadding);
//    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    view.frame = photoViewFrame;
    ((MJPhotoView*)view).photo = photo;
    
    return view;
}

#pragma mark - SwipeViewDelegate

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return _swipeView.bounds.size;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    [self hiddenBrowser];
}

- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView
{
    _toolbar.currentPhotoIndex = (int)(swipeView.currentPage);
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
    _toolbar.currentPhotoIndex = (int)(swipeView.currentPage);
}

#pragma mark - 

- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    self.view.backgroundColor = [UIColor clearColor];
    _swipeView.backgroundColor = [UIColor clearColor];
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    [self hiddenBrowser];
}

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    //_swipeView.backgroundColor = [UIColor blackColor];
    //_toolbar.currentPhotoIndex = _currentPhotoIndex;
}

@end
