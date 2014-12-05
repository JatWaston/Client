//
//  JWVersionUpdateManager.m
//  FunnyVideo
//
//  Created by zhengzhilin on 14-12-5.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWVersionUpdateManager.h"
#import "JWNetworking.h"

typedef NS_ENUM(NSUInteger,JWUpdateAlertViewTag)
{
    JWNoneUpdate = 0,
    JWForceUpdate,
    JWNormalUpdate,
};


@interface JWVersionUpdateManager() <UIAlertViewDelegate> {
    BOOL _isRequesting;
}

@property (nonatomic, strong) JWNetworking *networking;
@property (nonatomic, strong) NSString *storeURL;

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
    NSArray *array = nil;
    if (messageInfo) {
        array = [messageInfo valueForKey:@"data"];
    }
    if (array == nil || [array count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"当前已经是最新版本了"
                                                           delegate:[JWVersionUpdateManager defaultManager]
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        alertView.tag = JWNoneUpdate;
        [alertView show];
    } else {
        NSDictionary *info = [array objectAtIndex:0];
        NSString *title = [info valueForKey:@""];
        NSString *message = [info valueForKey:@""];
        BOOL forceUpdate = [[info valueForKey:@""] boolValue];
        self.storeURL = [info valueForKey:@""];
        
        UIAlertView *alertView = nil;
        switch (forceUpdate) {
            case YES:
                alertView = [[UIAlertView alloc] initWithTitle:title
                                                       message:message
                                                      delegate:[JWVersionUpdateManager defaultManager]
                                             cancelButtonTitle:@"更新"
                                             otherButtonTitles:nil];
                alertView.tag = JWForceUpdate;
                break;
            case NO:
                alertView = [[UIAlertView alloc] initWithTitle:title
                                                       message:message
                                                      delegate:[JWVersionUpdateManager defaultManager]
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"更新",nil];
                alertView.tag = JWNormalUpdate;
                break;
            default:
                break;
        }
        [alertView show];
    }

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case JWNoneUpdate:
            break;
        case JWForceUpdate:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.storeURL]];
            break;
        case JWNormalUpdate:
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.storeURL]];
            }
            break;
        default:
            break;
    }
}

@end
