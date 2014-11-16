//
//  AppDelegate.m
//  TenTu
//
//  Created by JatWaston on 14-11-16.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "PassThroughViewController.h"
#import "DailyViewController.h"
#import "SettingViewController.h"
#import "MobClick.h"
#import "JWTabBarController.h"
#import "UIColor+Colours.h"
#import "UIImage+Util.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:kUmengKey reportPolicy:BATCH channelId:kChannel];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.controller = [[RootViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskNone];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.controller];
    UITabBarController *tab = [[UITabBarController alloc] init];
    //tintColor 文字和图片的颜色
    tab.tabBar.tintColor = [UIColor skyBlueColor];
    tab.tabBar.barTintColor = [UIColor blackColor];
    //tab.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor dangerColor] andSize:CGSizeMake(1, 1)];
    //tab.tabBar.selectedImageTintColor = [UIColor dangerColor];
    
    RootViewController *mainViewController = [[RootViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskNone tableViewStyle:UITableViewStylePlain];
    UINavigationController *navMainViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    PassThroughViewController *passThroughViewController = [[PassThroughViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskNone tableViewStyle:UITableViewStylePlain];
    UINavigationController *navPassThroughViewController = [[UINavigationController alloc] initWithRootViewController:passThroughViewController];
    DailyViewController *dailyViewController = [[DailyViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskNone tableViewStyle:UITableViewStylePlain];
    UINavigationController *navDailyViewController = [[UINavigationController alloc] initWithRootViewController:dailyViewController];
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskNone tableViewStyle:UITableViewStyleGrouped];
    UINavigationController *navSettingViewController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    NSArray *controllers = [NSArray arrayWithObjects:navMainViewController,navPassThroughViewController,navDailyViewController,navSettingViewController, nil];
    [tab setViewControllers:controllers animated:NO];
//    tab.selectedViewController = navMainViewController;
//    tab.selectedIndex = 0;
    
    self.window.rootViewController = tab;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    

    
    
    
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

@end
