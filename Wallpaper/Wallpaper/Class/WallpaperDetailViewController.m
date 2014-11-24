//
//  WallpaperDetailViewController.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-18.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "WallpaperDetailViewController.h"
#import "UIImageView+WebCache.h"
//#import "WallpaperManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Toast+UIView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "THProgressView.h"
#import "ProgressImageView.h"

#import "GADBannerView.h"
#import "GADAdSize.h"
#import "GADInterstitial.h"
#import "JWNetworking.h"
#import "UtilManager.h"
#import "FMDatabase.h"

#define kToolBarHeight 52
#define kToolBarColor  [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.0f]

#define kToolIconHeight 30
#define kToolIconWidth  30

#define kIconPadding    67

typedef NS_ENUM(NSInteger, UIPreviewImageType)
{
    UIPreviewImageLock = 0,
    UIPreviewImageHome,
};



@interface WallpaperDetailViewController ()
{
    SwipeView *_swipeView;
    NSMutableArray *_item;
    NSUInteger _currentPage;
    ProgressImageView *_currentImageView;
    BOOL _isPreviewMode;
    UIView *_toolView;
    
    UIView *_previewLockView;
    UIView *_previewHomeView;
    
    GADBannerView *_adBannerView;
    GADInterstitial *_interstitialView;
    
    UIButton *_likeBtn;
    FMDatabase *_db;
    BOOL _showInterstitialAd;
}

- (void)createToolBar;
- (void)returnBack;
- (void)preview;
- (void)saveImage;
- (void)markImage;
- (void)shareImage;
- (void)autoPlay;

- (void)initData;
- (void)exitPreviewMode;

@end

@implementation WallpaperDetailViewController
@synthesize item = _item;
@synthesize currentPage = _currentPage;
@synthesize showInterstitialAd = _showInterstitialAd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        self.showInterstitialAd = NO;
    }
    return self;
}

//- (void)setCurrentPage:(NSUInteger)currentPage
//{
//    _currentPage = currentPage;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initDatabase];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    
#if 1
    _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    _swipeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeView.backgroundColor = [UIColor blackColor];
    _swipeView.dataSource = self;
    _swipeView.delegate = self;
    _swipeView.pagingEnabled = YES;
    [self.view addSubview:_swipeView];
#endif
    NSLog(@"currentPage = %lu",(unsigned long)_currentPage);
    [_swipeView scrollToPage:self.currentPage duration:0.0f];
    [self createToolBar];
    [self initAdmobAd];
    
}

- (void)initDatabase
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"wallpaper.db"];
    _db = [FMDatabase databaseWithPath:dbPath];
    if (![_db open])
    {
        NSLog(@"Could not open db.");
    }
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
    _adBannerView.hidden = YES;
    [self.view addSubview:_adBannerView];
    [_adBannerView loadRequest:[GADRequest request]];
    
    //插屏
    _interstitialView = [[GADInterstitial alloc] init];
    _interstitialView.adUnitID = kAdmobInterstitialKey;
    _interstitialView.delegate = self;
    [_interstitialView loadRequest:[GADRequest request]];
}

- (void)initData
{
    _currentImageView = nil;
    _isPreviewMode = NO;
}

