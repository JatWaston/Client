//
//  DailyViewController.m
//  TenTu
//
//  Created by JatWaston on 14-11-16.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "DailyViewController.h"

@implementation DailyViewController

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"每日精选";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_daily"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

@end
