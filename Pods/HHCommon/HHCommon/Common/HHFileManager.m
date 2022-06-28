//
//  HHFileManager.m
//  HHCommon
//
//  Created by yufeng on 2022/5/17.
//

#import "HHFileManager.h"

@implementation HHFileManager

+ (NSString *)pathForDocumentsDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    
    return path;
}

+ (NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path {
    return [[self pathForDocumentsDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)pathForLibraryDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    
    return path;
}

+ (NSString *)pathForLibraryDirectoryWithPath:(NSString *)path {
    return [[self pathForLibraryDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)pathForTemporaryDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        path = NSTemporaryDirectory();
    });
    
    return path;
}

+ (NSString *)pathForTemporaryDirectoryWithPath:(NSString *)path {
    return [[self pathForTemporaryDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)pathForCachesDirectory {
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    
    return path;
}

+ (NSString *)pathForCachesDirectoryWithPath:(NSString *)path {
    return [[self pathForCachesDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)pathForMainBundleDirectory {
    return [NSBundle mainBundle].resourcePath;
}

+ (NSString *)pathForMainBundleDirectoryWithPath:(NSString *)path {
    return [[self pathForMainBundleDirectory] stringByAppendingPathComponent:path];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    NSString *absolutePath = [self absolutePath:path];
    NSString *absoluteToPath = [self absolutePath:toPath];
    if (!absolutePath || !absoluteToPath) {
        return NO;
    }
    if (![self existItemAtPath:absolutePath]) {
        return NO;
    }
    if (![self existItemAtPath:absoluteToPath] || (overwrite && [self removeItemAtPath:absoluteToPath])) {
        return ([self createDirectoriesForFilePath:absoluteToPath] && [[NSFileManager defaultManager] moveItemAtPath:absolutePath toPath:absoluteToPath error:nil]);
    } else {
        return NO;
    }
}

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite {
    NSString *absolutePath = [self absolutePath:path];
    NSString *absoluteToPath = [self absolutePath:toPath];
    if (!absolutePath || !absoluteToPath) {
        return NO;
    }
    if (![self existItemAtPath:absolutePath]) {
        return NO;
    }
    if (![self existItemAtPath:absoluteToPath] || (overwrite && [self removeItemAtPath:absoluteToPath])) {
        if ([self createDirectoriesForFilePath:absoluteToPath]) {
            return [[NSFileManager defaultManager] copyItemAtPath:absolutePath toPath:absoluteToPath error:nil];;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

+ (BOOL)existItemAtPath:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path];
    if (!absolutePath) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:absolutePath];
}

+ (BOOL)existFileAtPath:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path];
    if (!absolutePath) {
        return NO;
    }
    BOOL isDirectory = NO;
    BOOL existFile = [[NSFileManager defaultManager] fileExistsAtPath:absolutePath isDirectory:&isDirectory];
    return existFile && !isDirectory;
}

+ (BOOL)existDirectoryAtPath:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path];
    if (!absolutePath) {
        return NO;
    }
    BOOL isDirectory = NO;
    BOOL existFile = [[NSFileManager defaultManager] fileExistsAtPath:absolutePath isDirectory:&isDirectory];
    return existFile && isDirectory;
}

+ (BOOL)removeItemAtPath:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path];
    if (!absolutePath) {
        return NO;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:absolutePath error:nil];
}

+ (BOOL)removeItemsAtDirectory:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path];
    if (!absolutePath) {
        return NO;
    }
    if (![self existDirectoryAtPath:absolutePath]) {
        return NO;
    }
    NSArray<NSString *> *absolutePathArray = [self listFilesInDirectoryAtPath:absolutePath];
    if (absolutePathArray.count == 0) {
        return NO;
    }
    for (NSString *resultPath in absolutePathArray) {
        [self removeItemAtPath:resultPath];
    }
    return true;
}

+ (BOOL)clearCachesDirectory {
    return [self removeItemsAtDirectory:[self pathForCachesDirectory]];
}

+ (BOOL)clearTemporaryDirectory {
    return [self removeItemsAtDirectory:[self pathForTemporaryDirectory]];
}

+ (nullable NSArray<NSString *> *)listFilesInDirectoryAtPath:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path];
    if (!absolutePath) {
        return nil;
    }
    NSArray *relativeSubpaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:absolutePath error:nil];
    NSMutableArray *absoluteSubpaths = [[NSMutableArray alloc] init];
    for (NSString *relativeSubpath in relativeSubpaths) {
        NSString *absoluteSubpath = [absolutePath stringByAppendingPathComponent:relativeSubpath];
        [absoluteSubpaths addObject:absoluteSubpath];
    }
    return [absoluteSubpaths filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
        return [self existFileAtPath:evaluatedObject];
    }]];
}

+ (long long)fileSizeAtPath:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path];
    if (!absolutePath) {
        return 0;
    }
    if (![self existFileAtPath:absolutePath]){
        return 0;
    }
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:absolutePath error:nil] fileSize];
}

+ (long long)fileSizeAtDirectoryPath:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path];
    if (!absolutePath) {
        return 0;
    }
    if (![self existDirectoryAtPath:absolutePath]) {
        return 0;
    }
    NSArray<NSString *> *listArray = [self listFilesInDirectoryAtPath:absolutePath];
    long long resultSize = 0;
    for (NSString *resultPath in listArray) {
        resultSize += [self fileSizeAtPath:resultPath];
    }
    return resultSize;
}

#pragma mark - private
+ (BOOL)createDirectoriesForFilePath:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path];
    if (!absolutePath) {
        return NO;
    }
    absolutePath = [absolutePath stringByDeletingLastPathComponent];
    return [[NSFileManager defaultManager] createDirectoryAtPath:absolutePath withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (NSString *)absolutePath:(NSString *)path {
    if (path.length == 0) {
        return nil;
    }
    if ([path isEqualToString:@"/"]) {
        return nil;
    }
    if ([path hasPrefix:@"file:///"]) {
        path = [path stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    } else if ([path hasPrefix:@"file://"]) {
        path = [path stringByReplacingOccurrencesOfString:@"file:/" withString:@""];
    }
    
    NSArray *directories = [self absoluteDirectories];
    for (NSString *directory in directories) {
        NSRange indexOfDirectoryInPath = [path rangeOfString:directory];
        if (indexOfDirectoryInPath.location != NSNotFound) {
            return path;
        }
    }
    return [self pathForLibraryDirectoryWithPath:path];
}

+ (NSArray *)absoluteDirectories {
    static NSArray *directories = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        directories = [NSArray arrayWithObjects:
                       [self pathForMainBundleDirectory],
                       [self pathForDocumentsDirectory],
                       [self pathForLibraryDirectory],
                       [self pathForCachesDirectory],
                       [self pathForTemporaryDirectory],
                       nil];
    });
    return directories;
}

@end