- (void)createToolBar
{
    CGRect frame = self.view.frame;
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-kToolBarHeight, frame.size.width, kToolBarHeight)];
    _toolView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _toolView.backgroundColor = kToolBarColor;
    [self.view addSubview:_toolView];
    [self.view bringSubviewToFront:_toolView];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10.0f, (kToolBarHeight-kToolIconHeight)/2.0f, kToolIconWidth*0.9f, kToolIconHeight*0.9f);
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:backBtn];
    
    //主屏预览按钮
    UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    previewBtn.frame = CGRectMake(10.0f+kIconPadding, (kToolBarHeight-kToolIconHeight)/2.0f, kToolIconWidth, kToolIconHeight);
    [previewBtn setImage:[UIImage imageNamed:@"preview_icon"] forState:UIControlStateNormal];
    [previewBtn setImage:[UIImage imageNamed:@"preview_icon"] forState:UIControlStateSelected];
    [previewBtn addTarget:self action:@selector(createHomePreview) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:previewBtn];
    
    //锁屏预览按钮
    UIButton *lockViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lockViewBtn.frame = CGRectMake(10.0f+kIconPadding*2, (kToolBarHeight-kToolIconHeight)/2.0f, kToolIconWidth, kToolIconHeight);
    [lockViewBtn setImage:[UIImage imageNamed:@"lock_icon"] forState:UIControlStateNormal];
    [lockViewBtn setImage:[UIImage imageNamed:@"lock_icon"] forState:UIControlStateSelected];
    [lockViewBtn addTarget:self action:@selector(createLockPreview) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:lockViewBtn];
    
    //下载按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(10.0f+kIconPadding*3, (kToolBarHeight-kToolIconHeight)/2.0f, kToolIconWidth, kToolIconHeight);
    [saveBtn setImage:[UIImage imageNamed:@"download_icon"] forState:UIControlStateNormal];
    [saveBtn setImage:[UIImage imageNamed:@"download_icon"] forState:UIControlStateSelected];
    [saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:saveBtn];
    
    //下载按钮
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame = CGRectMake(10.0f+kIconPadding*4, (kToolBarHeight-kToolIconHeight)/2.0f, kToolIconWidth, kToolIconHeight);
    [_likeBtn setImage:[UIImage imageNamed:@"like_icon"] forState:UIControlStateNormal];
//    [_likeBtn setImage:[UIImage imageNamed:@"like_selected_icon"] forState:UIControlStateSelected];
//    [_likeBtn setImage:[UIImage imageNamed:@"like_selected_icon"] forState:UIControlStateHighlighted];
    [_likeBtn setImage:[UIImage imageNamed:@"like_selected_icon"] forState:UIControlStateDisabled];
    [_likeBtn addTarget:self action:@selector(likeImage) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:_likeBtn];
    
#if 0
    //收藏按钮
    UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    markBtn.frame = CGRectMake(10.0f+kIconPadding*3, (kToolBarHeight-kToolIconHeight)/2.0f, kToolIconWidth, kToolIconHeight);
    [markBtn setImage:[UIImage imageNamed:@"icon_fav"] forState:UIControlStateNormal];
    [markBtn setImage:[UIImage imageNamed:@"icon_fav_selected"] forState:UIControlStateSelected];
    [markBtn addTarget:self action:@selector(markImage) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:markBtn];
    
    //分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(10.0f+kIconPadding*4, (kToolBarHeight-kToolIconHeight)/2.0f, kToolIconWidth, kToolIconHeight);
    [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"icon_share_selected"] forState:UIControlStateSelected];
    [shareBtn addTarget:self action:@selector(shareImage) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:shareBtn];
    
    //自动播放按钮
    UIButton *autoPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoPlayBtn.frame = CGRectMake(10.0f+kIconPadding*5, (kToolBarHeight-kToolIconHeight)/2.0f, kToolIconWidth, kToolIconHeight);
    [autoPlayBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    [autoPlayBtn setImage:[UIImage imageNamed:@"icon_play_selected"] forState:UIControlStateSelected];
    [autoPlayBtn addTarget:self action:@selector(autoPlay) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:autoPlayBtn];
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark function of toolbar

- (void)returnBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)preview
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"锁屏壁纸 预览",@"主屏壁纸 预览", nil];
    [actionSheet showInView:self.view];
}

- (void)createPreviewImage:(UIPreviewImageType)previewType
{
    switch (previewType)
    {
        case UIPreviewImageLock:
            [self createLockPreview];
            break;
        case UIPreviewImageHome:
            [self createHomePreview];
            break;
        default:
            break;
    }
    if (previewType == UIPreviewImageHome || previewType == UIPreviewImageLock)
    {
        _isPreviewMode = YES;
        _adBannerView.hidden = YES;
        _toolView.hidden = YES;
    }
}

