//
//  Global.h
//  FunnyVideo
//
//  Created by JatWaston on 15-1-14.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

@property (nonatomic, assign) BOOL isInPushContent;

+ (Global*)shareInstance;

@end
