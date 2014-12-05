//
//  UtilManager.h
//  Wallpaper
//
//  Created by JatWaston on 14-10-6.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UtilManager : NSObject

+ (UtilManager*)shareManager;

- (BOOL)isiPhone5;
- (NSString*)additionlParamURL:(NSString*)url;
- (CGFloat)heightForText:(NSString *)text rectSize:(CGSize)frameSize font:(UIFont*)font;

- (NSString*)deviceUDID;
- (NSString*)appVersion;
- (NSString*)devicePlatform;
- (NSString*)deviceSystemVersion;

- (NSString*)addParamsForURL:(NSString*)url;
- (NSString *)urlEncodeUnicode:(NSString *)url; //url编码
- (JWStorePlatform)storePlatform;

@end
