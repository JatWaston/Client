//
//  JWCacheManager.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-18.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWCacheManager.h"

@implementation JWCacheManager

// 创建文件夹
+ (NSString *)createDirectory:(NSString *)path
{
    BOOL        isDir = NO;
    NSString    *finalPath = [[NSString alloc] initWithFormat:@"%@/%@", CACHE_PATH, path];
    
    if (!([[NSFileManager defaultManager] fileExistsAtPath:finalPath isDirectory:&isDir] && isDir)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:finalPath
                                 withIntermediateDirectories :YES
                                 attributes                  :nil
                                 error                       :nil];
    }
    
    return finalPath;
}


+ (NSString *)createDirectoryWithAbsolutePath:(NSString *)path
{
    BOOL        isDir = NO;
    
    if (!([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    return path;
}

// 读入配置信息
+ (void)read:(NSString *)filePath key:(NSString *)rootKey array:(NSMutableArray *)array
{
    if ((array == nil) || (filePath == nil) || (rootKey == nil)) {
        return;
    }
    
    NSString *finalPath = [[NSString alloc] initWithFormat:@"%@/dataCache/%@", CACHE_PATH, filePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalPath] || (rootKey == nil)) {
        return;
    }
    
    @autoreleasepool {
        NSData *data = [[NSData alloc] initWithContentsOfFile:finalPath];
        
        NSKeyedUnarchiver   *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableArray      *arr = (NSMutableArray *)[unarchiver decodeObjectForKey:rootKey];
        
        if ((arr != nil) && ([arr count] > 0)) {
            [array removeAllObjects];
            [array addObjectsFromArray:arr];
        }
        
        [unarchiver finishDecoding];
    }
}

// 读入配置信息
+ (void)readDictonary:(NSString *)filePath key:(NSString *)rootKey dictionary:(NSMutableDictionary *)dictionary
{
    if ((dictionary == nil) || (filePath == nil) || (rootKey == nil)) {
        return;
    }
    
    NSString *finalPath = [[NSString alloc] initWithFormat:@"%@/dataCache/%@", CACHE_PATH, filePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalPath] || (rootKey == nil)) {
        return;
    }
    
    @autoreleasepool {
        NSData *data = [[NSData alloc] initWithContentsOfFile:finalPath];
        
        NSKeyedUnarchiver   *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableDictionary      *arr = (NSMutableDictionary *)[unarchiver decodeObjectForKey:rootKey];
        
        if ((arr != nil) && ([arr count] > 0)) {
            [dictionary removeAllObjects];
            for (id key in [arr allKeys]) {
                [dictionary setObject:[arr objectForKey:key] forKey:key];
            }
        }
        
        [unarchiver finishDecoding];
    }
}

// 写入配置信息
+ (void)writeWithContent:(NSArray *)array name:(NSString *)filePath key:(NSString *)rootKey
{
    [self createDirectory:@"dataCache"];
    if ((array == nil) || (filePath == nil) || (rootKey == nil)) {
        return;
    }
    
    NSString *finalPath = [[NSString alloc] initWithFormat:@"%@/dataCache/%@", CACHE_PATH, filePath];
    
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:rootKey];
    [archiver finishEncoding];
    [data writeToFile:finalPath atomically:YES];
}

// 写入配置信息
+ (void)writeDictionaryWithContent:(NSDictionary *)dictionary name:(NSString *)filePath key:(NSString *)rootKey
{
    [self createDirectory:@"dataCache"];
    if ((dictionary == nil) || (filePath == nil) || (rootKey == nil)) {
        return;
    }
    
    NSString *finalPath = [[NSString alloc] initWithFormat:@"%@/dataCache/%@", CACHE_PATH, filePath];
    
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dictionary forKey:rootKey];
    [archiver finishEncoding];
    [data writeToFile:finalPath atomically:YES];
}

+ (BOOL)deleteCacheFileWithPath:(NSString *)filePath
{
    NSString *finalPath = [[NSString alloc] initWithFormat:@"%@/dataCache/%@", CACHE_PATH, filePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalPath]) {
        return YES;
    }
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:finalPath error:&error]) {
        NSLog(@"Delete file: %@ error: %@", filePath, error);
        return NO;
    }
    
    return YES;
}

+ (unsigned long long int)directorySizeWithFloat:(NSString *)path
{
    BOOL isDirector = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirector]) {
        if (isDirector) {
            NSArray                 *filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
            NSEnumerator            *filesEnumerator = [filesArray objectEnumerator];
            NSString                *fileName;
            unsigned long long int  fileSize = 0;
            
            while (fileName = [filesEnumerator nextObject]) {
                unsigned long long int a = [JWCacheManager directorySizeWithFloat:[path stringByAppendingPathComponent:fileName]];
                fileSize += a;
            }
            
            return fileSize;
        } else {
            NSDictionary *fattrib = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            
            if (fattrib != nil) {
                return [fattrib fileSize];
            } else {
                return 0;
            }
        }
    } else {
        return 0;
    }
}

+ (NSString *)directorySizeWithString:(NSString *)path
{
    if (path == nil) {
        return nil;
    }
    
    unsigned long long int mDownloadSize = [JWCacheManager directorySizeWithFloat:path];
    
    if (mDownloadSize == 0) {
        return nil;
    } else if (mDownloadSize < 1048576) {
        // 1048576=1024*1024
        return [NSString stringWithFormat:@"%0.2fKB", mDownloadSize * 1.0f / 1024];
    } else if (mDownloadSize < 1073741524) {
        // 1073741524=1024*1024*1024
        return [NSString stringWithFormat:@"%0.2fMB", mDownloadSize * 1.0f / 1048576];
    } else {
        return [NSString stringWithFormat:@"%0.2fGB", mDownloadSize * 1.0f / 1048576 / 1024];
    }
    
    return nil;
}


@end
