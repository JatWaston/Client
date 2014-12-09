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

#import "VideoViewController.h"

#define kRequestPageSize 10


@interface RootViewController () <GADBannerViewDelegate,GADInterstitialDelegate,UIAlertViewDelegate>
{
    JWMPMoviePlayerViewController *_player;
    
    GADBannerView *_adBannerView;
    GADInterstitial *_interstitialView;
    
    NSUInteger _catalog;
    NSUInteger _type;
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
    }
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
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
//    float imgWidth = [[info valueForKey:@"coverImgWidth"] floatValue]/2.0f;
//    float imgHeight = [[info valueForKey:@"coverImgHeight"] floatValue]/2.0f;
//    if (imgWidth >= self.view.frame.size.width) {
//        float scale = imgWidth/imgHeight;
//        imgWidth = self.view.frame.size.width;
//        imgHeight = imgWidth/scale;
//    }
    float heigth = [[UtilManager shareManager] heightForText:title rectSize:CGSizeMake(self.view.frame.size.width - 135.0f, 1000) font:kCellTitleFont];
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

@end
