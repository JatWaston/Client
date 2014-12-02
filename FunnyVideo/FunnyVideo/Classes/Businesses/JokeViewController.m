//
//  JokeViewController.m
//  FunnyVideo
//
//  Created by zhengzhilin on 14-12-2.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JokeViewController.h"

@interface JokeViewController ()

@end

@implementation JokeViewController

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"搞笑段子";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_home"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
