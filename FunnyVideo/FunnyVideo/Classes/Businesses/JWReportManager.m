//
//  JWReportManager.m
//  FunnyVideo
//
//  Created by JatWaston on 14-12-9.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWReportManager.h"

@implementation JWReportManager

+ (JWReportManager*)defaultManager {
    static JWReportManager *_manager = nil;
    if (_manager == nil) {
        _manager = [[JWReportManager alloc] init];
    }
    return _manager;
}


@end
