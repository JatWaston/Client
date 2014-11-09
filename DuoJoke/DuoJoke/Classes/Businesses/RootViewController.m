//
//  RootViewController.m
//  DuoJoke
//
//  Created by JatWaston on 14-10-14.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "RootViewController.h"
#import "TMPhotoQuiltViewCell.h"
#import "TMQuiltView.h"
#import "UIScrollView+MJRefresh.h"
#import "JWNavigationController.h"
#import "JWNetworking.h"
#import "UtilManager.h"
#import "SVProgressHUD.h"
#import "NSString+MD5.h"
#import "JWCacheManager.h"
#import "UIImageView+WebCache.h"

#import "MBProgressHUD+Add.h"

#import "GADBannerView.h"
#import "GADAdSize.h"
#import "GADInterstitial.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "JWPhotoBrowserViewController.h"

#import "FMDatabase.h"

#import "UIImage+Util.h"
#import "UIColor+Colours.h"

#define kCoverImageKey @"cover_image"
#define kTitleKey      @"title"
#define kHeightKey     @"image_height"

#define kRequestPageSize 10
#define kDefaultCatalog 1000

const NSInteger kNumberOfCells = 100;

@interface RootViewController () <GADBannerViewDelegate,GADInterstitialDelegate,JWPhotoBrowserDelegate>
{
    BOOL _hasAddCache;
    NSUInteger _catalog;
    GADBannerView *_adBannerView;
    GADInterstitial *_interstitialView;
    FMDatabase *_db;
    UIImage *_placeholderImage;
    NSMutableArray *_placeImages;
}

- (NSString*)builtURLWithPage:(NSUInteger)page catalog:(NSUInteger)catalog validKey:(NSString*)vaild;
- (void)handleSelectAtIndexPath:(NSIndexPath *)indexPath;
- (void)createDatabase;
//显示插屏广告
- (void)showInterstitialAd;

@end

@implementation RootViewController

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
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _catalog = kDefaultCatalog;
    _currentPage = 1;
    _isRefreshing = YES;
    
    self.title = @"每日美女";
    [self loadDataFromCache];

    [self createPlaceImages];
    [self requestWithCatalog:_catalog];
//    NSString *requestURL = [self builtURLWithPage:_currentPage catalog:_catalog validKey:kValidStr];
//    [self requestURLWithPath:requestURL forceRequest:YES showHUD:YES];
    //[self.quiltView reloadData];
    
    [self addLeftCatalogMenu];
    [self initAdmobAd];
    [self createDatabase];
}

- (void)createPlaceImages
{
    _placeImages = [[NSMutableArray alloc] init];
    UIImage *placeImage = [UIImage imageWithColor:[UIColor snowColor] andSize:CGSizeMake(1, 1)];
    [_placeImages addObject:placeImage];
    placeImage = [UIImage imageWithColor:[UIColor turquoiseColor] andSize:CGSizeMake(1, 1)];
    [_placeImages addObject:placeImage];
    placeImage = [UIImage imageWithColor:[UIColor babyBlueColor] andSize:CGSizeMake(1, 1)];
    [_placeImages addObject:placeImage];
    NSLog(@"_placeImages = %@",_placeImages);
}

- (void)createDatabase
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"joke.db"];
    _db = [FMDatabase databaseWithPath:dbPath];
    if ([_db open])
    {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS `browseHistory` (`id` VARCHAR(33) NOT NULL,`image_id` VARCHAR(33) NOT NULL,`image_height` INT,`image_width` INT, `descript` VARCHAR(128),`image_url` VARCHAR(128) NOT NULL,PRIMARY KEY(`image_id`));";
        BOOL res = [_db executeUpdate:sql];
        if (!res)
        {
            NSLog(@"create table error.");
        }
    }
}

- (void)initAdmobAd
{
//    //横幅
//    CGPoint origin = CGPointMake(0.0,
//                                 self.view.frame.size.height -
//                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height);
//    _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
//    //_adBannerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
//    _adBannerView.adUnitID = kAdmobBannerKey;
//    _adBannerView.delegate = self;
//    _adBannerView.rootViewController = self;
//    [self.view addSubview:_adBannerView];
//    [_adBannerView loadRequest:[GADRequest request]];
    
    //插屏
    _interstitialView = [[GADInterstitial alloc] init];
    _interstitialView.adUnitID = kAdmobInterstitialKey;
    _interstitialView.delegate = self;
    [_interstitialView loadRequest:[GADRequest request]];
}

