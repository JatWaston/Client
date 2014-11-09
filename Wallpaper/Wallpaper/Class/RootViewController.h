//
//  RootViewController.h
//  Wallpaper
//
//  Created by JatWaston on 14-9-11.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallpaperThumbImageView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitialDelegate.h"


@interface RootViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,WallpaperThumbDelegate,GADBannerViewDelegate,GADInterstitialDelegate>


- (void)request;
- (void)requestDataWithCatalog:(NSUInteger)catalog type:(NSUInteger)type;

@end
