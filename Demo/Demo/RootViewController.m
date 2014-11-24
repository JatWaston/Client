//
//  RootViewController.m
//  Demo
//
//  Created by zhengzhilin on 14-11-24.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "RootViewController.h"
#import "VideoViewController.h"
#import "JWMPMoviePlayerViewController.h"

@interface RootViewController ()
{
    JWMPMoviePlayerViewController *_player;
}

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.3f alpha:1.0f];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = self.view.frame;
    button.frame = CGRectMake((frame.size.width-100)/2.0f, (frame.size.height-30)/2.0f, 100, 30);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button setTitle:@"Play" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)playVideo
{
    NSURL *movieUrl = [NSURL URLWithString:@"http://k.youku.com/player/getFlvPath/sid/9416831564485129772ca_00/st/mp4/fileid/03000801005472DFF62B3006257BB67BC3A57F-7D0E-61A9-84EC-626B4A6E7719?K=b65f5bf641d16955261e06cd&hd=1&myp=0&ts=181&ypp=0&ctype=12&ev=1&token=1618&oip=2015647293&ep=eyaVHEGOV8sG4SfXjT8bbivldiReXP4J9h%2BFidJjALshTO%2B97UinwZ%2FCTf9CEPscdVB0FuyD2NOWb0diYfc3qR0Q2U%2FZMPro%2BoWQ5atRwuIEFx9DdcrWvVSfRTH5"];
    _player = [[JWMPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
    [self presentMoviePlayerViewControllerAnimated:_player];
}

- (void)dismissMoviePlayerViewControllerAnimated
{
    [_player dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss...");
    }];
    NSLog(@"dismissMoviePlayerViewControllerAnimated");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
