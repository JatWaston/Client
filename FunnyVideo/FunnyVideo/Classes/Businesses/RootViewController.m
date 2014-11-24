//
//  RootViewController.m
//  FunnyVideo
//
//  Created by JatWaston on 14-11-24.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "RootViewController.h"
#import "JWMPMoviePlayerViewController.h"


@interface RootViewController ()
{
    JWMPMoviePlayerViewController *_player;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self showVideo];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.3f alpha:1.0f];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = self.view.frame;
    button.frame = CGRectMake((frame.size.width-100)/2.0f, (frame.size.height-30)/2.0f, 100, 30);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button setTitle:@"Play" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerNotificationHandler:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil]; //检测播放结束的原因
}

- (void)moviePlayerNotificationHandler:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:MPMoviePlayerPlaybackDidFinishNotification]) {
        NSNumber *reason =
        [notification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        if (reason != nil) {
            NSInteger reasonAsInteger = [reason integerValue];
            switch (reasonAsInteger){
                case MPMovieFinishReasonPlaybackEnded:{
                    /* The movie ended normally */
                    NSLog(@"The movie ended normally");
                    break; }
                case MPMovieFinishReasonPlaybackError:{
                    /* An error happened and the movie ended */
                    NSLog(@"An error happened and the movie ended");
                    break;
                }
                case MPMovieFinishReasonUserExited:{
                    /* The user exited the player */
                    NSLog(@"The user exited the player");
                    break;
                }
            }
            NSLog(@"Finish Reason = %ld", (long)reasonAsInteger);
        } /* if (reason != nil){ */
    }
    
}

- (void)showVideo {
    NSURL *movieUrl = [NSURL URLWithString:@"http://k.youku.com/player/getFlvPath/sid/9416831564485129772ca_00/st/mp4/fileid/03000801005472DFF62B3006257BB67BC3A57F-7D0E-61A9-84EC-626B4A6E7719?K=b65f5bf641d16955261e06cd&hd=1&myp=0&ts=181&ypp=0&ctype=12&ev=1&token=1618&oip=2015647293&ep=eyaVHEGOV8sG4SfXjT8bbivldiReXP4J9h%2BFidJjALshTO%2B97UinwZ%2FCTf9CEPscdVB0FuyD2NOWb0diYfc3qR0Q2U%2FZMPro%2BoWQ5atRwuIEFx9DdcrWvVSfRTH5"];
//    NSURL *movieUrl = [NSURL URLWithString:@"http://k.youku.com/player/getFlvPath/sid/9416831564485129772ca_00/st/mp4/fileid/03000801005472DFF62B300625SDFSDFSS7BB67BC3A57F-7D0E-61A9-84EC-626B4A6E7719?K=b65f5bf641d16955261e06cd&hd=1&myp=0&ts=181&ypp=0&ctype=12&ev=1&token=1618&oip=2015647293&ep=eyaVHEGOV8sG4SfXjT8bbivldiReXP4J9h%2BFidJjALshTO%2B97UinwZ%2FCTf9CEPscdVB0FuyD2NOWb0diYfc3qR0Q2U%2FZSDFSFDSAMPro%2BoWQ5atRwuIEFx9DdcrWvVSfRTH5"];
    _player = [[JWMPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
    [self presentMoviePlayerViewControllerAnimated:_player];
}

- (BOOL)shouldAutorotate
{
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    if (UIDeviceOrientationIsLandscape(orientation)) {
//        if (!_videoPlayerViewController.fullScreenModeToggled) {
//            [_videoPlayerViewController launchFullScreen];
//        }
//    } else if (UIDeviceOrientationIsPortrait(orientation)) {
//        if (_videoPlayerViewController.fullScreenModeToggled) {
//            [_videoPlayerViewController minimizeVideo];
//        } 
//    }
//    NSLog(@"orientation = %d",[[UIDevice currentDevice] orientation]);
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
