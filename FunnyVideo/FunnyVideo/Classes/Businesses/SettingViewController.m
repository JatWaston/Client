//
//  SettingViewController.m
//  TenTu
//
//  Created by JatWaston on 14-11-16.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "SettingViewController.h"
#import "UMFeedback.h"
#import "SDImageCache.h"

#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"

#import "SettingCell.h"
#import "UtilManager.h"
#import "Toast+UIView.h"

#import "JWVersionUpdateManager.h"

#import "GADBannerView.h"
#import "GADAdSize.h"

#define kRateiOSAppStoreURLFormate @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=951382676"
#define kRateiOS7AppStoreURLFormate @"itms-apps://itunes.apple.com/app/id951382676"

@interface SettingViewController() <GADBannerViewDelegate>
{
    GADBannerView *_adBannerView;
}

- (void)shareToFriends;
- (void)clearCache;
- (NSString*)cacheSize;
- (void)feedback;
- (void)checkVersionUpdate;
- (void)rateForApp;

@end

@implementation SettingViewController


- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_setting"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *shareToFriends = [NSDictionary dictionaryWithObjectsAndKeys:@"分享给朋友",kTitleKey,@"",kDescriptionKey, nil];
    
    NSDictionary *clearCashe = [NSDictionary dictionaryWithObjectsAndKeys:@"清除图片缓存",kTitleKey,[self cacheSize],kDescriptionKey, nil];
    NSDictionary *feedBack = [NSDictionary dictionaryWithObjectsAndKeys:@"反馈问题",kTitleKey,@"",kDescriptionKey, nil];
    NSString *ver = [NSString stringWithFormat:@"v%@",[[UtilManager shareManager] appVersion]];
    NSDictionary *version = [NSDictionary dictionaryWithObjectsAndKeys:@"检查更新",kTitleKey,ver,kDescriptionKey, nil];
    
#ifdef APP_STORE
    NSDictionary *rateApp = [NSDictionary dictionaryWithObjectsAndKeys:@"给我评分",kTitleKey,@"",kDescriptionKey, nil];
#endif
    
    
    
    
    NSArray *section0 = [NSArray arrayWithObjects:shareToFriends, nil];
    NSArray *section1 = [NSArray arrayWithObjects:clearCashe,feedBack,version, nil];
#ifdef APP_STORE
    NSArray *section2 = [NSArray arrayWithObjects:rateApp, nil];
#endif
    //[_items addObject:section0];
    [_items addObject:section1];
#ifdef APP_STORE
    [_items addObject:section2];
#endif
    [_items addObject:section0];
    [self.contentTableView reloadData];
    
    [self initAdmobAd];
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
//    _interstitialView = [[GADInterstitial alloc] init];
//    _interstitialView.adUnitID = kAdmobInterstitialKey;
//    _interstitialView.delegate = self;
//    [_interstitialView loadRequest:[GADRequest request]];
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.contentTableView) {
        SettingCell *cell = (SettingCell*)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell updateDescription:[self cacheSize]];
    }

}

- (void)shareToFriends
{
    NSString *shareText = @"我在AppStore发现了一个很搞笑的应用，分享给你，你快来下载啊！ http://app.91.com/Soft/Detail.aspx?Platform=iPhone&f_id=10476958";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"Icon"];          //分享内嵌图片
    NSArray *snsPlatform = [NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToWechatFavorite,UMShareToEmail,UMShareToSms, nil];
    //如果得到分享完成回调，需要设置delegate为self
    [UMSocialSnsService presentSnsIconSheetView:self appKey:kUmengKey shareText:shareText shareImage:shareImage shareToSnsNames:snsPlatform delegate:(id<UMSocialUIDelegate>)self];
    return;

}

- (void)clearCache
{
    NSString *size = [self cacheSize];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        SettingCell *cell = (SettingCell*)[self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell updateDescription:@"0K"];
        NSString *message = [NSString stringWithFormat:@"已为你清除%@空间",size];
        [self.view makeToast:message duration:0.2f position:@"bottom"];
    }];
}

- (NSString*)cacheSize
{
    int cacheSize = (int)[[SDImageCache sharedImageCache] getSize];
    NSLog(@"size = %d",cacheSize);
    if (cacheSize >= 1024*1024*1024.0f)
    {
        return [NSString stringWithFormat:@"%.1fG",cacheSize/(1024*1024*1024.0f)];
    }
    else if (cacheSize >= 1024*1024.0f)
    {
        return [NSString stringWithFormat:@"%.1fM",cacheSize/(1024*1024.0f)];
    }
    else if (cacheSize >= 1024.0f)
    {
        return [NSString stringWithFormat:@"%.1fK",cacheSize/1024.0f];
    }
    return [NSString stringWithFormat:@"%d Byte",cacheSize];
}

- (void)feedback
{
    NSLog(@"%s",__func__);
    [UMFeedback showFeedback:self withAppkey:kUmengKey];
}

- (void)checkVersionUpdate
{
    NSLog(@"%s",__func__);
    NSString *requestURL = [[UtilManager shareManager] addParamsForURL:kVersionUpdateURL];
    [[JWVersionUpdateManager defaultManager] checkVersionUpdate:requestURL requestComplete:^(NSData *data, NSError *error) {
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        NSLog(@"info = %@",info);
        [[JWVersionUpdateManager defaultManager] showUpdateAlertView:info];
    }];
}

- (void)rateForApp
{
    NSLog(@"%s",__func__);
    if (CURRENT_SYSTEM_VERSION >= 7.0f) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kRateiOS7AppStoreURLFormate]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kRateiOSAppStoreURLFormate]];
    }
    
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"sections = %d",(int)[_items count]);
    return [_items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_items objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cellStr";
    SettingCell *cell = (SettingCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    NSDictionary *info = [[_items objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    [cell updateData:info];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 1:
            switch ([indexPath row]) {
                case 0:
                    [self shareToFriends];
                    break;
                default:
                    break;
            }
            break;
        case 0:
            switch ([indexPath row]) {
                case 0:
                    [self clearCache];
                    break;
                case 1:
                    [self feedback];
                    break;
                case 2:
                    [self checkVersionUpdate];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch ([indexPath row]) {
                case 0:
                    [self rateForApp];
                default:
                    break;
            }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