- (NSString*)builtURLWithPage:(NSUInteger)page catalog:(NSUInteger)catalog validKey:(NSString*)vaild
{
    _catalog = catalog;
    NSString *md5 = [[NSString stringWithFormat:@"%d%d%@",(int)_catalog,(int)_currentPage,kValidStr] MD5];
    NSString *requestURL = [kJokeCatalogURL stringByAppendingString:[NSString stringWithFormat:@"?catalog=%d&page=%d&valid=%@&pageSize=%d",(int)_catalog,(int)_currentPage,md5,kRequestPageSize]];
    return requestURL;
}

- (void)requestWithCatalog:(NSUInteger)catalog
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self loadInterstitiaAD];
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

- (void)loadDataFromCache
{
    _isRefreshing = YES;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [JWCacheManager readDictonary:kCatalogDetailCachePath key:kCacheRootKey dictionary:resultDic];
    [self handleResult:resultDic];
}

- (void)handleResult:(NSDictionary*)result
{
    [self.quiltView headerEndRefreshing];
    [self.quiltView footerEndRefreshing];
    NSLog(@"result = %@",result);
    if ([[result valueForKey:kCode] integerValue] == 0)
    {
        if (_catalog == kDefaultCatalog) {
            [JWCacheManager writeDictionaryWithContent:result name:kCatalogDetailCachePath key:kCacheRootKey];
        }
        
        NSArray *array = [result valueForKey:kData];
        NSLog(@"count = %d",(int)[array count]);
        if (_isRefreshing) {
            if ([array count] > 0) {
                [self.items removeAllObjects];
            }
        }
        [self.items addObjectsFromArray:array];
        [self.quiltView reloadData];
        if (_isRefreshing)
        {
            [self.quiltView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    _isRequesting = NO;
    _isRefreshing = NO;
}

- (void)addLeftCatalogMenu
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_catalog_icon"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_catalog_icon"] forState:UIControlStateSelected];
    [button addTarget:self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 34, 34);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)headerRereshing
{
    [super headerRereshing];
    NSString *url = [self builtURLWithPage:_currentPage catalog:_catalog validKey:kValidStr];
    [self requestURLWithPath:url forceRequest:YES showHUD:YES];
    
}

- (void)footerRereshing
{
    [super footerRereshing];
    NSLog(@"footerRereshing");
    NSString *url = [self builtURLWithPage:_currentPage catalog:_catalog validKey:kValidStr];
    [self requestURLWithPath:url forceRequest:YES showHUD:YES];
}

- (NSArray*)resultFromDatabaseWithID:(NSString*)detailID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM browseHistory WHERE id = '%@'",detailID];
    FMResultSet *rs = [_db executeQuery:sql];
    NSMutableArray *resultSet = [[NSMutableArray alloc] init];
    while ([rs next]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[rs stringForColumn:@"image_id"] forKey:@"image_id"];
        [dic setObject:[rs stringForColumn:@"id"] forKey:@"id"];
        [dic setObject:[NSNumber numberWithInt:[rs intForColumn:@"image_height"]] forKey:@"image_height"];
        [dic setObject:[NSNumber numberWithInt:[rs intForColumn:@"image_width"]] forKey:@"image_width"];
        [dic setObject:[rs stringForColumn:@"image_url"] forKey:@"image_url"];
        [dic setObject:[rs stringForColumn:@"descript"] forKey:@"descript"];
        [resultSet addObject:dic];
    }
    [rs close];
    return resultSet;
}

