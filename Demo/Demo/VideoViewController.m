//
//  VideoViewController.m
//  Demo
//
//  Created by zhengzhilin on 14-11-24.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.3f alpha:1.0f];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frame = self.view.frame;
    button.frame = CGRectMake((frame.size.width-100)/2.0f, (frame.size.height-30)/2.0f, 100, 30);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss...");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
