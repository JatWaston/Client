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
    NSURL *movieUrl = [NSURL URLWithString:@"http://k.youku.com/player/getFlvPath/sid/44168119271541225115f_01/st/mp4/fileid/03002001005472ACE5BD1C00332C4833AA1835-E171-6083-F1AA-7D174E2EE875?K=774abe57f74a3c52282a095f&hd=0&myp=0&ts=180&ypp=2&ctype=12&ev=1&token=2649&oip=3663591661&ep=diaVHEGMV8cC4iLajD8bZSnjdXJZXP4J9h%2BHgdJjALshTO%2B96E2kwu%2FET4xCFvoacFECGOjy2qHmYkMRYYVCrmkQ2U6gOvqW%2F4GS5aonxZcEExtDB8XQsVScRTT4"];
    _player = [[JWMPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
//    [self presentMoviePlayerViewControllerAnimated:player];
//    VideoViewController *controller = [[VideoViewController alloc] init];
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
