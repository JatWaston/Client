//
//  UtilManager.m
//  Wallpaper
//
//  Created by JatWaston on 14-10-6.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "UtilManager.h"

typedef NS_ENUM(NSInteger, NSDevicePlatform)
{
    iPhoneDevice = 0,
    iPhone5Device,
    iPhone6Device,
};

static UtilManager *_manager = nil;
static BOOL _iPhone5Device = NO;

@implementation UtilManager

+ (UtilManager*)shareManager
{
    if (_manager == nil)
    {
        _manager = [[UtilManager alloc] init];
        _iPhone5Device = iPhone5;
    }
    return _manager;
}

- (BOOL)isiPhone5
{
    return _iPhone5Device;
}

- (NSString*)additionlParamURL:(NSString*)url
{
    NSRange range = [url rangeOfString:@"?"];
    NSString *placeholder = @"?";
    if (range.location != NSNotFound)
    {
        placeholder = @"&";
    }
    int store = 0;
#ifdef APP_STORE
    store = 1;
#endif

    NSString *additionURL;
    if ([[UtilManager shareManager] isiPhone5])
    {
        additionURL = [url stringByAppendingString:[NSString stringWithFormat:@"%@platform=%d&store=%d",placeholder,(int)iPhone5Device,store]];
    }
    else
    {
        additionURL = [url stringByAppendingString:[NSString stringWithFormat:@"%@platform=%d&store=%d",placeholder,(int)iPhoneDevice,store]];
    }
    NSLog(@"additionURL = %@",additionURL);
    return additionURL;
}

@end
