//
//  ImageViewController.m
//  FunnyVideo
//
//  Created by zhengzhilin on 14/12/22.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "ImageViewController.h"
#import "FunnyImageTableViewCell.h"

#import "GADBannerView.h"
#import "GADAdSize.h"
#import "GADInterstitial.h"

#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"

#import "NSString+MD5.h"
#import "MBProgressHUD+Add.h"

#import "UtilManager.h"
#import "JWCacheManager.h"
#import "JWToolBarView.h"

#define kRequestPageSize 10

@interface ImageViewController () <GADBannerViewDelegate,GADInterstitialDelegate,JWToolBarDelegate> {
    NSUInteger _requestCount;
    GADBannerView *_adBannerView;
    GADInterstitial *_interstitialView;
    NSUInteger _catalog;
}

@end

@implementation ImageViewController

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"图片";
        self.tabBarItem.image = [UIImage imageNamed:@"icon_image1"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _requestCount = 0;
    _currentPage = 1;
    _isRefreshing = YES;
    
    self.contentTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kAdBananerHeight);
    self.contentTableView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initAdmobAd];
    
    
    [self followRollingScrollView:self.contentTableView];
    [self loadDataFromCache];
    [self requestWithCatalog:0];
}

- (void)loadDataFromCache
{
    _isRefreshing = YES;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [JWCacheManager readDictonary:kImageContentCachePath key:kCacheRootKey dictionary:resultDic];
    [self handleResult:resultDic];
}

- (void)requestWithCatalog:(NSUInteger)catalog
{
    _catalog = catalog;
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
    NSUInteger store = JW91SttorePlatform;
#ifdef APP_STORE
    store = JWAppStorePlatform;
#endif
    NSString *version = [[UtilManager shareManager] appVersion];
    NSString *devicePlatform = [[UtilManager shareManager] devicePlatform];
    NSString *udid = [[UtilManager shareManager] deviceUDID];
    NSString *md5 = [[NSString stringWithFormat:@"%@%d%d%@",version,(int)store,(int)_currentPage,kValidStr] MD5];
    NSString *requestURL = [kVideoDailyContentURL stringByAppendingString:[NSString stringWithFormat:@"?version=%@&device=%@&udid=%@&page=%d&valid=%@&pageSize=%d&store=%d&content=%d",version,devicePlatform,udid,(int)_currentPage,md5,kRequestPageSize,(int)store,(int)JWImageTyp]];
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
            [JWCacheManager writeDictionaryWithContent:result name:kImageContentCachePath key:kCacheRootKey];
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

- (void)shareToFriends:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [self.contentTableView cellForRowAtIndexPath:indexPath];
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    //这边的链接适用于sina微博，QQ空间点击url链接会跳转到这里指定的地址，点击整个会跳转到开头设定的地址
    NSString *shareText = [NSString stringWithFormat:@"%@ %@",[info valueForKey:@"title"],kShareURL];             //分享内嵌文字
    UIImage *shareImage = [(FunnyImageTableViewCell*)cell funnyImage];          //分享内嵌图片
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
    FunnyImageTableViewCell *cell = (FunnyImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[FunnyImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
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
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    float viewWidth = self.view.frame.size.width-20;
    float imgWidth = [[info valueForKey:@"image_width"] floatValue];
    float imgHeight = [[info valueForKey:@"image_height"] floatValue];
    if (imgWidth >= viewWidth) {
        float scale = viewWidth / imgWidth*1.0f;
        imgWidth = viewWidth;
        imgHeight = imgHeight*scale;
    }
    NSString *content = [info valueForKey:@"content"];
    CGSize titleSize = [content sizeWithFont:kCellTitleFont constrainedToSize:CGSizeMake(self.view.frame.size.width-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //    float heigth = [[UtilManager shareManager] heightForText:content rectSize:CGSizeMake(self.view.frame.size.width - 10.0f, MAXFLOAT) font:kCellTitleFont];
    return titleSize.height + imgHeight + 20.0f + 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - JWToolBarDelegate

- (void)didSelectShare:(JWToolBarView*)toolBarView {
    [self shareToFriends:toolBarView.indexPath];
}

@end
