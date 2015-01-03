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

#import "JWCacheManager.h"
#import "JWWebViewController.h"
#import "JWReportManager.h"

#import "JWToolBarView.h"

#define kRequestPageSize 10


@interface RootViewController () <GADBannerViewDelegate,GADInterstitialDelegate,UIAlertViewDelegate,JWToolBarDelegate>
{
    JWMPMoviePlayerViewController *_player;
    
    GADBannerView *_adBannerView;
    GADInterstitial *_interstitialView;
    
    NSUInteger _catalog;
    NSUInteger _type;
    
    NSUInteger _playVideoCount;
}

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

- (void)loadDataFromCache;
- (void)initAdmobAd;
- (void)showPlayVideoErrorAlert;

@end

@implementation RootViewController

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"视频";
        self.tabBarItem.image = [UIImage imageNamed:@"icon_video"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playVideoCount = 0;
    _catalog = 8000;
    _type = 8001;
    _currentPage = 1;
    _isRefreshing = YES;

  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerNotificationHandler:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil]; //检测播放结束的原因
    self.contentTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kAdBananerHeight);
    self.contentTableView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initAdmobAd];
    
    [self followRollingScrollView:self.contentTableView];
    [self loadDataFromCache];
    [self requestWithCatalog:_catalog];
    
}

//- (void)showVideo {
//    VideoViewController *controller = [[VideoViewController alloc] init];
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
//}

- (void)loadDataFromCache
{
    _isRefreshing = YES;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [JWCacheManager readDictonary:kVideoContentCachePath key:kCacheRootKey dictionary:resultDic];
    [self handleResult:resultDic];
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
    JWStorePlatform store = [[UtilManager shareManager] storePlatform];
    NSString *version = [[UtilManager shareManager] appVersion];
    NSString *md5 = [[NSString stringWithFormat:@"%@%d%d%@",version,(int)store,(int)_currentPage,kValidStr] MD5];
    NSString *requestURL = [kDailyContentURL stringByAppendingString:[NSString stringWithFormat:@"?page=%d&valid=%@&pageSize=%d&content=%d",(int)_currentPage,md5,kRequestPageSize,(int)JWVideoType]];
    
    requestURL = [[UtilManager shareManager] addParamsForURL:requestURL];
    NSLog(@"url = %@",requestURL);
    
    return requestURL;
}

- (void)handleResult:(NSDictionary*)result
{
    [self.contentTableView headerEndRefreshing];
    [self.contentTableView footerEndRefreshing];
    NSLog(@"result = %@",result);
    if (result && [[result valueForKey:kCode] integerValue] == 0)
    {
        NSArray *array = [result valueForKey:kData];
        if (array && _isRefreshing) {
            [JWCacheManager writeDictionaryWithContent:result name:kVideoContentCachePath key:kCacheRootKey];
        }
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
#ifdef kShowAd
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
#endif
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
                    break;
                }
                case MPMovieFinishReasonPlaybackError:{
                    /* An error happened and the movie ended */
                    NSLog(@"An error happened and the movie ended");
                    [self showPlayVideoErrorAlert];
                    break;
                }
                case MPMovieFinishReasonUserExited:{
                    /* The user exited the player */
                    NSLog(@"The user exited the player");
                    ++_playVideoCount;
                    if (_interstitialView && _interstitialView.isReady && _playVideoCount >= 2) {
                        _playVideoCount = 0;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [_interstitialView presentFromRootViewController:self];
                        });
                        
                    }
                    break;
                }
            }
            NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
        } /* if (reason != nil){ */
    }
    
}

- (void)showPlayVideoErrorAlert {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"当前视频播放出错，是否在网页中播放该视频？"
                                                           delegate:self
                                                  cancelButtonTitle:@"否"
                                                  otherButtonTitles:@"播放", nil];
        [alertView show];
    });

}



//- (void)showVideo {
//    
//    NSURL *movieUrl = [NSURL URLWithString:@"http://pl.youku.com/playlist/m3u8?vid=209373014&type=flv&ep=eiaVHUyPXswC4STagD8bNS2wJyEIXPwK%2FxyCgtJjBNQgTuC2&token=4689&ctype=12&ev=1&oip=463169121&sid=841752822475812b1bcf7"];
//    _player = [[JWMPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
//    [self presentMoviePlayerViewControllerAnimated:_player];
//}

