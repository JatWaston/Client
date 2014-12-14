//
//  JokeViewController.m
//  FunnyVideo
//
//  Created by JatWaston on 14-12-2.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JokeViewController.h"

#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "JokeTableViewCell.h"

#import "UIColor+Colours.h"

#import "GADBannerView.h"
#import "GADAdSize.h"
#import "GADInterstitial.h"

#import "NSString+MD5.h"
#import "MBProgressHUD+Add.h"

#import "UtilManager.h"
#import "JWCacheManager.h"

#define kRequestPageSize 10

@interface JokeViewController () <GADBannerViewDelegate,GADInterstitialDelegate>
{
    GADBannerView *_adBannerView;
    GADInterstitial *_interstitialView;
    
    NSUInteger _catalog;
    NSUInteger _type;
    
    NSUInteger _requestCount;
}

- (void)initAdmobAd;
- (void)loadDataFromCache;

@end

@implementation JokeViewController

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"搞笑段子";
        self.tabBarItem.image = [UIImage imageNamed:@"icon_joke"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requestCount = 0;
    _catalog = 8000;
    _type = 8001;
    _currentPage = 1;
    _isRefreshing = YES;
    
    self.contentTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kAdBananerHeight);
    self.contentTableView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initAdmobAd];
    
    
    [self followRollingScrollView:self.contentTableView];
    [self loadDataFromCache];
    [self requestWithCatalog:_catalog];
    
}

- (void)loadDataFromCache
{
    _isRefreshing = YES;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [JWCacheManager readDictonary:kJokeContentCachePath key:kCacheRootKey dictionary:resultDic];
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
    NSUInteger store = JW91SttorePlatform;
#ifdef APP_STORE
    store = JWAppStorePlatform;
#endif
    NSString *version = [[UtilManager shareManager] appVersion];
    NSString *devicePlatform = [[UtilManager shareManager] devicePlatform];
    NSString *udid = [[UtilManager shareManager] deviceUDID];
    NSString *md5 = [[NSString stringWithFormat:@"%@%d%d%@",version,(int)store,(int)_currentPage,kValidStr] MD5];
    NSString *requestURL = [kDailyContentURL stringByAppendingString:[NSString stringWithFormat:@"?version=%@&device=%@&udid=%@&page=%d&valid=%@&pageSize=%d&store=%d&content=%d",version,devicePlatform,udid,(int)_currentPage,md5,kRequestPageSize,(int)store,(int)JWJokeType]];
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
            [JWCacheManager writeDictionaryWithContent:result name:kJokeContentCachePath key:kCacheRootKey];
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
    _requestCount++;
    [self showInterstitialAd];
    [super footerRereshing];
    NSLog(@"footerRereshing");
    NSString *url = [self builtURLWithPage:_currentPage catalog:_catalog validKey:kValidStr];
    [self requestURLWithPath:url forceRequest:YES showHUD:NO];
}

- (void)showInterstitialAd {
    if (_requestCount >= 4 && _interstitialView && _interstitialView.isReady) {
        _requestCount = 0;
        [_interstitialView presentFromRootViewController:self];
        [self loadInterstitiaAD];
    }
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
    JokeTableViewCell *cell = (JokeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[JokeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    [cell initCellData:info];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    NSString *content = [info valueForKey:@"content"];
    CGSize titleSize = [content sizeWithFont:kCellTitleFont constrainedToSize:CGSizeMake(self.view.frame.size.width-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//    float heigth = [[UtilManager shareManager] heightForText:content rectSize:CGSizeMake(self.view.frame.size.width - 10.0f, MAXFLOAT) font:kCellTitleFont];
    return titleSize.height + 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
