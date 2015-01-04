//
//  JWBaseTabBarController.m
//  FunnyVideo
//
//  Created by JatWaston on 14-11-25.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWBaseTabBarController.h"
#import "JWBaseTableViewController.h"

@interface JWBaseTabBarController () <UITabBarControllerDelegate> {
    BOOL _shouldRefresh;
}

@end

@implementation JWBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    _shouldRefresh = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.selectedViewController) {
        _shouldRefresh = YES;
    } else {
        _shouldRefresh = NO;
    }

    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    NSLog(@"viewController = %@",viewController);
//    NSLog(@"selectedViewController = %@",self.selectedViewController);
    if (_shouldRefresh && [viewController isKindOfClass:[UINavigationController class]]) {
        //NSLog(@"visibleViewController=%@",((UINavigationController*)viewController).visibleViewController);
        if ([((UINavigationController*)viewController).visibleViewController respondsToSelector:NSSelectorFromString(@"refresh")]) {
            [(JWBaseTableViewController*)((UINavigationController*)viewController).visibleViewController refresh];
        }
    }
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
