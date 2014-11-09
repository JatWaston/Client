//
//  AppDelegate.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-4.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "CatalogViewController.h"
#import "SettingViewController.h"
#import "TestViewController.h"
#import "MobClick.h"
#import "JWNavigationController.h"
#import "UtilManager.h"
#import "FMDatabase.h"

@interface AppDelegate()

- (void)createDatabase;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createDatabase];
    
    [MobClick startWithAppkey:kUmengKey reportPolicy:BATCH channelId:kChannel];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[RootViewController alloc] init];
    JWNavigationController *nav = [[JWNavigationController alloc] initWithRootViewController:self.viewController];
    CatalogViewController *leftViewController = [[CatalogViewController alloc] init];
    SettingViewController *rightViewController = [[SettingViewController alloc] init];
    
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:nav
                                                      leftMenuViewController:leftViewController
                                                     rightMenuViewController:rightViewController];
    self.sideMenuViewController.backgroundImage = [UIImage imageNamed:@"MenuBackground"];
    self.sideMenuViewController.animationDuration = 0.2f;
    self.sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    self.sideMenuViewController.delegate = self;
    self.sideMenuViewController.parallaxEnabled = NO;
    self.sideMenuViewController.bouncesHorizontally = NO;
//    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
//    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
//    sideMenuViewController.contentViewShadowOpacity = 0.6;
//    sideMenuViewController.contentViewShadowRadius = 12;
//    sideMenuViewController.contentViewShadowEnabled = YES;
    
//    TestViewController *vc = [[TestViewController alloc] init];
    
    
    self.window.rootViewController = self.sideMenuViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)createDatabase
{
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"wallpaper.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open])
    {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS `favoriteList` (`id` VARCHAR(33) NOT NULL, `thumbURL` VARCHAR(128) NOT NULL, `downloadURL` VARCHAR(128) NOT NULL, PRIMARY KEY(`id`))";
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

#pragma mark -
#pragma mark RESideMenuDelegate

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    if ([menuViewController isKindOfClass:[SettingViewController class]])
    {
        [(SettingViewController*)menuViewController updateCacheSize];
    }
}

@end
