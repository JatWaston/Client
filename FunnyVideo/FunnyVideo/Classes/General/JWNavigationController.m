//
//  JWNavigationController.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-11.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWNavigationController.h"
#import "UIViewController+Compatibility.h"
//#import "UIViewController+RESideMenu.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"

@interface JWNavigationController ()

@end

@implementation JWNavigationController

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
    [self setLayoutCompatibleWithLowerVersion];
    
    //去除ios6，7导航栏下面的分割线
    if (CURRENT_SYSTEM_VERSION >= 6) {
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_background.png"] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kNavBarTextColor,
                                                   NSFontAttributeName:kNavBarTextFont,
                                                   UITextAttributeTextShadowOffset:@0};
        
    }
    else
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_background2.png"] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kNavBarTextColor, NSFontAttributeName:kNavBarTextFont};
        
    }
    [self addDevisionLine];
}

- (void)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

- (void)addDevisionLine
{
    CGSize size = self.navigationBar.frame.size;
    float lineHeight = 1.0f;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, size.height-lineHeight, size.width, lineHeight)];
    line.backgroundColor = [UIColor colorWithRed:0.85 green:0.87 blue:0.89 alpha:1.0];
    [self.navigationBar addSubview:line];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
