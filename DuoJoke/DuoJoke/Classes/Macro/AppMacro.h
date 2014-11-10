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

#define kValidStr @"Joke"

#define kCode       @"code"
#define kData       @"data"

#define kJokeListURL @"http://jwjoke.sinaapp.com/list.php"
#define kJokeCatalogURL @"http://jwjoke.sinaapp.com/catalog.php"
#define kJokeImageDetailURL @"http://jwjoke.sinaapp.com/imageDetail.php"


//渠道
//#define APP_STORE

#ifdef APP_STORE
    #define kChannel @"App Store"
#else
    #define kChannel @"91 Store"
#endif

#ifdef APP_STORE
    #define kDefaultCatalog 1000
    #define kDefaultTitle @"每日美女"
#else
    #define kDefaultCatalog 3000
    #define kDefaultTitle @"吐槽囧图"
#endif

//#define kTestURL
//
//#ifdef kTestURL
//    #define kJokeListURL @"http://192.168.254.97/~zzl/SAE/Duowan/Service2/list.php"
//    #define kJokeCatalogURL @"http://192.168.254.97/~zzl/SAE/Duowan/Service2/catalog.php"
//    #define kJokeImageDetailURL @"http://192.168.254.97/~zzl/SAE/Duowan/Service2/imageDetail.php"
//#else
//    #define kJokeListURL @"http://192.168.1.6/~apple/PHP/SAE/Duowan/Service/list.php"
//    #define kJokeCatalogURL @"http://192.168.1.6/~apple/PHP/SAE/Duowan/Service/catalog.php"
//    #define kJokeImageDetailURL @"http://192.168.1.6/~apple/PHP/SAE/Duowan/Service/imageDetail.php"
//#endif


#endif
