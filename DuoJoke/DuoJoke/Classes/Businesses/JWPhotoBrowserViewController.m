//
//  JWPhotoBrowserViewController.m
//  图片浏览器示例
//
//  Created by JatWaston on 14-10-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "JWPhotoBrowserViewController.h"
#import "SwipeView.h"
#import "MJPhoto.h"
#import "MJPhotoView.h"
#import "JWPhotoView.h"
#import "UIImageView+WebCache.h"
#import "JWPhotoDescriptionView.h"

#import "GADBannerView.h"
#import "GADAdSize.h"
#import "GADInterstitial.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "Toast+UIView.h"

#define kToolBarHeight 52
#define kToolBarColor  [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.0f]

@interface JWPhotoBrowserViewController () <SwipeViewDataSource,SwipeViewDelegate,MJPhotoViewDelegate,JWPhotoViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>
{
    SwipeView *_swipeView;
    JWPhotoDescriptionView *_descriptionView;
    NSMutableArray *_photos;
    NSUInteger _currentPhotoIndex;
    
    GADBannerView *_adBannerView;
    GADInterstitial *_interstitialView;
    NSMutableArray *photoViews;
    BOOL _statusHiddenStatus;
    UIView *_toolView;
    __weak id<JWPhotoBrowserDelegate> _delegate;
}

- (void)createDescriptionView;
- (void)createScrollView;
- (void)hiddenBrowser;
- (void)createToolBar;

- (void)saveImageToAlbum:(UIImage*)image;
- (void)saveImage;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

- (void)updatePhotoView:(SwipeView*)swipeView;
- (void)updateDescription:(SwipeView*)swipeView;

@end

@implementation JWPhotoBrowserViewController
@synthesize photos = _photos;
@synthesize currentPhotoIndex = _currentPhotoIndex;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    _statusHiddenStatus = [UIApplication sharedApplication].isStatusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self createScrollView];
    [self createDescriptionView];
    [self createToolBar];
    [self initAdmobAd];
    photoViews = [[NSMutableArray alloc] init];
}

- (void)createToolBar
{
    //_toolView的高度要随着描述的高度进行改变
    CGRect frame = self.view.frame;
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-kToolBarHeight-50, frame.size.width, kToolBarHeight)];
    _toolView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _toolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_toolView];
    [self.view bringSubviewToFront:_toolView];
    
    //保存图片
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"focus_Save"];
    saveBtn.frame = CGRectMake(5, (kToolBarHeight-image.size.height)/2.0f, image.size.width, image.size.height);
    [saveBtn setImage:image forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"focus_Save_Down"] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:saveBtn];
    
    //分享图片
}

- (void)initAdmobAd
{
    //横幅
    CGPoint origin = CGPointMake(0.0,
                                 self.view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    //_adBannerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _adBannerView.adUnitID = kAdmobBannerKey;
    _adBannerView.delegate = self;
    _adBannerView.rootViewController = self;
    [self.view addSubview:_adBannerView];
    [_adBannerView loadRequest:[GADRequest request]];
    
//    //插屏
//    _interstitialView = [[GADInterstitial alloc] init];
//    _interstitialView.adUnitID = kAdmobInterstitialKey;
//    _interstitialView.delegate = self;
//    [_interstitialView loadRequest:[GADRequest request]];
}

- (void)createDescriptionView
{
    _descriptionView = [[JWPhotoDescriptionView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height-100-50, self.view.frame.size.width-50, 100)];
    _descriptionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _descriptionView.hidden = YES;
    [self.view addSubview:_descriptionView];
}

- (void)createScrollView
{
    _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-50)];
    _swipeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeView.backgroundColor = [UIColor blackColor];
    _swipeView.dataSource = self;
    _swipeView.delegate = self;
    _swipeView.pagingEnabled = YES;
    [self.view addSubview:_swipeView];
    [_swipeView scrollToPage:_currentPhotoIndex duration:0.0f];
}

