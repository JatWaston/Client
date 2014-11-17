//
//  AppMacro.h
//  DuoJoke
//
//  Created by JatWaston on 14-10-17.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#ifndef DuoJoke_AppMacro_h
#define DuoJoke_AppMacro_h

#define kCatalogCachePath       @"Catalog"
#define kCatalogDetailCachePath @"CatalogDetail"
#define kCacheRootKey           @"JW"

#define kValidStr @"TenTu"

#define kCode       @"code"
#define kData       @"data"


typedef NS_ENUM(NSUInteger,JWStorePlatform)
{
    JW91SttorePlatform = 0,
    JWAppStorePlatform,
};


//渠道
//#define APP_STORE

#ifdef APP_STORE
    #define kChannel @"App Store"
#else
    #define kChannel @"91 Store"
#endif

#ifdef APP_STORE
//    #define kDefaultCatalog 1000
//    #define kDefaultTitle @"每日美女"
    #define kDefaultCatalog 3000
    #define kDefaultTitle @"吐槽囧图"
#else
    #define kDefaultCatalog 5000
    #define kDefaultTitle @"今日囧图"
#endif

#define kTestURL

#ifdef kTestURL
    #define kDailyContentURL @"http://192.168.1.10/~apple/PHP/SAE/Service/TenTu/tentu/1/dailyContent.php"
#else
    #define kDailyContentURL @"http://192.168.1.10/~apple/PHP/SAE/Service/TenTu/tentu/1/dailyContent.php"
#endif


#endif
