//
//  PushContentViewController.m
//  FunnyVideo
//
//  Created by JatWaston on 15-1-9.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import "PushContentViewController.h"
#import "JWToolBarView.h"
#import "UtilManager.h"
#import "UIImageView+WebCache.h"
#import "TOWebViewController.h"
#import "JWMPMoviePlayerViewController.h"
#import "JWReportManager.h"
#import "Global.h"

#define kPushTitleFont      [UIFont boldSystemFontOfSize:20.0f]
#define kPushContentFont    [UIFont systemFontOfSize:18.0f]

#define kPlayImageWidth  45.0f
#define kPlayImageHeight 45.0f

@interface PushContentViewController() {
    UILocalNotification *_pushNotification;
    NSDictionary *_userInfo;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UIImageView *_imageView;
    UIButton *_likeBtn;
    UIButton *_unlikeBtn;
    JWToolBarView *_toolBar;
    UIButton *_playButton;
    UILabel *_timeLabel;
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) UILocalNotification *pushNotification;
@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation PushContentViewController
@synthesize pushNotification = _pushNotification;
@synthesize userInfo = _userInfo;

- (id)initWithNotification:(UILocalNotification*)notification {
    if (self = [super init]) {
        self.pushNotification = notification;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.pushNotification.userInfo valueForKey:@"joke"]) {
        NSLog(@"joke userinfo = %@",self.pushNotification.userInfo);
        self.userInfo = [self.pushNotification.userInfo valueForKey:@"joke"];
        [self createJokeView];
    } else if ([self.pushNotification.userInfo valueForKey:@"image"]) {
        NSLog(@"image userinfo = %@",self.pushNotification.userInfo);
        self.userInfo = [self.pushNotification.userInfo valueForKey:@"image"];
        [self createImageView];
    } else if ([self.pushNotification.userInfo valueForKey:@"video"]) {
        NSLog(@"video userinfo = %@",self.pushNotification.userInfo);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerNotificationHandler:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil]; //检测播放结束的原因
        self.userInfo = [self.pushNotification.userInfo valueForKey:@"video"];
        [self createVideoView];
    }
    [self createToolBarWithInfo:self.userInfo];
    
    self.title = @"查看内容";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(returnBack)];
    self.navigationItem.rightBarButtonItem = backItem;
}

- (void)createToolBarWithInfo:(NSDictionary*)info {
    _toolBar = [[JWToolBarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-40-64, self.view.bounds.size.width, 30)];
    [_toolBar fillingData:info indexPath:nil];
    //_toolBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_toolBar];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 25)];
//    view.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:view];
}

- (void)createJokeView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    NSString *title = [self.userInfo valueForKey:@"title"];
    float offsetHeight = 10;
    if ([title isEqualToString:@"\n"] || title == nil ) {
        
    } else {
        CGSize titleSize = [title sizeWithFont:kPushTitleFont constrainedToSize:CGSizeMake(self.view.frame.size.width-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.view.frame.size.width-10, titleSize.height)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = title;
        _titleLabel.font = kPushTitleFont;
        [_scrollView addSubview:_titleLabel];
        offsetHeight = 10+titleSize.height+5;
    }
    
    NSString *content = [self.userInfo valueForKey:@"content"];
    CGSize contentSize = [content sizeWithFont:kPushContentFont constrainedToSize:CGSizeMake(self.view.frame.size.width-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, offsetHeight, self.view.frame.size.width-10, contentSize.height)];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = kPushContentFont;
    _contentLabel.text = content;
    [_scrollView addSubview:_contentLabel];
    
    offsetHeight += contentSize.height;
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, offsetHeight)];
}

