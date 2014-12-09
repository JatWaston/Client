//
//  HomeViewController.m
//  FunnyVideo
//
//  Created by JatWaston on 14/12/4.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "HomeViewController.h"
#import "VideoViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(showVideo) withObject:self afterDelay:3.0f];
}

- (void)showVideo {
    VideoViewController *controller = [[VideoViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
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
