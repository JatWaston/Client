//
//  RootViewController.m
//  TenTu
//
//  Created by JatWaston on 14-11-16.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController


- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"今日十图";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_home"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
