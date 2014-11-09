//
//  UtilisMacro.h
//  DuoJoke
//
//  Created by JatWaston on 14-10-14.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#ifndef DuoJoke_UtilisMacro_h
#define DuoJoke_UtilisMacro_h

#define CACHE_PATH              [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//判断设备是否是iPhone5的高度
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 获取当前系统版本号
#define CURRENT_SYSTEM_VERSION              ([[[UIDevice currentDevice] systemVersion] floatValue])

//Release模式下禁用NSLog
#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif


#endif
