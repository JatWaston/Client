//
//  WallpaperManager.h
//  ImageTest
//
//  Created by JatWaston on 14-9-16.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UIWallpaperType)
{
    UIWallpaperLockType = 1,
    UIWallpaperHomeType,
    UIWallpaperLockAndHome,
};

@interface WallpaperManager : NSObject

+ (WallpaperManager*)shareManager;

- (BOOL)applyWallpaper:(UIImage*)image type:(UIWallpaperType)wallpaperType;

@end
