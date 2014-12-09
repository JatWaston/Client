//
//  VideoViewController.m
//  VideoDemo
//
//  Created by JatWaston on 14/12/4.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController () {
    UIWebView *_webView;
}

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.backgroundColor = [UIColor clearColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://v.youku.com/v_show/id_XODM2MTQyMTY4.html"]];
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
