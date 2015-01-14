//
//  Global.m
//  FunnyVideo
//
//  Created by JatWaston on 15-1-14.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import "Global.h"

@implementation Global

+ (Global*)shareInstance {
    static Global *_instance = nil;
    if (_instance == nil) {
        _instance = [[Global alloc] init];
    }
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.isInPushContent = NO;
    }
    return self;
}

@end
