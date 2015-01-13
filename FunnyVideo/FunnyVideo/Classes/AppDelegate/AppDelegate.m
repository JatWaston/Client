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
#import "JWNetworking.h"
#import "LocalNotificationManager.h"

#import "PushContentViewController.h"


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
    [UMSocialWechatHandler setWXAppId:kWeChatKey appSecret:kWeChatSecret url:kShareURL];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:kTencentID appKey:kTencentKey url:kShareURL];
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
//    UILocalNotification *notification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (notification) {
//        [self showNotificationContent:notification];
//    }
    [self showLocalNotificationMessage:launchOptions];
    [self fetchPushContent];
    
    //[self performSelector:@selector(test) withObject:nil afterDelay:2.0f];
    
    return YES;
}

- (void)test {
    PushContentViewController *contrtoller = [[PushContentViewController alloc] initWithNotification:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contrtoller];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)showLocalNotificationMessage:(NSDictionary *)launchOptions {
    UILocalNotification *notification = [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        NSLog(@"%s",__func__);
        [self showNotificationContent:notification];
    }
    /*launchOptions = {
	    UIApplicationLaunchOptionsLocalNotificationKey = "<UIConcreteLocalNotification: 0x17d93ff0>{fire date = 2000\U5e741\U67081\U65e5 \U661f\U671f\U516d \U4e2d\U56fd\U6807\U51c6\U65f6\U95f4\U4e0b\U534810:41:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2015\U5e741\U67089\U65e5 \U661f\U671f\U4e94 \U4e2d\U56fd\U6807\U51c6\U65f6\U95f4\U4e0b\U534810:41:00, user info = {\n    joke =     {\n        content = \"\\U6211\\U7ecf\\U8fc7\\U4e00\\U4e2a\\U5e7c\\U513f\\U56ed\\U95e8\\U53e3\\Uff01 \\U4e00\\U4e2a\\U54e5\\U4eec\\Uff0c\\U4e00\\U4e2a\\U6f02\\U79fb\\U628a\\U8f66\\U505c\\U5230\\U8f66\\U4f4d\\U4e0a\\Uff0c\\U4e0b\\U8f66\\U540e\\U8fd8\\U5927\\U58f0\\U7684\\U8bf4\\Uff0c\\U513f\\U5b50\\Uff01\\U5feb\\U4e0b\\U8f66\\U8981\\U8fdf\\U5230\\U5566\\Uff01 \\U7136\\U540e\\U6253\\U5f00\\U540e\\U8f66\\U95e8\\Uff0c\\U53c8\\U8bf4\\U4e86\\U4e00\\U53e5\\U53eb\\U6211\\U4eec\\U77ac\\U95f4\\U65e0\\U8bed\\U7684\\U8bdd\\Uff01\\U5367\\U69fd\\Uff0c\\U5b69\\U5b50\\U5fd8\\U5e26\\U5566\\Uff01\";\n        createDate = \"2014-12-01 00:00:00\";\n        id = 4b33e042c3544eab144b31cd5ecafd70;\n        likeCount = 0;\n        shareCount = 0;\n        title = \"\\U5927\\U54e5\\Uff0c\\U4f60\\U6f02\\U79fb\\U6280\\U672f\\U4e0d\\U9519\\U554a\\Uff01\";\n        unlikeCount = 0;\n    };\n}}";
     *
     */
    NSLog(@"launchOptions = %@",launchOptions);
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

- (void)fetchPushContent {
    JWNetworking *networking = [[JWNetworking alloc] init];
    [networking requestWithURL:kPushContentURL requestMethod:JWRequestMethodGet params:nil requestComplete:^(NSData *data, NSError *error) {
        NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        NSLog(@"resultData = %@",resultData);
        if (resultData && [[resultData valueForKey:@"code"] integerValue] == 0) {
            //先取消所有已注册的通知，重新获取通知内容
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            NSDictionary *info = [resultData valueForKey:@"data"];
            NSDictionary *imageContent = [(NSArray*)[info valueForKey:@"image"] objectAtIndex:0];
            NSDictionary *jokeContent = [(NSArray*)[info valueForKey:@"joke"] objectAtIndex:0];
            NSDictionary *videoContent = [(NSArray*)[info valueForKey:@"video"] objectAtIndex:0];
            
            NSDictionary *jokeInfo = [NSDictionary dictionaryWithObjectsAndKeys:jokeContent,@"joke", nil];
            NSDate *jokeDate = [[LocalNotificationManager defaultManager] createTimeWithString:@"10:00:00"];
            [[LocalNotificationManager defaultManager] pushNotificationMessage:[jokeContent valueForKey:@"content"]
                                                                      userInfo:jokeInfo
                                                                      pushTime:jokeDate
                                                                      pushRate:NSCalendarUnitDay];
            
            NSDictionary *imageInfo = [NSDictionary dictionaryWithObjectsAndKeys:imageContent,@"image", nil];
            NSDate *imageDate = [[LocalNotificationManager defaultManager] createTimeWithString:@"15:00:00"];
            NSString *imageMessage = [NSString stringWithFormat:@"[图片] %@",[imageContent valueForKey:@"title"]];
            [[LocalNotificationManager defaultManager] pushNotificationMessage:imageMessage
                                                                      userInfo:imageInfo
                                                                      pushTime:imageDate
                                                                      pushRate:NSCalendarUnitDay];
            
            NSDictionary *videoInfo = [NSDictionary dictionaryWithObjectsAndKeys:videoContent,@"video", nil];
            NSDate *videoDate = [[LocalNotificationManager defaultManager] createTimeWithString:@"20:00:00"];
            NSString *videoMessage = [NSString stringWithFormat:@"[视频] %@",[videoContent valueForKey:@"title"]];
            [[LocalNotificationManager defaultManager] pushNotificationMessage:videoMessage
                                                                      userInfo:videoInfo
                                                                      pushTime:videoDate
                                                                      pushRate:NSCalendarUnitDay];
        }
    }];
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"%s",__func__);
    application.applicationIconBadgeNumber = 0;
    [self showNotificationContent:notification];
    
    //[application cancelLocalNotification:notification];
    
    //[application cancelAllLocalNotifications];
}

- (void)showNotificationContent:(UILocalNotification*)notification {
    PushContentViewController *contrtoller = [[PushContentViewController alloc] initWithNotification:notification];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contrtoller];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
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