- (void)createImageView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    NSString *title = [self.userInfo valueForKey:@"title"];

    float offsetHeight = 2.0f;
    float heigth = [[UtilManager shareManager] heightForText:title
                                                    rectSize:CGSizeMake(self.view.frame.size.width-10.0f, MAXFLOAT)
                                                        font:kPushTitleFont];
    _titleLabel.frame = CGRectMake(5, 2.0f, self.view.frame.size.width-10, heigth);
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, offsetHeight, self.view.frame.size.width-10, heigth)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = title;
    _titleLabel.font = kPushTitleFont;
    [_scrollView addSubview:_titleLabel];
    
    offsetHeight += heigth+2;
    
    float viewWidth = self.view.frame.size.width-20;
    float imgWidth = [[self.userInfo valueForKey:@"image_width"] floatValue];
    float imgHeight = [[self.userInfo valueForKey:@"image_height"] floatValue];
    if (imgWidth >= viewWidth) {
        float scale = viewWidth/imgWidth*1.0f;
        imgWidth = viewWidth;
        imgHeight = imgHeight*scale;
    }
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, offsetHeight, imgWidth, imgHeight)];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_imageView sd_setImageWithURL:[self.userInfo valueForKey:@"image_url"]];
    [_scrollView addSubview:_imageView];
    
    offsetHeight += imgHeight;
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, offsetHeight)];
}

- (void)createVideoView {
    NSString *title = [self.userInfo valueForKey:@"title"];
    CGSize titleSize = [title sizeWithFont:kPushTitleFont constrainedToSize:CGSizeMake(self.view.frame.size.width-10, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.view.frame.size.width-10, titleSize.height)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = title;
    _titleLabel.font = kPushTitleFont;
    [self.view addSubview:_titleLabel];
    
    float imgWidth = 135.0f*1.2f;
    float imgHeight = 85.0f*1.2f;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-imgWidth)/2.0f, 10+titleSize.height+5, imgWidth, imgHeight)];
    _imageView.userInteractionEnabled = YES;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[self.userInfo valueForKey:@"coverImgURL"]]];
    [self.view addSubview:_imageView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    _timeLabel.frame = CGRectMake(imgWidth-40, imgHeight-20, 40, 20);
    _timeLabel.text = [self.userInfo valueForKey:@"videoTime"];
    [_imageView addSubview:_timeLabel];
    
    UIImage *playNormalImg = [UIImage imageNamed:@"fun_play_normal"];
    UIImage *playPressImg = [UIImage imageNamed:@"fun_play_hover"];
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:playNormalImg forState:UIControlStateNormal];
    [_playButton setImage:playPressImg forState:UIControlStateHighlighted];
    _playButton.frame = CGRectMake((imgWidth-kPlayImageWidth)/2.0f, (imgHeight-kPlayImageHeight)/2.0f, kPlayImageWidth, kPlayImageHeight);
    [_playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:_playButton];
}

- (void)playVideo {
    [[JWReportManager defaultManager] updatePlayCountWithRecord:[self.userInfo valueForKey:@"id"] contentType:JWVideoType];
    
    NSString *url = [self.userInfo valueForKey:@"videoURL"];
//    url = [url stringByAppendingString:@"xxxx"];
    NSURL *movieUrl = [NSURL URLWithString:url];
    //movieUrl = nil;
    if (movieUrl == nil || url.length <= 0) {
        NSURL *url = [NSURL URLWithString:[self.userInfo valueForKey:@"webURL"]];
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
        
    } else {
        JWMPMoviePlayerViewController *player = [[JWMPMoviePlayerViewController alloc] initWithContentURL:movieUrl];
        [self presentMoviePlayerViewControllerAnimated:player];
    }
}

- (void)returnBack {
    [self dismissViewControllerAnimated:YES completion:^{
        [Global shareInstance].isInPushContent = NO;
    }];
}

#pragma mark - 视频播放

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
                    break;
                }
                case MPMovieFinishReasonPlaybackError:{
                    /* An error happened and the movie ended */
                    NSLog(@"An error happened and the movie ended");
                    [self showPlayVideoErrorAlert];
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

- (void)showPlayVideoErrorAlert {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"当前视频播放出错，是否在网页中播放该视频？"
                                                           delegate:self
                                                  cancelButtonTitle:@"否"
                                                  otherButtonTitles:@"播放", nil];
        [alertView show];
    });
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:[self.userInfo valueForKey:@"webURL"]];
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
    }
    
}

@end
