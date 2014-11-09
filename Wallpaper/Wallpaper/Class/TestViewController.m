//
//  TestViewController.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-11.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "TestViewController.h"
#import "UIButton+Bootstrap.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
    //self.view.backgroundColor = [UIColor grayColor];
	// Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"我的壁纸" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 100, 30);
    //[button setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    [button successStyle];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
