//
//  RootViewController.m
//  FunnyVideo
//
//  Created by JatWaston on 14-11-24.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "RootViewController.h"
#import "JWMPMoviePlayerViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "JWImageTableViewCell.h"

#import "UIColor+Colours.h"


@interface RootViewController ()
{
    JWMPMoviePlayerViewController *_player;
}

@end

@implementation RootViewController

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"视频";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_daily"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.tintColor = [UIColor skyBlueColor];
    // Do any additional setup after loading the view.
//    [self showVideo];
    
//    self.view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.3f alpha:1.0f];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    CGRect frame = self.view.frame;
//    button.frame = CGRectMake((frame.size.width-100)/2.0f, (frame.size.height-30)/2.0f, 100, 30);
//    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    [button setTitle:@"Play" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(showVideo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerNotificationHandler:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil]; //检测播放结束的原因
    
    for (int i = 0; i < 100; i++) {
        [_items addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.contentTableView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTableView reloadData];
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

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    
}

- (void)showVideo {
    
//    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";             //分享内嵌文字
//    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
//    NSArray *snsPlatform = [NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToWechatFavorite,UMShareToEmail,UMShareToSms, nil];
//    //如果得到分享完成回调，需要设置delegate为self
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:kUmengKey shareText:shareText shareImage:shareImage shareToSnsNames:snsPlatform delegate:(id<UMSocialUIDelegate>)self];
//    return;
    NSURL *movieUrl = [NSURL URLWithString:@"http://pl.youku.com/playlist/m3u8?vid=200019946&type=flv&ep=diaVHECPVcoE4yPfjz8bbi3gfX4KXPwK9h%2BEiNtmBtQnSeG%2F&token=3190&ctype=12&ev=1&oip=2015647293&sid=441692344600712912995"];
    _player = [[JWMPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
    [self presentMoviePlayerViewControllerAnimated:_player];
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

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cellStr";
    JWImageTableViewCell *cell = (JWImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[JWImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showVideo];
}

@end
