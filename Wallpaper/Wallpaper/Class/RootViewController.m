//
//  RootViewController.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-11.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "RootViewController.h"
#import "UIViewController+RESideMenu.h"
#import "UIButton+Bootstrap.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+Compatibility.h"
#import "WallpaperPageView.h"
#import "UIScrollView+MJRefresh.h"
#import "WallpaperImageCell.h"
#import "JWNetworking.h"
#import "NSString+MD5.h"
#import "WallpaperDetailViewController.h"
#import "Toast+UIView.h"
#import "GADBannerView.h"
#import "GADAdSize.h"
#import "GADInterstitial.h"
#import "JWNavigationController.h"
#import "JWCacheManager.h"
#import "UtilManager.h"
#import "SVProgressHUD.h"



#define kPaddingWidth 20

#define kWallpaperCatalog 2000
#define kWallpaperType 2001

@interface RootViewController ()
{
    UIScrollView *_scrollView;
    UITableView *_contentTableView;
    
    NSMutableArray *_item;
    JWNetworking *_netWorking;
    NSUInteger _page;
    BOOL _isRefreshing;
    BOOL _isRequesting;
//    BOOL _hasAddFooterView;
    BOOL _hasAddCache;
    
    NSUInteger _catalog;
    NSUInteger _type;
    GADBannerView *_adBannerView;
    GADInterstitial *_interstitialView;
    
    BOOL _isiPhone5Device;
    NSUInteger _detailCount;
}

@property (nonatomic, strong) NSMutableArray *item;

@end

@implementation RootViewController 
@synthesize item = _item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setLayoutCompatibleWithLowerVersion];
    
    _hasAddCache = NO;
    _detailCount = 0;
    
    _isiPhone5Device = [[UtilManager shareManager] isiPhone5];
    
    
    self.title = @"最热排行";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addLeftCatalogMenu];
    [self addRightSettingMenu];
    
    //self.view.clipsToBounds = YES;
    
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_contentTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:_contentTableView];
    //[self.view makeToast:@"亲，已经没有更多页了"];
    
    self.item = [[NSMutableArray alloc] init];
    [self loadDataFromCache];
    
    
    _page = 1;
    _catalog = 100;
    _type = 101;
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [self request];
    
    [self initAdmobAd];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if (_interstitialView)
//    {
//        [_interstitialView loadRequest:[GADRequest request]];
//    }
//    
//}

- (void)loadDataFromCache
{
    _isRefreshing = YES;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [JWCacheManager readDictonary:kTypeCachePath key:kCacheRootKey dictionary:resultDic];
    [self handleResult:resultDic];
}

- (void)initAdmobAd
{
    //横幅
    CGPoint origin = CGPointMake(0.0,
                                 self.view.frame.size.height - 64 -
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

- (void)addLeftCatalogMenu
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_catalog_icon"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_catalog_icon"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 34, 34);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)addRightSettingMenu
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_setting_icon"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_setting_icon"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(presentRightMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 28, 28);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;
}

- (void)request
{
    NSString *md5 = [[NSString stringWithFormat:@"%lu%lu%d%@",(unsigned long)_catalog,(unsigned long)_type,(int)_page,kValidStr] MD5];
    NSString *requestURL = [kWallpaperTypeURL stringByAppendingString:[NSString stringWithFormat:@"?catalog=%lu&type=%lu&page=%d&valid=%@&pageSize=30",(unsigned long)_catalog,(unsigned long)_type,(int)_page,md5]];
    
    requestURL = [[UtilManager shareManager] additionlParamURL:requestURL];
    
    JWNetworking *netWorking = [[JWNetworking alloc] init];
    [netWorking requestWithURL:requestURL requestMethod:JWRequestMethodGet params:nil requestComplete:^(NSData *data, NSError *error) {
        [SVProgressHUD dismiss];
        if (error)
        {
            NSLog(@"error=%@",[error localizedDescription]);
        }
        else
        {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            if (_isRefreshing)
            {
                [self.item removeAllObjects];
            }
            if (_hasAddCache == NO)
            {
                _hasAddCache = YES;
                [JWCacheManager writeDictionaryWithContent:result name:kTypeCachePath key:kCacheRootKey];
            }
            
            [self handleResult:result];
        }
        if (_isRefreshing)
        {
            if ([self.item count] > 0)
            {
                [_contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }

//            [_contentTableView scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
            [_contentTableView headerEndRefreshing];
        }
        
        if (_isRequesting)
        {
            [_contentTableView footerEndRefreshing];
        }
        _isRefreshing = NO;
        _isRequesting = NO;
    }];
    
}

- (void)requestDataWithCatalog:(NSUInteger)catalog type:(NSUInteger)type
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    _catalog = catalog;
    _type = type;
    [self.item removeAllObjects];
    [_contentTableView reloadData];
    [self headerRereshing];
}

- (void)handleResult:(NSDictionary*)result
{
    //NSLog(@"result = %@",result);
    if ([[result valueForKey:kCode] integerValue] == 0)
    {
        NSArray *array = [result valueForKey:kData];
        NSLog(@"count = %d",(int)[array count]);
        [self.item addObjectsFromArray:array];
        [_contentTableView reloadData];
    }
}

- (void)headerRereshing
{
    _page = 1;
    _isRefreshing = YES;
    _isRequesting = YES;
    [self request];
}

- (void)footerRereshing
{
    if (_isRefreshing)
    {
        [_contentTableView footerEndRefreshing];
        return;
    }
    _page++;
    _isRefreshing = NO;
    _isRequesting = YES;
    [self request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil([self.item count]/3.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cell";
    
    WallpaperImageCell *cell = (WallpaperImageCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil)
    {
        cell = [[WallpaperImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSMutableArray *array = [NSMutableArray array];
    int count = (int)[self.item count];
//    if ([indexPath row]*3 < [self.item count])
    {
        if ([indexPath row]*3 < count)
        {
            [array addObject:[self.item objectAtIndex:[indexPath row]*3]];
        }
        
        if ([indexPath row]*3+1 < count)
        {
            [array addObject:[self.item objectAtIndex:[indexPath row]*3+1]];
        }
        
        if ([indexPath row]*3+2 < count)
        {
            [array addObject:[self.item objectAtIndex:[indexPath row]*3+2]];
        }
        
        
        
    }
    [cell setImageCell:array cellRow:[indexPath row]];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.item objectAtIndex:[indexPath row]]];
    return cell;
    
}

#pragma mark - 
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isiPhone5Device)
    {
        return 183.0f;
    }
    return 155.0f;
}

#pragma mark -
#pragma mark WallpaperThumbDelegate

- (void)didSelectThumbImageView:(WallpaperThumbImageView*)view
{
    _detailCount++;
    NSLog(@"row = %d index = %d downloadURL = %@",(int)view.row,(int)(view.index),view.downloadURL);
    WallpaperDetailViewController *vc = [[WallpaperDetailViewController alloc] init];
    if (_detailCount >= 5)
    {
        _detailCount = 0;
        vc.showInterstitialAd = YES;
    }
    vc.item = self.item;
    vc.currentPage = view.row*3+view.index;
    vc.title = [NSString stringWithFormat:@"(%d/%d)",(int)(vc.currentPage+1),(int)[vc.item count]];
    [self.navigationController pushViewController:vc animated:YES];
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
