//
//  AppDelegate.m
//  DuoJoke
//
//  Created by JatWaston on 14-10-14.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "JWNavigationController.h"
#import "REFrostedViewController.h"
#import "MenuViewController.h"
#import "SDImageCache.h"
#import "CatalogMenuViewController.h"
#import "MobClick.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:kUmengKey reportPolicy:BATCH channelId:kChannel];
    
    [SDImageCache sharedImageCache].maxCacheSize = 1024*1024*20;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[RootViewController alloc] initWithRefreshStyle:JWTableRefreshStyleMaskAll];
    JWNavigationController *nav = [[JWNavigationController alloc] initWithRootViewController:self.viewController];
    
    CatalogMenuViewController *menuController = [[CatalogMenuViewController alloc] init];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:nav menuViewController:menuController];
    frostedViewController.limitMenuViewSize = YES;
    frostedViewController.minimumMenuViewSize = CGSizeMake(200, self.window.frame.size.height-64);
    frostedViewController.animationDuration = 0.15f;
    frostedViewController.offsetNavigationBar = 64;
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    
    self.window.rootViewController = frostedViewController;
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"applicationDidReceiveMemoryWarning --> Clear Cache");
    });
    
}

@end
