//
//  JWVersionUpdateManager.m
//  FunnyVideo
//
//  Created by zhengzhilin on 14-12-5.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWVersionUpdateManager.h"
#import "JWNetworking.h"

@interface JWVersionUpdateManager() {
    BOOL _isRequesting;
}

@property (nonatomic, strong) JWNetworking *networking;

@property (nonatomic, copy) void (^requestCompleteHandle)(NSData *data, NSError *error);

@end

@implementation JWVersionUpdateManager

+ (JWVersionUpdateManager*)defaultManager {
    static JWVersionUpdateManager *_manager = nil;
    if (_manager == nil) {
        _manager = [[JWVersionUpdateManager alloc] init];
    }
    return _manager;
}

- (id)init {
    if (self = [super init]) {
        self.requestCompleteHandle = nil;
        _isRequesting = NO;
    }
    return self;
}

- (void)checkVersionUpdate:(NSString*)updateURL requestComplete:(void (^)(NSData *data, NSError *error))completeHandle {
    if (_isRequesting == NO) {
        _isRequesting = YES;
        self.requestCompleteHandle = completeHandle;
        self.networking = [[JWNetworking alloc] init];
        [self.networking requestWithURL:updateURL requestMethod:JWRequestMethodGet params:nil requestComplete:^(NSData *data, NSError *error) {
            _isRequesting = NO;
            self.requestCompleteHandle(data,error);
        }];
    } else {
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"正在请求中，请稍后请求",@"errorMessage", nil];
        NSError *error = [NSError errorWithDomain:@"com.jatwaston.updateError" code:404 userInfo:errorInfo];
        self.requestCompleteHandle(nil,error);
    }
}

- (void)showUpdateAlertView:(NSDictionary*)messageInfo {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有可更新的版本"
                                                        message:@"更新内容"
                                                       delegate:[JWVersionUpdateManager defaultManager]
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"更新", nil];
    [alertView show];
}

@end
