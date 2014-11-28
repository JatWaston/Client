//
//  RootViewController.m
//  FunnyVideo
//
//  Created by JatWaston on 14-11-24.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "RootViewController.h"
#import "JWMPMoviePlayerViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "JWImageTableViewCell.h"

#import "UIColor+Colours.h"

#import "GADBannerView.h"
#import "GADAdSize.h"
#import "GADInterstitial.h"

#import "NSString+MD5.h"
#import "MBProgressHUD+Add.h"

#import "TOWebViewController.h"
#import "UtilManager.h"

#define kRequestPageSize 10


@interface RootViewController () <GADBannerViewDelegate,GADInterstitialDelegate>
{
    JWMPMoviePlayerViewController *_player;
    
    GADBannerView *_adBannerView;
    GADInterstitial *_interstitialView;
    
    NSUInteger _catalog;
    NSUInteger _type;
}

- (void)initAdmobAd;

@end

@implementation RootViewController

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"视频";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_daily"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _catalog = 8000;
    _type = 8001;
    _currentPage = 1;
    _isRefreshing = YES;
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerNotificationHandler:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil]; //检测播放结束的原因
    self.contentTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
    self.contentTableView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initAdmobAd];
    
    [self requestWithCatalog:_catalog];
    
}

- (void)requestWithCatalog:(NSUInteger)catalog
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    _isRefreshing = YES;
    _currentPage = 1;
    NSString *url = [self builtURLWithPage:_currentPage catalog:catalog validKey:kValidStr];
    [self requestURLWithPath:url forceRequest:YES showHUD:YES];
    
    //    self.quiltView.bouncesZoom = NO;
}

- (void)loadInterstitiaAD
{
    if (_interstitialView && _interstitialView.hasBeenUsed) {
        _interstitialView.delegate = nil;
        _interstitialView = nil;
        _interstitialView = [[GADInterstitial alloc] init];
        _interstitialView.adUnitID = kAdmobInterstitialKey;
        _interstitialView.delegate = self;
        [_interstitialView loadRequest:[GADRequest request]];
    }
}

- (NSString*)builtURLWithPage:(NSUInteger)page catalog:(NSUInteger)catalog validKey:(NSString*)vaild
{
    _catalog = catalog;
    NSUInteger store = JW91SttorePlatform;
#ifdef APP_STORE
    store = JWAppStorePlatform;
#endif
    NSString *md5 = [[NSString stringWithFormat:@"%d%d%d%@",(int)_catalog,(int)_type,(int)_currentPage,kValidStr] MD5];
    NSString *requestURL = [kDailyContentURL stringByAppendingString:[NSString stringWithFormat:@"?catalog=%d&type=%d&page=%d&valid=%@&pageSize=%d&store=%d",(int)_catalog,(int)_type,(int)_currentPage,md5,kRequestPageSize,(int)store]];
    return requestURL;
}

