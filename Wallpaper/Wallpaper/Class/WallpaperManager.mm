//
//  WallpaperManager.m
//  ImageTest
//
//  Created by JatWaston on 14-9-16.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "WallpaperManager.h"
#import <dlfcn.h>

#define kSpringBoardUIPath       "/System/Library/PrivateFrameworks/SpringBoardUI.framework/SpringBoardUI"
typedef BOOL (*$SBSUIWallpaperSetImageAsWallpaperForLocations)(UIImage *image, int location);
static  $SBSUIWallpaperSetImageAsWallpaperForLocations  SBSUIWallpaperSetImageAsWallpaperForLocations = NULL;
extern void GSSendAppPreferencesChanged(CFStringRef appID, CFStringRef key);

static WallpaperManager *_manager = nil;

@implementation WallpaperManager

+ (WallpaperManager*)shareManager
{
    if (_manager == nil)
    {
        _manager = [[WallpaperManager alloc] init];
    }
    return _manager;
}

- (BOOL)applyWallpaper:(UIImage*)image type:(UIWallpaperType)wallpaperType
{
    BOOL res = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        void *SpringBoardUI = dlopen(kSpringBoardUIPath, RTLD_LAZY);
        SBSUIWallpaperSetImageAsWallpaperForLocations = ($SBSUIWallpaperSetImageAsWallpaperForLocations)dlsym(SpringBoardUI, "SBSUIWallpaperSetImageAsWallpaperForLocations");
        dlclose(SpringBoardUI);
        
        if (SBSUIWallpaperSetImageAsWallpaperForLocations)
        {
            res = SBSUIWallpaperSetImageAsWallpaperForLocations(image, wallpaperType);
            return res;
        }
        else
        {
            res = NO;
            return res;
        }

    }
    else
    {
        
    }
    return res;
}

@end
