//
//  JWCacheManager.h
//  Wallpaper
//
//  Created by JatWaston on 14-9-18.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCacheManager : NSObject

// 读入配置信息
+ (void)read:(NSString *)filePath key:(NSString *)rootKey array:(NSMutableArray *)array;
+ (void)readDictonary:(NSString *)filePath key:(NSString *)rootKey dictionary:(NSMutableDictionary *)dictionary;

// 写入配置信息
+ (void)writeWithContent:(NSArray *)array name:(NSString *)name key:(NSString *)key;
+ (void)writeDictionaryWithContent:(NSDictionary *)dictionary name:(NSString *)name key:(NSString *)key;

// 删除配置信息
+ (BOOL)deleteCacheFileWithPath:(NSString *)filePath;

// 在PANDASPACE_ROOT 没有path时，创建path
+ (NSString *)createDirectory:(NSString *)path;
+ (NSString *)createDirectoryWithAbsolutePath:(NSString *)path;

//获取文件夹大小
+ (NSString *)directorySizeWithString:(NSString *)path;
+ (unsigned long long int)directorySizeWithFloat:(NSString *)path;

@end