- (void)hiddenOtherView
{
    _isPreviewMode = YES;
    _adBannerView.hidden = YES;
    _toolView.hidden = YES;
}

- (void)createLockPreview
{
    if (_previewLockView == nil)
    {
        _previewLockView = [[UIView alloc] initWithFrame:self.view.frame];
        _previewLockView.backgroundColor = [UIColor clearColor];
        _previewLockView.userInteractionEnabled = NO;
        
        //添加时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 80)];
        timeLabel.tag = 300;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:85];
        [_previewLockView addSubview:timeLabel];
        
        //添加日期和周几
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 20)];
        dataLabel.tag = 400;
        dataLabel.backgroundColor = [UIColor clearColor];
        dataLabel.textAlignment = NSTextAlignmentCenter;
        dataLabel.textColor = [UIColor whiteColor];
        dataLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
        [_previewLockView addSubview:dataLabel];
        
        
        UIImage *bottomImage = [UIImage imageNamed:@"ios7_preview_lock_bottom_cn"];
        UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottomImage];
        bottomView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        bottomView.frame = CGRectMake(0, _previewLockView.frame.size.height-bottomImage.size.height, bottomImage.size.width, bottomImage.size.height);
        [_previewLockView addSubview:bottomView];
        
        [self.view addSubview:_previewLockView];
        
    }
    UILabel *timeLabel = (UILabel*)[_previewLockView viewWithTag:300];
    timeLabel.text = [self calculationTime];
    
    UILabel *dataLabel = (UILabel*)[_previewLockView viewWithTag:400];
    dataLabel.text = [self calculationData];
    
    _previewLockView.hidden = NO;
    [self hiddenOtherView];
}

- (void)createHomePreview
{
    //[self deleteImage];
    //[[WallpaperManager shareManager] applyWallpaper:_currentImageView.image type:UIWallpaperHomeType];
    if (_previewHomeView == nil)
    {
        
        _previewHomeView = [[UIView alloc] initWithFrame:self.view.frame];
        _previewHomeView.backgroundColor = [UIColor clearColor];
        _previewHomeView.userInteractionEnabled = NO;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitPreviewMode)];
//        [_previewHomeView addGestureRecognizer:tap];
//        _previewHomeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIImage *topImage = [UIImage imageNamed:@"ios7_preview_home_top_ip4_cn"];
        UIImageView *topView = [[UIImageView alloc] initWithImage:topImage];
        topView.frame = CGRectMake((_previewHomeView.frame.size.width-topImage.size.width)/2.0f, 25, topImage.size.width, topImage.size.height);
        [_previewHomeView addSubview:topView];
        
        UIImage *bottomImage = [UIImage imageNamed:@"ios7_preview_home_bottom_cn"];
        UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottomImage];
        bottomView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        bottomView.frame = CGRectMake(0, _previewHomeView.frame.size.height-bottomImage.size.height, bottomImage.size.width, bottomImage.size.height);
        [_previewHomeView addSubview:bottomView];
        
        [self.view addSubview:_previewHomeView];
    }
    _previewHomeView.hidden = NO;
    [self hiddenOtherView];
}

- (NSString*)calculationTime
{
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateStyle:NSDateFormatterShortStyle];
    [dataFormatter setDateFormat:@"HH:mm"];
    NSString *time = [dataFormatter stringFromDate:[NSDate date]];
    return time;
}

- (NSString*)calculationData
{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit |
                          NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = (int)[comps weekday];
    int month = (int)[comps month];
    int day = (int)[comps day];
    
    NSString *data = [NSString stringWithFormat:@"%d月%d日 %@",month,day,[arrWeek objectAtIndex:week-1]];
    NSLog(@"data = %@",data);
    return data;
}

