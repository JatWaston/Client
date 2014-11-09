//
//  JWPhotoBrowserController.h
//  DuoJoke
//
//  Created by JatWaston on 14-10-27.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWPhotoBrowserController : UIViewController

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSUInteger currentPage;

- (void)showBrowser;

@end
