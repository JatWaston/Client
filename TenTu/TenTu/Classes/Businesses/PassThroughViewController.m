//
//  PassThroughViewController.m
//  TenTu
//
//  Created by JatWaston on 14-11-16.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "PassThroughViewController.h"

@implementation PassThroughViewController


- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"随机穿越";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_cross"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

@end