- (void)saveImageToAlbum:(UIImage*)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil)
    {
        [self.view makeToast:@"保存成功" duration:1.0f position:@"center"];
    }
    else
    {
        [self.view makeToast:@"保存失败" duration:1.0f position:@"center"];
    }
}

- (void)saveImage
{
    switch ([ALAssetsLibrary authorizationStatus])
    {
        case ALAuthorizationStatusNotDetermined:
        {
            NSLog(@"ALAuthorizationStatusNotDetermined");
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if (*stop) {
                    //点击“好”回调方法:这里是重点
                    [self saveImageToAlbum:((JWPhotoView*)_swipeView.currentItemView).photo.image];
                    
                }
                *stop = TRUE;
                
            } failureBlock:^(NSError *error) {
                
                //点击“不允许”回调方法:这里是重点
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
        }
            break;
        case ALAuthorizationStatusDenied:
            NSLog(@"ALAuthorizationStatusDenied");
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"相册权限"
                                                                message:@"保存图片需要相册权限，请在（设置->隐私->照片->轻壁纸）中开启"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            //越狱设备直接跳转到相应界面进行设置
        }
            break;
        case ALAuthorizationStatusAuthorized:
            [self saveImageToAlbum:((JWPhotoView*)_swipeView.currentItemView).photo.image];
            break;
        default:
            break;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

- (void)updatePhotoView:(SwipeView*)swipeView
{
    MJPhoto *photo = [self.photos objectAtIndex:swipeView.currentItemIndex];
    ((JWPhotoView*)swipeView.currentItemView).photo = photo;
}

- (void)updateDescription:(SwipeView*)swipeView
{
    if (swipeView.currentItemIndex >= [self.photos count]) {
        return;
    }
    MJPhoto *photo = [self.photos objectAtIndex:swipeView.currentItemIndex];
    NSString *page = [NSString stringWithFormat:@"(%d / %d)",(int)(swipeView.currentItemIndex+1),(int)(swipeView.numberOfPages)];
    [_descriptionView updatePage:page];
    [_descriptionView updateDescription:photo.description];
    if (_descriptionView.hidden) {
        _descriptionView.hidden = NO;
    }
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
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
    return [self.photos count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[JWPhotoView alloc] init];
        //((JWPhotoView*)view).photoViewDelegate = self;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [photoViews addObject:view];
    }
    
    MJPhoto *photo = [self.photos objectAtIndex:index];
    //NSLog(@"photo = %@",photo);
    CGRect bounds = _swipeView.bounds;
    CGRect photoViewFrame = bounds;
    //    photoViewFrame.size.width -= (2 * kPadding);
    //    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    view.frame = photoViewFrame;
    ((JWPhotoView*)view).photo = photo;
    ((JWPhotoView*)view).photoViewDelegate = self;
    
    return view;
}

- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView
{
    //[self updatePhotoView:swipeView];
    [self updateDescription:swipeView];
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
    //[self updatePhotoView:swipeView];
    [self updateDescription:swipeView];
}

#pragma mark - MJPhotoViewDelegate

- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    [[UIApplication sharedApplication] setStatusBarHidden:_statusHiddenStatus withAnimation:UIStatusBarAnimationFade];
    self.view.backgroundColor = [UIColor clearColor];
    _swipeView.backgroundColor = [UIColor clearColor];
    [_descriptionView removeFromSuperview];
    [_adBannerView removeFromSuperview];
    [_toolView removeFromSuperview];
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    [self hiddenBrowser];
    if (_delegate && [self.delegate respondsToSelector:@selector(photoBrowserDidEndZoomIn)]) {
        [_delegate photoBrowserDidEndZoomIn];
    }
}

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    //_swipeView.backgroundColor = [UIColor blackColor];
    //_toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark -
#pragma mark GADBannerViewDelegate

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

#pragma mark -
#pragma mark GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"Received GADInterstitial successfully");
    [ad presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"GADInterstitial error:%@",[error localizedFailureReason]);
}



@end
