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

@class JWBaseTableViewController;

@interface JWBaseViewController ()
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
