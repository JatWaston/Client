//
//  JWReportManager.m
//  FunnyVideo
//
//  Created by JatWaston on 14-12-9.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWReportManager.h"
#import "JWNetworking.h"
#import "UtilManager.h"
#import "NSString+MD5.h"

@interface JWReportManager()

- (void)reportToServerWithValue:(NSString*)value record:(NSString*)recordId contentType:(JWContentType)type;

@end

@implementation JWReportManager

+ (JWReportManager*)defaultManager {
    static JWReportManager *_manager = nil;
    if (_manager == nil) {
        _manager = [[JWReportManager alloc] init];
    }
    return _manager;
}

- (void)updatePlayCountWithRecord:(NSString*)recordId contentType:(JWContentType)type {
    [[JWReportManager defaultManager] reportToServerWithValue:@"playCount" record:recordId contentType:type];
}

- (void)updateLikeCountWithRecord:(NSString*)recordId contentType:(JWContentType)type {
    [[JWReportManager defaultManager] reportToServerWithValue:@"likeCount" record:recordId contentType:type];
}

- (void)updateUnlikeCountWithRecord:(NSString*)recordId contentType:(JWContentType)type {
    [[JWReportManager defaultManager] reportToServerWithValue:@"unlikeCount" record:recordId contentType:type];
}

- (void)reportToServerWithValue:(NSString*)value record:(NSString*)recordId contentType:(JWContentType)type {
    NSString *requestURL = [[UtilManager shareManager] addParamsForURL:kReportURL];
    NSString *contentType = (type == JWVideoType ? @"video" : @"joke");
    NSString *md5 = [[NSString stringWithFormat:@"%@%@%@%@",contentType,value,recordId,kValidStr] MD5];
    requestURL = [NSString stringWithFormat:@"%@&type=%@&id=%@&report=%@&valid=%@",requestURL,contentType,recordId,value,md5];
    JWNetworking *netwroking = [[JWNetworking alloc] init];
    [netwroking requestWithURL:requestURL requestMethod:JWRequestMethodGet params:nil requestComplete:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            NSLog(@"report result = %@",result);
        }
    }];
}



@end
