//
//  RootViewController.m
//  FunnyVideo
//
//  Created by zhengzhilin on 14-11-24.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()
{
    VideoPlayerKit *_videoPlayerViewController;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showVideo];
}

- (void)showVideo {
    if (!_videoPlayerViewController)
    {
        _videoPlayerViewController = [VideoPlayerKit videoPlayerWithContainingViewController:self optionalTopView:nil hideTopViewWithControls:YES];
        _videoPlayerViewController.delegate = self;
        _videoPlayerViewController.allowPortraitFullscreen = NO;
    }
    [_videoPlayerViewController.view setFrame:CGRectMake(0, 0, 320, 200)];
    [self.view addSubview:_videoPlayerViewController.view];
    NSURL *videoURL = [NSURL URLWithString:@"http://v.youku.com/player/getRealM3U8/vid/XNDQ4NDg1NTU2/type/mp4/v.m3u8"];
    [_videoPlayerViewController playVideoWithTitle:@"" URL:videoURL videoID:nil shareURL:nil isStreaming:NO playInFullScreen:NO];
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