- (void)shareToFriends:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [self.contentTableView cellForRowAtIndexPath:indexPath];
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    //这边的链接适用于sina微博，QQ空间点击url链接会跳转到这里指定的地址，点击整个会跳转到开头设定的地址
    NSString *shareText = [NSString stringWithFormat:@"%@ %@",[info valueForKey:@"title"],[info valueForKey:@"webURL"]];             //分享内嵌文字
    UIImage *shareImage = [(JWImageTableViewCell*)cell videoImage];          //分享内嵌图片
    if (shareImage == nil) {
        shareImage = [UIImage imageNamed:@"Icon"];
    }
    NSArray *snsPlatform = [NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToWechatFavorite,UMShareToEmail,UMShareToSms, nil];
    //如果得到分享完成回调，需要设置delegate为self
    [UMSocialSnsService presentSnsIconSheetView:self appKey:kUmengKey shareText:shareText shareImage:shareImage shareToSnsNames:snsPlatform delegate:(id<UMSocialUIDelegate>)self];
    
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
    if (cell == nil) {
        cell = [[JWImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        [cell registerToolBarDelegate:self];
    }
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    [cell initCellData:info indexPath:indexPath];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 160.0f;
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    NSString *title = [info valueForKey:@"title"];
//    float imgWidth = [[info valueForKey:@"coverImgWidth"] floatValue]/2.0f;
//    float imgHeight = [[info valueForKey:@"coverImgHeight"] floatValue]/2.0f;
//    if (imgWidth >= self.view.frame.size.width) {
//        float scale = imgWidth/imgHeight;
//        imgWidth = self.view.frame.size.width;
//        imgHeight = imgWidth/scale;
//    }
    float heigth = [[UtilManager shareManager] heightForText:title rectSize:CGSizeMake(self.view.frame.size.width - 135.0f, MAXFLOAT) font:kCellTitleFont];
    if (heigth < 85.0f) {
        heigth = 85.0f;
    }
    return heigth + 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self showVideo];
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    
    [[JWReportManager defaultManager] updatePlayCountWithRecord:[info valueForKey:@"id"] contentType:JWVideoType];
    
    NSString *url = [info valueForKey:@"videoURL"];
//    url = @"http://pl.youku.com/playlist/m3u8?vid=209373014&type=flv&ep=eiaVHUyPXswC4STagD8bNS2wJyEIXPwK%2FxyCgtJjBNQgTuC2&token=4689&ctype=12&ev=1&oip=463169121&sid=84175";
    NSURL *movieUrl = [NSURL URLWithString:url];
    //movieUrl = nil;
    if (movieUrl == nil || url.length <= 0) {
        NSURL *url = [NSURL URLWithString:[info valueForKey:@"webURL"]];
        //url = [NSURL URLWithString:@"http://v.youku.com/v_show/id_XNDU1NjkyNDY4.html"];
        //JWWebViewController *webViewController = [[JWWebViewController alloc] initWithURL:url];
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
        //[self.navigationController pushViewController:webViewController animated:YES];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
        
    } else {
//        movieUrl = [NSURL URLWithString:@"http://pl.youku.com/playlist/m3u8?vid=209373014&type=flv&ep=eiaVHUyPXswC4STagD8bNS2wJyEIXPwK%2FxyCgtJjBNQgTuC2&token=4689&ctype=12&ev=1&oip=463169121&sid=841752822475812b1bcf7"];
        _player = [[JWMPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
        [self presentMoviePlayerViewControllerAnimated:_player];
    }
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
    //[ad presentFromRootViewController:self];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self loadInterstitiaAD];
}


- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"GADInterstitial error:%@",[error localizedFailureReason]);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSDictionary *info = [_items objectAtIndex:[self.selectIndexPath row]];
        NSURL *url = [NSURL URLWithString:[info valueForKey:@"webURL"]];
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
    }
    
}

#pragma mark - JWToolBarDelegate

- (void)didSelectShare:(JWToolBarView*)toolBarView {
    [self shareToFriends:toolBarView.indexPath];
}

@end