- (void)handleSelectAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showMessag:@"获取数据中" toView:self.view];
    self.view.userInteractionEnabled = NO; //避免再次点击
    NSDictionary *info = [self.items objectAtIndex:[indexPath row]];
    NSString *detailID = [info valueForKey:@"id"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *images = [self resultFromDatabaseWithID:detailID];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (images && [images count] > 0) {
                int count = (int)[images count];
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
                for (int i = 0; i < count; i++) {
                    
                    NSDictionary *info = [images objectAtIndex:i];
                    NSString *image_url = [info valueForKey:@"image_url"];
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.description = [info valueForKey:@"descript"];
                    photo.url = [NSURL URLWithString:image_url]; // 图片路径
                    photo.srcImageView = ((TMPhotoQuiltViewCell*)[self.quiltView cellAtIndexPath:indexPath]).photoView; // 来源于哪个UIImageView,动画开始和结束要返回的位置
                    //NSLog(@"photo.srcImageView.frame = %@",NSStringFromCGRect(photo.srcImageView.frame));
                    [photos addObject:photo];
                }
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                JWPhotoBrowserViewController *controller = [[JWPhotoBrowserViewController alloc] init];
                controller.currentPhotoIndex = 0;
                controller.delegate = self;
                controller.photos = photos;//[NSMutableArray arrayWithObjects:photos[0], nil];
                [controller showBrowser];
                self.view.userInteractionEnabled = YES; //避免再次点击
            } else {
                NSString *valid = [[NSString stringWithFormat:@"%d%@%@",(int)_catalog,detailID,kValidStr] MD5];
                JWNetworking *netRequest = [[JWNetworking alloc] init];
                NSString *url = [NSString stringWithFormat:@"%@?catalog=%d&id=%@&valid=%@",kJokeImageDetailURL,(int)_catalog,detailID,valid];
                NSLog(@"url = %@",url);
                [netRequest requestWithURL:url requestMethod:JWRequestMethodGet params:nil requestComplete:^(NSData *data, NSError *error) {
                    
                    if (error) {
                        self.view.userInteractionEnabled = YES;
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [MBProgressHUD showError:@"获取失败" toView:self.view];
                    } else {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                        //NSLog(@"result = %@",result);
                        NSArray *images = [result valueForKey:@"data"];
                        if (images && [images count] > 0) {
                            int count = (int)[images count];
                            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
                            for (int i = 0; i < count; i++) {
                                
                                NSDictionary *info = [images objectAtIndex:i];
                                NSString *image_url = [info valueForKey:@"image_url"];
                                MJPhoto *photo = [[MJPhoto alloc] init];
                                photo.description = [info valueForKey:@"descript"];
                                photo.url = [NSURL URLWithString:image_url]; // 图片路径
                                photo.srcImageView = ((TMPhotoQuiltViewCell*)[self.quiltView cellAtIndexPath:indexPath]).photoView; // 来源于哪个UIImageView,动画开始和结束要返回的位置
                                //NSLog(@"photo.srcImageView.frame = %@",NSStringFromCGRect(photo.srcImageView.frame));
                                [photos addObject:photo];
                                NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO browseHistory (id,image_id,image_height,image_width,descript,image_url) VALUES ('%@','%@',%@,%@,'%@','%@')",[info valueForKey:@"id"],[info valueForKey:@"image_id"],[info valueForKey:@"image_height"],[info valueForKey:@"image_width"],[info valueForKey:@"descript"],[info valueForKey:@"image_url"]];
                                NSLog(@"insertSql = %@",insertSql);
                                BOOL res = [_db executeUpdate:insertSql];
                                if (!res)
                                {
                                    NSLog(@"插入失败");
                                }
                                
                            }
                            
                            //                //2.显示相册
                            //                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                            //                browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
                            //                browser.photos = photos; // 设置所有的图片
                            //                [browser show];
                            
                            
                            JWPhotoBrowserViewController *controller = [[JWPhotoBrowserViewController alloc] init];
                            controller.currentPhotoIndex = 0;
                            controller.delegate = self;
                            controller.photos = photos;//[NSMutableArray arrayWithObjects:photos[0], nil];
                            [controller showBrowser];
                        } else {
                            [MBProgressHUD showError:@"获取失败" toView:self.view];
                        }
                        self.view.userInteractionEnabled = YES;
                    }
                    
                }];
            }
        });
    });
}

- (void)showInterstitialAd
{
    if (_interstitialView.isReady && _interstitialView.hasBeenUsed == NO) {
        [_interstitialView presentFromRootViewController:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JWPhotoBrowserDelegate

- (void)photoBrowserDidEndZoomIn
{
    [self showInterstitialAd];
}

#pragma mark -
#pragma mark TMQuiltViewDataSource


- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath
{
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell*)[self.quiltView cellAtIndexPath:indexPath];
    return cell.photoView.image;
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    return [self.items count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell)
    {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    NSDictionary *dic = [self.items objectAtIndex:[indexPath row]];
    NSString *imageURL = [dic valueForKey:kCoverImageKey];
//    UIImage *placeholderImage = [UIImage imageWithColor:[UIColor antiqueWhiteColor] andSize:cell.photoView.frame.size];
    int count = (int)[_placeImages count];
    if (count) {
        _placeholderImage = _placeImages[arc4random() % count];
    }
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:_placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image.images) {
            cell.photoView.image = image.images[0];
            
        }
    }];
    cell.titleLabel.text = [dic valueForKey:kTitleKey];
    return cell;
}


#pragma mark -
#pragma mark TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return 2;
}

- (CGFloat)quiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType
{
    return 2.0f;
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.items objectAtIndex:[indexPath row]];
    //NSLog(@"height = %f",[self imageAtIndexPath:indexPath].size.height / [self quiltViewNumberOfColumns:quiltView]);
    return [[dic valueForKey:kHeightKey] intValue]*1.0f / [self quiltViewNumberOfColumns:quiltView];
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index:%d be selected.",(int)[indexPath row]);
    [self handleSelectAtIndexPath:indexPath];
    
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
//    [ad presentFromRootViewController:self];
}


- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"GADInterstitial error:%@",[error localizedFailureReason]);
}

@end