- (void)handleResult:(NSDictionary*)result
{
    [self.contentTableView headerEndRefreshing];
    [self.contentTableView footerEndRefreshing];
    NSLog(@"result = %@",result);
    if ([[result valueForKey:kCode] integerValue] == 0)
    {
        NSArray *array = [result valueForKey:kData];
        NSLog(@"count = %d",(int)[array count]);
        if (_isRefreshing) {
            if ([array count] > 0) {
                [_items removeAllObjects];
            }
        }
        [_items addObjectsFromArray:array];
        [self.contentTableView reloadData];
        if (_isRefreshing)
        {
            [self.contentTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    _isRequesting = NO;
    _isRefreshing = NO;
}

- (void)headerRereshing
{
    [super headerRereshing];
    NSString *url = [self builtURLWithPage:_currentPage catalog:_catalog validKey:kValidStr];
    [self requestURLWithPath:url forceRequest:YES showHUD:NO];
    
}

- (void)footerRereshing
{
    [super footerRereshing];
    NSLog(@"footerRereshing");
    NSString *url = [self builtURLWithPage:_currentPage catalog:_catalog validKey:kValidStr];
    [self requestURLWithPath:url forceRequest:YES showHUD:NO];
}

- (void)initAdmobAd
{
    //横幅
    CGPoint origin = CGPointMake(0.0,
                                 self.view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height-64-49);
    _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    //_adBannerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _adBannerView.adUnitID = kAdmobBannerKey;
    _adBannerView.delegate = self;
    _adBannerView.rootViewController = self;
    [self.view addSubview:_adBannerView];
    [_adBannerView loadRequest:[GADRequest request]];
    
    //插屏
    _interstitialView = [[GADInterstitial alloc] init];
    _interstitialView.adUnitID = kAdmobInterstitialKey;
    _interstitialView.delegate = self;
    [_interstitialView loadRequest:[GADRequest request]];
}

- (void)moviePlayerNotificationHandler:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:MPMoviePlayerPlaybackDidFinishNotification]) {
        NSNumber *reason =
        [notification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        if (reason != nil) {
            NSInteger reasonAsInteger = [reason integerValue];
            switch (reasonAsInteger){
                case MPMovieFinishReasonPlaybackEnded:{
                    /* The movie ended normally */
                    NSLog(@"The movie ended normally");
                    break; }
                case MPMovieFinishReasonPlaybackError:{
                    /* An error happened and the movie ended */
                    NSLog(@"An error happened and the movie ended");
                    break;
                }
                case MPMovieFinishReasonUserExited:{
                    /* The user exited the player */
                    NSLog(@"The user exited the player");
                    break;
                }
            }
            NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
        } /* if (reason != nil){ */
    }
    
}



- (void)showVideo {
    
//    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";             //分享内嵌文字
//    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
//    NSArray *snsPlatform = [NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToWechatFavorite,UMShareToEmail,UMShareToSms, nil];
//    //如果得到分享完成回调，需要设置delegate为self
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:kUmengKey shareText:shareText shareImage:shareImage shareToSnsNames:snsPlatform delegate:(id<UMSocialUIDelegate>)self];
//    return;
    NSURL *movieUrl = [NSURL URLWithString:@"http://pl.youku.com/playlist/m3u8?vid=200019946&type=flv&ep=diaVHECPVcoE4yPfjz8bbi3gfX4KXPwK9h%2BEiNtmBtQnSeG%2F&token=3190&ctype=12&ev=1&oip=2015647293&sid=441692344600712912995"];
    _player = [[JWMPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
    [self presentMoviePlayerViewControllerAnimated:_player];
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

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cellStr";
    JWImageTableViewCell *cell = (JWImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    if (cell == nil) {
        cell = [[JWImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    [cell initCellData:info];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 160.0f;
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    NSString *title = [info valueForKey:@"title"];
    float heigth = [[UtilManager shareManager] heightForText:title rectSize:CGSizeMake(self.view.frame.size.width, 1000) fontSize:kCellTitleFontSize];
    return heigth + 100 + 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self showVideo];
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    
    NSURL *movieUrl = [NSURL URLWithString:[info valueForKey:@"videoURL"]];
    movieUrl = [NSURL URLWithString:@"http://pl.youku.com/playlist/m3u8?vid=208711122&type=flv&ep=dyaVHUiLX8oC5SvXgT8bbnizciYOXPwK%2FhiEgNNgAtQmTOG%2F&token=2490&ctype=12&ev=1&oip=3707376978&sid=5417169420889129da6a1"];
    _player = [[JWMPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
    [self presentMoviePlayerViewControllerAnimated:_player];
    
//    NSURL *url = [NSURL URLWithString:[info valueForKey:@"webURL"]];
//    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
}

#pragma mark - UMSocialDataDelegate

- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response;
{
    
}

#pragma mark -
#pragma mark GADBannerViewDelegate

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
    NSLog(@"ad frame = %@",NSStringFromCGRect(adView.frame));
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
