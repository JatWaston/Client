//
//  WallpaperDetailViewController.h
//  Wallpaper
//
//  Created by JatWaston on 14-9-18.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

#import "GADBannerViewDelegate.h"
#import "GADInterstitialDelegate.h"

@interface WallpaperDetailViewController : UIViewController <SwipeViewDataSource,SwipeViewDelegate,UIActionSheetDelegate,GADBannerViewDelegate,GADInterstitialDelegate>

@property (nonatomic, strong) NSMutableArray *item;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL showInterstitialAd;


@end
