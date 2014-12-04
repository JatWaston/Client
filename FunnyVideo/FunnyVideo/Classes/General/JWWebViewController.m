//
//  JWWebViewController.m
//  FunnyVideo
//
//  Created by zhengzhilin on 14/12/4.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWWebViewController.h"

@interface JWWebViewController ()
{
    UIWebView *_webView;
    NSURL *_url;
}

@property (nonatomic, strong) NSURL *url;

@end

@implementation JWWebViewController
@synthesize url = _url;

- (id)initWithURL:(NSURL*)webURL {
    if (self = [super init]) {
        self.url = webURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = [UIColor clearColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
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
