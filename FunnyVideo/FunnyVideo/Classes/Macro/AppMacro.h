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

#define kValidStr @"Video"

#define kCode       @"code"
#define kData       @"data"


typedef NS_ENUM(NSUInteger,JWStorePlatform)
{
    JW91SttorePlatform = 0,
    JWAppStorePlatform,
};

typedef NS_ENUM(NSUInteger,JWContentType) {
    JWVideoType = 0, //视频
    JWJokeType = 1,  //笑话
};


//渠道
//#define APP_STORE

#ifdef APP_STORE
    #define kChannel @"App Store"
#else
    #define kChannel @"91 Store"
#endif

#ifdef APP_STORE
    #define kDefaultCatalog 1000
#else
    #define kDefaultCatalog 1000
#endif

//#define kTestURL

#ifdef kTestURL
    #define kDailyContentURL @"http://192.168.254.97/~zzl/SAE/Service/Video/Service/dailyContent.php"
    #define kJokeContentURL @"http://192.168.254.97/~zzl/SAE/Service/Video/Service/getJoke.php"
#else
    #define kDailyContentURL @"http://192.168.1.9/~apple/PHP/SAE/Service/Video/Service/dailyContent.php"
    #define kJokeContentURL @"http://192.168.1.9/~apple/PHP/SAE/Service/Video/Service/getJoke.php"
#endif


#endif
