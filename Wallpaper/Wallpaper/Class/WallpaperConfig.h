//
//  WallpaperConfig.h
//  Wallpaper
//
//  Created by JatWaston on 14-9-11.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#ifndef Wallpaper_WallpaperConfig_h
#define Wallpaper_WallpaperConfig_h

#define CACHE_PATH              [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kCatalogCachePath       @"Catalog"
#define kTypeCachePath          @"Type"
#define kCacheRootKey           @"JW"

//友盟统计
#define APP_STORE
#define kUmengKey @"541e8e43fd98c518c8044bb5"

#ifdef APP_STORE
    #define kChannel @"App Store"
#else
    #define kChannel @"91 Store"
#endif

//判断设备是否是iPhone5的高度
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//导航栏相关

// 颜色定义
#define kTextColor                          [UIColor colorWithRed:0.20 green:0.23 blue:0.23 alpha:1.0]
#define kNavBarTextColor                    kTextColor                                                  // 导航栏标题字体颜色
#define kNavBarTextFont                     [UIFont systemFontOfSize:20]


//广告相关
#define kAdMogoKey  @"70f0173582e54e2d8d2a16aff890802b"
#define kAdmobBannerKey   @"ca-app-pub-8936971650013728/3758313091"
#define kAdmobInterstitialKey @"ca-app-pub-8936971650013728/5235046290"

// 获取当前系统版本号
#define CURRENT_SYSTEM_VERSION              ([[[UIDevice currentDevice] systemVersion] floatValue])

#define kValidStr @"Wallpaper"

//#define TEST_URL
#define OUTTER_URL

#ifdef TEST_URL
    #define kWallpaperTypeURL  @"http://localhost/~apple/PHP/SAE/Wallpaper/Service/jwwallpaper/1/detailType.php"
    #define kWallpaperCatalogURL @"http://localhost/~apple/PHP/SAE/Wallpaper/Service/jwwallpaper/1/list.php"
    #define kWallpaperFavoriteURL @"http://localhost/~apple/PHP/SAE/Wallpaper/Service/jwwallpaper/1/favoriteImage.php"
    #define kWallpaperDownloadRankURL @"http://localhost/~apple/PHP/SAE/Wallpaper/Service/jwwallpaper/1/downloadRank.php"
#else
    #ifdef OUTTER_URL
        #define kWallpaperTypeURL @"http://jwwallpaper.sinaapp.com/detailType.php"
        #define kWallpaperCatalogURL @"http://jwwallpaper.sinaapp.com/list.php"
        #define kWallpaperFavoriteURL @"http://jwwallpaper.sinaapp.com/favoriteImage.php"
        #define kWallpaperDownloadRankURL @"http://jwwallpaper.sinaapp.com/downloadRank.php"
        #define kWallpaperDeleteImageURL @"http://jwwallpaper.sinaapp.com/deleteImage.php"
    #else
        #define kWallpaperTypeURL @"http://192.168.254.97/~zzl/PHP/Wallpaper/detailType.php"
    #define kWallpaperCatalogURL @"http://192.168.254.97/~zzl/PHP/Wallpaper/list.php"
    #endif
#endif





#define kCatalogKey @"catalog"
#define kListKey    @"list"
#define kName       @"name"
#define kType       @"type"
#define kCode       @"code"
#define kData       @"data"

//设置界面
#define kIconKey @"icon"
#define kTitleKey @"title"
#define kDescriptionKey @"description"

//Release模式下禁用NSLog
#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif


#endif
