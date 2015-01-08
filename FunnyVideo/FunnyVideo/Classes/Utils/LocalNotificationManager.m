//
//  LocalNotificationManager.m
//  ScheduleLocalNotification
//
//  Created by JatWaston on 15-1-8.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import "LocalNotificationManager.h"

@implementation LocalNotificationManager

+ (LocalNotificationManager*)defaultManager {
    static LocalNotificationManager *_manager = nil;
    if (_manager == nil) {
        _manager = [[LocalNotificationManager alloc] init];
    }
    return _manager;
}

- (id)init {
    if (self = [super init]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge) categories:nil]];
        }
    }
    return self;
}

- (NSDate*)createTimeWithString:(NSString*)timeStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeStr];
    return date;
}

- (void)pushNotificationMessage:(NSString*)message
                       userInfo:(NSDictionary*)info
                       pushTime:(NSDate*)time
                       pushRate:(NSCalendarUnit)repeatInterval {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil)
    {
        notification.fireDate = time; //触发通知的时间
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = message;
        notification.alertAction = @"打开";  //提示框按钮
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        notification.repeatInterval = repeatInterval;
        notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字,0意味着不变
        notification.userInfo = info;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
