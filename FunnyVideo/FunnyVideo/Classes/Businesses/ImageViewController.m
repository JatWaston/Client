//
//  ImageViewController.m
//  FunnyVideo
//
//  Created by zhengzhilin on 14/12/22.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "ImageViewController.h"
#import "FunnyImageTableViewCell.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"图片";
        self.tabBarItem.image = [UIImage imageNamed:@"icon_image"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
