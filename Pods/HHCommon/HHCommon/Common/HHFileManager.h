//
//  HHFileManager.h
//  HHCommon
//
//  Created by yufeng on 2022/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHFileManager : NSObject

+ (NSString *)pathForDocumentsDirectory;
+ (NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path;
+ (NSString *)pathForLibraryDirectory;
+ (NSString *)pathForLibraryDirectoryWithPath:(NSString *)path;
+ (NSString *)pathForTemporaryDirectory;
+ (NSString *)pathForTemporaryDirectoryWithPath:(NSString *)path;
+ (NSString *)pathForCachesDirectory;
+ (NSString *)pathForCachesDirectoryWithPath:(NSString *)path;
+ (NSString *)pathForMainBundleDirectory;
+ (NSString *)pathForMainBundleDirectoryWithPath:(NSString *)path;
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;
+ (BOOL)existItemAtPath:(NSString *)path;
+ (BOOL)existFileAtPath:(NSString *)path;
+ (BOOL)existDirectoryAtPath:(NSString *)path;
+ (BOOL)removeItemAtPath:(NSString *)path;
+ (BOOL)removeItemsAtDirectory:(NSString *)path;
+ (BOOL)clearCachesDirectory;
+ (BOOL)clearTemporaryDirectory;
+ (nullable NSArray<NSString *> *)listFilesInDirectoryAtPath:(NSString *)path;
+ (long long)fileSizeAtPath:(NSString *)path;
+ (long long)fileSizeAtDirectoryPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
