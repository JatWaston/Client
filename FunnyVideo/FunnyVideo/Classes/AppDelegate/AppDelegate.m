//
//  AppDelegate.m
//  FunnyVideo
//
//  Created by JatWaston on 14-11-21.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "JokeViewController.h"
#import "ImageViewController.h"
#import "SettingViewController.h"
#import "JWBaseTabBarController.h"

#import "UMSocial.h"
#import "UIColor+Colours.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"


#import "UtilManager.h"
#import "FMDatabase.h"

#import "MobClick.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:kUmengKey reportPolicy:BATCH channelId:kChannel];
#if 1
    [UMSocialData setAppKey:kUmengKey];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:kTencentID appKey:kTencentKey url:@"http://www.umeng.com/social"];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
#endif

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self createDatabase];

#if 1
    [[UINavigationBar appearance] setBarTintColor:kNavigationBarColor]; //设置UINavigationBar的颜色
    
    RootViewController *mainViewController = [[RootViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskAll tableViewStyle:UITableViewStylePlain];
    UINavigationController *navMainViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    JokeViewController *jokeViewController = [[JokeViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskAll tableViewStyle:UITableViewStylePlain];
    UINavigationController *navJokeViewController = [[UINavigationController alloc] initWithRootViewController:jokeViewController];
    
    ImageViewController *imageViewController = [[ImageViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskAll tableViewStyle:UITableViewStylePlain];
    UINavigationController *navImageViewController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    
    
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskNone tableViewStyle:UITableViewStyleGrouped];
    UINavigationController *navSettingViewController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    //navSettingViewController.navigationBar.tintColor = [UIColor skyBlueColor];
    
    JWBaseTabBarController *tab = [[JWBaseTabBarController alloc] init];
    //tintColor 文字和图片的颜色
    tab.tabBar.tintColor = kTabBarTextTintColor;
    tab.tabBar.barTintColor = kTabBarTintColor;
    
    NSArray *controllers = [NSArray arrayWithObjects:navMainViewController,navImageViewController,navJokeViewController,navSettingViewController, nil];
    [tab setViewControllers:controllers animated:NO];
#endif
    
    
    self.window.rootViewController = tab;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)createDatabase
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"record.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS `recordList` (`id` VARCHAR(33) NOT NULL, `likeCount` INT NOT NULL,`like` VARCHAR(1) NOT NULL, `unlikeCount` INT NOT NULL,`unlike` VARCHAR(1) NOT NULL, PRIMARY KEY(`id`))";
        BOOL res = [db executeUpdate:sql];
        if (!res)
        {
            NSLog(@"create table error.");
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

@end