- (void)addRecordToDatabase:(NSDictionary*)info
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO favoriteList (id,thumbURL,downloadURL) VALUES ('%@','%@','%@')",[info valueForKey:@"id"],[info valueForKey:@"thumbURL"],[info valueForKey:@"downloadURL"]];
//    BOOL res = [_db executeUpdate:@"INSERT INTO favoriteList (id,thumbURL,downloadURL) VALUES (?,?,?)",[info valueForKey:@"id"],[info valueForKey:@"thumbURL"],[info valueForKey:@"downloadURL"]];
    BOOL res = [_db executeUpdate:sql];
    if (!res)
    {
        NSLog(@"insert record error.");
    }
    else
    {
        [self.view makeToast:@"收藏成功" duration:1.0f position:@"center"];
    }
}

- (void)deleteImage
{
    NSDictionary *info = [self.item objectAtIndex:_swipeView.currentPage];
    NSString *imageID = [info valueForKey:@"id"];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:imageID,@"id", nil];
    JWNetworking *networking = [[JWNetworking alloc] init];
    NSString *requestURL = kWallpaperDeleteImageURL;
    [networking requestWithURL:requestURL requestMethod:JWRequestMethodPost params:paramsDic requestComplete:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"message = %@",message);
        } else {
            NSLog(@"error = %@",[error localizedDescription]);
        }
    }];
}

- (void)likeImage
{
    _likeBtn.enabled = NO;
    NSDictionary *info = [self.item objectAtIndex:_swipeView.currentPage];
    [self addRecordToDatabase:info];
    NSString *requestURL = [[UtilManager shareManager] additionlParamURL:kWallpaperFavoriteURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[info valueForKey:@"id"],@"imageID",[info valueForKey:@"thumbURL"],@"thumbURL",[info valueForKey:@"downloadURL"],@"downloadURL", nil];
    JWNetworking *networking = [[JWNetworking alloc] init];
    [networking requestWithURL:requestURL requestMethod:JWRequestMethodPost params:dic requestComplete:^(NSData *data, NSError *error) {
        if (error == nil)
        {
            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"message = %@",message);
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            NSLog(@"result = %@",result);
        }
        else
        {
            NSLog(@"error = %@",[error localizedDescription]);
        }
        
    }];
}

- (void)reportDownloadCount
{
    NSDictionary *info = [self.item objectAtIndex:_swipeView.currentPage];
    NSString *requestURL = [[UtilManager shareManager] additionlParamURL:kWallpaperDownloadRankURL];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[info valueForKey:@"id"],@"imageID",[info valueForKey:@"thumbURL"],@"thumbURL",[info valueForKey:@"downloadURL"],@"downloadURL", nil];
    JWNetworking *networking = [[JWNetworking alloc] init];
    [networking requestWithURL:requestURL requestMethod:JWRequestMethodPost params:dic requestComplete:^(NSData *data, NSError *error) {
        if (error == nil)
        {
            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"message = %@",message);
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            NSLog(@"result = %@",result);
        }
        else
        {
            NSLog(@"error = %@",[error localizedDescription]);
        }
        
    }];
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
                        [self saveImageToAlbum:_currentImageView.image];
                        
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
            [self saveImageToAlbum:_currentImageView.image];
            break;
        default:
            break;
    }
}

- (void)updateLikeBtnStatus
{
    NSDictionary *info = [self.item objectAtIndex:_swipeView.currentPage];
    NSString *sql = [NSString stringWithFormat:@"SELECT id FROM favoriteList WHERE id = '%@'",[info valueForKey:@"id"]];
    
    FMResultSet *rs = [_db executeQuery:sql];
    
    if ([rs next])
    {
        //_likeBtn.selected = YES;
        _likeBtn.enabled = NO;
        
    }
    else
    {
//        _likeBtn.selected = NO;
        _likeBtn.enabled = YES;
    }
    
}

