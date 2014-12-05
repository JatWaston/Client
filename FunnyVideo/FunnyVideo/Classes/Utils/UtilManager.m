//
//  UtilManager.m
//  Wallpaper
//
//  Created by JatWaston on 14-10-6.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "UtilManager.h"
#import <AdSupport/AdSupport.h>
#import <sys/utsname.h>

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

    NSString *additionURL;
    if ([[UtilManager shareManager] isiPhone5])
    {
        additionURL = [url stringByAppendingString:[NSString stringWithFormat:@"%@platform=%d",placeholder,(int)iPhone5Device]];
    }
    else
    {
        additionURL = [url stringByAppendingString:[NSString stringWithFormat:@"%@platform=%d",placeholder,(int)iPhoneDevice]];
    }
    return additionURL;
}

- (JWStorePlatform)storePlatform {
#ifdef APP_STORE
    
    return JWAppStorePlatform;
#else 
    return JW91SttorePlatform;
#endif
}

- (CGFloat)heightForText:(NSString *)text rectSize:(CGSize)frameSize font:(UIFont*)font
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:frameSize
                                     options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                  attributes:attrbute
                                     context:nil];
    //NSLog(@"rect = %@",NSStringFromCGRect(rect));
    return rect.size.height;
    
}

- (NSString*)deviceUDID {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}

- (NSString*)appVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return [info valueForKey:@"CFBundleVersion"];
}

- (NSString*)deviceSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString*)devicePlatform {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

- (NSString *)urlEncodeUnicode:(NSString *)url
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,NULL,kCFStringEncodingUTF8));
}

- (NSString*)addParamsForURL:(NSString*)url {
    
    if (url == nil) {
        return url;
    }
    
    if ([url rangeOfString:@"?"].location == NSNotFound) {
        url = [NSString stringWithFormat:@"%@?",url];
    }
    
    NSString *baseUrl = [url substringToIndex:[url rangeOfString:@"?"].location+1];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    
    NSURL *_url = [NSURL URLWithString:url];
    if (_url == nil) {
        _url = [NSURL URLWithString:[[UtilManager shareManager] urlEncodeUnicode:url]];
    }
    NSString *query = [_url query];
    NSArray *array = [query componentsSeparatedByString:@"&"];
    
    for (NSString *s in array)
    {
        NSArray *item = [s componentsSeparatedByString:@"="];
        if (item.count == 2) {
            [dic setObject:[item objectAtIndex:1] forKey:[item objectAtIndex:0]];
            
        }
    }

    //添加版本号
    [dic setObject:[[UtilManager shareManager] appVersion] forKey:@"version"];
    //添加设备名称
    [dic setObject:[[UtilManager shareManager] devicePlatform] forKey:@"device"];
    //添加设备版本号
    [dic setObject:[[UtilManager shareManager] deviceSystemVersion] forKey:@"osVer"];
    //添加平台(AppStore or 91)
    [dic setObject:[NSNumber numberWithInt:[[UtilManager shareManager] storePlatform]] forKey:@"store"];
    //添加UDID
    [dic setObject:[[UtilManager shareManager] deviceUDID] forKey:@"udid"];
    
    int i=0;
    for (NSString *key in dic)
    {
        if (i==dic.count-1) {
            baseUrl = [NSString stringWithFormat:@"%@%@=%@",baseUrl,key,[dic objectForKey:key]];
        } else {
            baseUrl = [NSString stringWithFormat:@"%@%@=%@&",baseUrl,key,[dic objectForKey:key]];
        }
        i++;
    }

    return baseUrl;
}

@end
