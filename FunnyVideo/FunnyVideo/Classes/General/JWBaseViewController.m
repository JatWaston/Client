//
//  JWBaseViewController.m
//  DuoJoke
//
//  Created by JatWaston on 14-10-21.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWBaseViewController.h"
#import "UIViewController+Compatibility.h"
#import "JWNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

///////////////////////////
#import "UIColor+Colours.h"

#define NavBarFrame self.navigationController.navigationBar.frame

@class JWBaseTableViewController;

@interface JWBaseViewController () <UIGestureRecognizerDelegate>
{
    NSString *_requestURL;
    NSString *_cachePath;
    JWNetworking *_networking;
    NSDictionary *_resultData;
}

@property (nonatomic, strong) NSString *requestURL;
@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) JWNetworking *networking;
@property (nonatomic, strong) NSDictionary *resultData;

@property (weak, nonatomic) UIView *scrollView;
@property (retain, nonatomic)UIPanGestureRecognizer *panGesture;
@property (retain, nonatomic)UIView *overLay;
@property (assign, nonatomic)BOOL isHidden;

@end

@implementation JWBaseViewController
@synthesize requestURL = _requestURL;
@synthesize resultData = _requestData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRequestURL:(NSString*)requestURL
{
    self = [super init];
    if (self) {
        self.requestURL = requestURL;
    }
    return self;
}

- (id)initWithRequestURL:(NSString*)requestURL cachePath:(NSString*)cachePath
{
    self = [self initWithRequestURL:requestURL];
    if (self) {
        self.cachePath = cachePath;
    }
    return self;
}

//设置跟随滚动的滑动试图
-(void)followRollingScrollView:(UIView *)scrollView
{
    self.scrollView = scrollView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] init];
    self.panGesture.delegate=self;
    self.panGesture.minimumNumberOfTouches = 1;
    [self.panGesture addTarget:self action:@selector(handlePanGesture:)];
    [self.scrollView addGestureRecognizer:self.panGesture];
    
    self.overLay = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    self.overLay.alpha=0;
    self.overLay.backgroundColor=self.navigationController.navigationBar.barTintColor;
    [self.navigationController.navigationBar addSubview:self.overLay];
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationWillEnterForeground
{
    [self hiddenNavigationBar:NO];
}

#pragma mark - 兼容其他手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - 手势调用函数
-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:[self.scrollView superview]];
    
    //显示
    if (translation.y >= 5) {
        [self hiddenNavigationBar:NO];
    }
    
    //隐藏
    if (translation.y <= -20) {
        [self hiddenNavigationBar:YES];
    }
}

- (void)hiddenNavigationBar:(BOOL)hidden {
    switch (hidden) {
        case YES:
            if (!self.isHidden) {
                CGRect frame =NavBarFrame;
                CGRect scrollViewFrame=self.scrollView.frame;
                frame.origin.y = -24;
                scrollViewFrame.origin.y -= 44;
                scrollViewFrame.size.height += 44;
                
                [UIView animateWithDuration:0.2 animations:^{
                    NavBarFrame = frame;
                    self.scrollView.frame=scrollViewFrame;
                } completion:^(BOOL finished) {
                    self.overLay.alpha=1;
                }];
                self.isHidden=YES;
            }

            break;
        case NO:
            if (self.isHidden) {
                self.overLay.alpha=0;
                CGRect navBarFrame=NavBarFrame;
                CGRect scrollViewFrame=self.scrollView.frame;
                
                navBarFrame.origin.y = 20;
                scrollViewFrame.origin.y += 44;
                scrollViewFrame.size.height -= 44;
                
                [UIView animateWithDuration:0.2 animations:^{
                    NavBarFrame = navBarFrame;
                    self.scrollView.frame=scrollViewFrame;
                }];
                self.isHidden= NO;
            }

            break;
            
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
    self.overLay.alpha = 0;
//    CGRect navBarFrame = NavBarFrame;
//    if (navBarFrame.origin.y == 20) {
//        [self hiddenNavigationBar:YES];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self setLayoutCompatibleWithLowerVersion];
    if (CURRENT_SYSTEM_VERSION < 7.0f) {
        [[UINavigationBar appearance] setTintColor:[UIColor orangeColor]];
    } else {
        [[UINavigationBar appearance] setBarTintColor:[UIColor skyBlueColor]];
        [self.navigationController.navigationBar setTranslucent:YES];
    }
}

- (void)requestURLWithPath:(NSString*)urlPath forceRequest:(BOOL)isForce showHUD:(BOOL)show
{
    switch ((Boolean)isForce) {
        case YES:
            if (urlPath == nil || urlPath.length == 0) {
                return;
            }
            if (_isRequesting && self.networking) {
                [self.networking cancelRequest];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            break;
        case NO:
            if (_isRequesting || urlPath == nil || urlPath.length == 0) {
                return;
            }
            break;
        default:
            break;
    }
    if (show) {
        [MBProgressHUD showMessag:@"获取数据中..." toView:self.view];
    }
    
    _isRequesting = YES;
    self.networking = [[JWNetworking alloc] init];
    [self.networking requestWithURL:urlPath requestMethod:JWRequestMethodGet params:nil requestComplete:^(NSData *data, NSError *error) {
        _isRequesting = NO;
        if (show) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        if (error) {
            self.resultData = nil;
        } else {
            self.resultData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        }
        [self handleResult:self.resultData];
        if ([self isKindOfClass:NSClassFromString(@"JWBaseQuiltViewController")]) {
            NSLog(@"JWBaseQuiltViewController");
        } else if ([self isKindOfClass:NSClassFromString(@"JWBaseTableViewController")]) {
            NSLog(@"JWBaseTableViewController");
        }
    }];
}

- (void)handleResult:(NSDictionary*)result
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}




@end