- (void)saveImageToAlbum:(UIImage*)image
{
    [self reportDownloadCount];
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

- (void)markImage
{
    
}

- (void)shareImage
{
    
}

- (void)autoPlay
{
    
}

- (void)exitPreviewMode
{
    _isPreviewMode = NO;
    _previewLockView.hidden = YES;
    _previewHomeView.hidden = YES;
    _toolView.hidden = NO;
    _adBannerView.hidden = NO;
    _toolView.frame = CGRectMake(0, self.view.frame.size.height-kToolBarHeight-_adBannerView.frame.size.height, self.view.frame.size.width, kToolBarHeight);
}

#pragma mark -
#pragma mark 其他功能

- (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [self.item count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[ProgressImageView alloc] initWithFrame:CGRectMake((_swipeView.frame.size.width)*index, 0, self.view.frame.size.width, _swipeView.frame.size.height)];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    
    NSDictionary *dic = [self.item objectAtIndex:index];
    NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:[dic valueForKey:@"thumbURL"]]];
    UIImage *placeholderImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageKey];
    if (placeholderImage == nil)
    {
        placeholderImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageKey];
    }
    
    [(ProgressImageView*)view imageWithURL:[dic valueForKey:@"downloadURL"] placeholderImage:placeholderImage];
    
    
#if 0
    NSLog(@"downloadURL = %@",[dic valueForKey:@"downloadURL"]);
    __block THProgressView *progressView;
    [(UIImageView*)view sd_setImageWithURL:[dic valueForKey:@"downloadURL"] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"receivedSize = %d expectedSize = %d",(int)receivedSize,(int)expectedSize);
        if (progressView == nil)
        {
            progressView = [[THProgressView alloc] initWithFrame:CGRectMake((view.frame.size.width-view.frame.size.width * 0.76)/2.0f, (view.frame.size.height-20)/2.0f, view.frame.size.width * 0.76, 20)];
            progressView.progressTintColor = [UIColor whiteColor];
            progressView.borderTintColor = [UIColor whiteColor];
            progressView.hidden = YES;
            [view addSubview:progressView];
        }
        progressView.hidden = NO;
        [progressView setProgress:(1.0f*receivedSize)/expectedSize animated:YES];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"completed");
        if (progressView)
        {
            progressView.hidden = YES;
            [progressView removeFromSuperview];
        }
    }];
#endif
    //_currentImageView = (ProgressImageView*)view;
    return view;
}


#pragma mark -
#pragma mark SwipeViewDelegate

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return _swipeView.bounds.size;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    if (_isPreviewMode)
    {
        [self exitPreviewMode];
    }
    else
    {
        _toolView.hidden = !_toolView.hidden;
    }
    
}

- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView
{
    _currentImageView = (ProgressImageView*)[swipeView itemViewAtIndex:swipeView.currentPage];
    //self.title = [NSString stringWithFormat:@"(%d/%d)",(int)(swipeView.currentPage+1),(int)[self.item count]];
    [self updateLikeBtnStatus];
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
    _currentImageView = (ProgressImageView*)[swipeView itemViewAtIndex:swipeView.currentPage];
    //self.title = [NSString stringWithFormat:@"(%d/%d)",(int)(swipeView.currentPage+1),(int)[self.item count]];
    [self updateLikeBtnStatus];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = %d",(int)buttonIndex);
    [self createPreviewImage:(UIPreviewImageType)buttonIndex];
}

#pragma mark -
#pragma mark GADBannerViewDelegate

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
    if (_adBannerView.hidden)
    {
        _adBannerView.hidden = NO;
    }
    _toolView.frame = CGRectMake(0, self.view.frame.size.height-kToolBarHeight-adView.frame.size.height, self.view.frame.size.width, kToolBarHeight);
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    _adBannerView.hidden = YES;
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}

#pragma mark -
#pragma mark GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"Received GADInterstitial successfully");
    if (self.showInterstitialAd)
    {
        [_interstitialView presentFromRootViewController:self];
    }
    
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"GADInterstitial error:%@",[error localizedFailureReason]);
}


@end
