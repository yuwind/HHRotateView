//
//  HHCrashCaughtHandler.m
//  HHCommon
//
//  Created by yufeng on 2022/4/22.
//

#import "HHCrashCaughtHandler.h"
#import <Objc/runtime.h>
#import <UIKit/UIKit.h>

static NSUncaughtExceptionHandler *previousExceptionHandler = nil;

@implementation HHCrashCaughtHandler

+ (void)registerCrashCaughtHandler {
#if DEBUG || ADHOC
    previousExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&caughtExceptionHandler);
#else
    registerExceptionHandler();
#endif
}

void caughtExceptionHandler(NSException * exception) {
    if (previousExceptionHandler) {
        previousExceptionHandler(exception);
    }
    //应用版本
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *version =
    [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    //设备版本
    NSString *deviceModel = @"iPhone";
    //系统版本
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    //邮件主题
    NSString *subject =
    [NSString stringWithFormat:@"[Crash][%@][%@][%@]", version, sysVersion,
     deviceModel];
    //邮箱
    NSString *mailAddress = @"hxwnan@163.com";
    //调用栈
    NSArray  *stackSysbolsArray = [exception callStackSymbols];
    //崩溃原因
    NSString *reason = [exception reason];
    //崩溃标识
    NSString *name = [exception name];
    //邮件正文
    NSString *body = [NSString stringWithFormat:@"\n崩溃标识:\n%@\n崩溃原因:\n%@\n调用堆栈:\n%@\n", name, reason, [stackSysbolsArray componentsJoinedByString:@"\n"]];
    //邮件url
    NSString *urlStr = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",mailAddress, subject, body];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

void registerExceptionHandler(void) {
    invokeHookMethod(@selector(methodSignatureForSelector:), @selector(hh_methodSignatureForSelector:));
    invokeHookMethod(@selector(forwardInvocation:), @selector(hh_forwardInvocation:));
}

- (NSMethodSignature *)hh_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = [self hh_methodSignatureForSelector:aSelector];
    if (!methodSignature) {
        methodSignature = [HHCrashCaughtHandler methodSignatureForSelector:@selector(hh_handleInvalidSelector)];
    }
    return methodSignature;
}

void invokeHookMethod(SEL origin, SEL swizzle) {
    Class class = [NSObject class];
    Class swizzleClass = [HHCrashCaughtHandler class];
    Method originalMethod = class_getInstanceMethod(class, origin);
    Method swizzledMethod = class_getInstanceMethod(swizzleClass, swizzle);
    
    BOOL didAddMethod =
    class_addMethod(class, origin, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    class_addMethod(class, swizzle, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzle, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)hh_handleInvalidSelector {}
- (void)hh_forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.methodSignature != [HHCrashCaughtHandler methodSignatureForSelector:@selector(hh_handleInvalidSelector)]) {
        [self hh_forwardInvocation:anInvocation];
    }
}

@end
