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
#define kVideoContentCachePath  @"Video"
#define kJokeContentCachePath   @"Joke"
#define kImageContentCachePath  @"Image"
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
    JWImageTyp = 2,
};

#define kShowAd

#ifdef kShowAd
    #define kAdBananerHeight 50
#else
    #define kAdBananerHeight 0
#endif

#define kShareURL @"https://itunes.apple.com/cn/app/bi-zhi-da-shi/id929114250?mt=8"


//渠道
//#define APP_STORE

#ifdef APP_STORE
    #define kChannel @"App Store"
#else
    #define kChannel @"91 Store"
#endif

#define kTestURL
#define kOuterNet

#ifdef kTestURL
    #ifdef kOuterNet
        #define kDailyContentURL  @"http://funnyjoke.sinaapp.com/dailyContent.php"
        #define kVersionUpdateURL @"http://funnyjoke.sinaapp.com/checkVersionUpdate.php"
        #define kReportURL        @"http://funnyjoke.sinaapp.com/report.php"
        #define kVideoDailyContentURL  @"http://172.17.158.17/~zzl/SAE/Service/FunnyVideo/funnyjoke/1/dailyContent.php"
    #else
        #define kDailyContentURL @"http://192.168.254.97/~zzl/SAE/Service/FunnyVideo/funnyjoke/1/dailyContent.php"
        #define kVersionUpdateURL @"http://192.168.254.97/~zzl/SAE/Service/FunnyVideo/funnyjoke/1/checkVersionUpdate.php"
        #define kReportURL        @"http://192.168.254.97/~zzl/SAE/Service/FunnyVideo/funnyjoke/1/report.php"
    #endif
#else
    #ifdef kOuterNet
        #define kDailyContentURL  @"http://funnyjoke.sinaapp.com/dailyContent.php"
        #define kVersionUpdateURL @"http://funnyjoke.sinaapp.com/checkVersionUpdate.php"
        #define kReportURL        @"http://funnyjoke.sinaapp.com/report.php"
    #else
        #define kDailyContentURL @"http://192.168.1.10/~apple/PHP/SAE/Service/FunnyVideo/funnyjoke/1/dailyContent.php"
        #define kVersionUpdateURL @"http://192.168.1.10/~apple/PHP/SAE/Service/FunnyVideo/funnyjoke/1/checkVersionUpdate.php"
        #define kReportURL        @"http://192.168.1.10/~apple/PHP/SAE/Service/FunnyVideo/funnyjoke/1/report.php"
    #endif
#endif


#endif
