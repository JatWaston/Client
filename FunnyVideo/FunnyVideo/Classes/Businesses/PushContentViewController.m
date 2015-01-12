//
//  PushContentViewController.m
//  FunnyVideo
//
//  Created by JatWaston on 15-1-9.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import "PushContentViewController.h"

@interface PushContentViewController() {
    UILocalNotification *_pushNotification;
}

@property (nonatomic, strong) UILocalNotification *pushNotification;

@end

@implementation PushContentViewController
@synthesize pushNotification = _pushNotification;

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
        [self createJokeView];
    } else if ([self.pushNotification.userInfo valueForKey:@"image"]) {
        NSLog(@"image userinfo = %@",self.pushNotification.userInfo);
        [self createImageView];
    } else if ([self.pushNotification.userInfo valueForKey:@"video"]) {
        NSLog(@"video userinfo = %@",self.pushNotification.userInfo);
        [self createVideoView];
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(returnBack)];
    self.navigationItem.rightBarButtonItem = backItem;
}

- (void)createJokeView {
    
}

- (void)createImageView {
    
}

- (void)createVideoView {
    
}

- (void)returnBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
