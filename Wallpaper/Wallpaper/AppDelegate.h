//
//  AppDelegate.h
//  Wallpaper
//
//  Created by JatWaston on 14-9-4.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "WallpaperThumbImageView.h"

@class RootViewController;
@class RESideMenu;

@interface AppDelegate : UIResponder <UIApplicationDelegate,RESideMenuDelegate,WallpaperThumbDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *viewController;
@property (strong, nonatomic) RESideMenu *sideMenuViewController;


@end
