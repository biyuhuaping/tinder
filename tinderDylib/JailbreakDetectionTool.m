//
//  JailbreakDetectionTool.m
//  WePopDylib
//
//  Created by ZB on 2025/4/11.
//

#import "JailbreakDetectionTool.h"
#import <mach-o/dyld.h>
#import <objc/runtime.h>

#import <dlfcn.h>
#import <sys/stat.h>
#import <mach-o/dyld.h>

@implementation JailbreakDetectionTool

+ (BOOL)isInjected {
    BOOL isIn = [self hasDYLDEnv] || [self hasSuspiciousDylibs] || [self hasSuspiciousClass];
    if (isIn) {
        NSLog(@"❗发现动态库注入，建议退出或限制功能！");
    } else {
        NSLog(@"✅ 无注入行为");
    }
    return isIn;
}

#pragma mark - 检测 DYLD_INSERT_LIBRARIES 环境变量

+ (BOOL)hasDYLDEnv {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env != NULL) {
        NSLog(@"⚠️ 动态库检测：DYLD_INSERT_LIBRARIES 被设置为：%s", env);
        return YES;
    }
    return NO;
}

#pragma mark - 检测加载的动态库

+ (BOOL)hasSuspiciousDylibs {
    NSArray *suspiciousLibs = @[@"MobileSubstrate", @"SubstrateInserter", @"TweakInject", @"libhooker", @"CydiaSubstrate"];
    uint32_t count = _dyld_image_count();
    
    for (uint32_t i = 0; i < count; i++) {
        const char *cname = _dyld_get_image_name(i);
        NSString *libName = [NSString stringWithUTF8String:cname];
        
        for (NSString *keyword in suspiciousLibs) {
            if ([libName.lowercaseString containsString:keyword.lowercaseString]) {
                NSLog(@"⚠️ 动态库检测：可疑 dylib: %@", libName);
                return YES;
            }
        }
    }
    return NO;
}

+ (void)printAllDylibs {
    uint32_t count = _dyld_image_count();
    NSLog(@"📦 当前加载的动态库列表：");
    for (uint32_t i = 0; i < count; i++) {
        const char *cname = _dyld_get_image_name(i);
        NSLog(@"- %s", cname);
    }
}

#pragma mark - 检测异常类

+ (BOOL)hasSuspiciousClass {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
        
    for (int i = 0; i < numClasses; i++) {
        NSString *className = NSStringFromClass(classes[i]);
        
        // 跳过系统内部类名
        NSSet *safeSet = [NSSet setWithObjects:@"_UIContextBinderSubstrate", nil];
        if ([safeSet containsObject:className]) continue;
        
        const char *imageName = class_getImageName(classes[i]);
        NSString *imagePath = imageName ? [NSString stringWithUTF8String:imageName] : @"";
        if ([imagePath hasPrefix:@"/System/Library/"]) {
            // 属于系统，不输出警告
            continue;
        }

        if ([className hasPrefix:@"Cydia"] || [className.lowercaseString containsString:@"substrate"]) {
            NSLog(@"⚠️ 动态库检测：可疑类名: %@", className);
            
            // 查看该类来自哪个动态库
            Dl_info info;
            if (dladdr((__bridge const void *)(classes[i]), &info)) {
                NSLog(@"🔎 类 %@ 来源于: %s", className, info.dli_fname);
            }
        }
    }
    free(classes);
    return NO;
}

#pragma mark - 是否越狱
+ (BOOL)isDeviceJailbroken {
#if TARGET_IPHONE_SIMULATOR
    return NO; // 模拟器不越狱
#endif
    if ([self hasJailbreakFiles]) return YES;
    if ([self canAccessOutsideSandbox]) return YES;
    if ([self hasSuspiciousDyldInject]) return YES;
    if ([self hasCydiaInstalled]) return YES;
    return NO;
}

#pragma mark - 检查路径

+ (BOOL)hasJailbreakFiles {
    NSArray *jbPaths = @[
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/usr/sbin/sshd",
        @"/etc/apt",
        @"/private/var/lib/apt/",
        @"/private/var/stash"
    ];
    
    for (NSString *path in jbPaths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSLog(@"DYLD注入:1 %@",path);
            return YES;
        }
    }
    return NO;
}

#pragma mark - 检查越权访问

+ (BOOL)canAccessOutsideSandbox {
    NSError *error;
    NSString *testStr = @"test";
    [testStr writeToFile:@"/private/jb_test.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/jb_test.txt" error:nil];
        return YES;
    }
    return NO;
}

#pragma mark - 检查DYLD注入
BOOL isTrustedPath(NSString *path) {
    return ([path hasPrefix:@"/System/Library/"] ||
            [path hasPrefix:@"/usr/lib/"] ||
            [path hasPrefix:NSBundle.mainBundle.bundlePath] ||
            [path hasPrefix:@"/Developer/Library/"] ||
            [path hasPrefix:@"/private/preboot/Cryptexes/OS/"]);
}

+ (BOOL)hasSuspiciousDyldInject {
    uint32_t count = _dyld_image_count();
    
    BOOL hasIn = NO;
    for (uint32_t i = 0; i < count; i++) {
        const char *imageName = _dyld_get_image_name(i);
        NSString *path = [NSString stringWithUTF8String:imageName];
        
        if (!isTrustedPath(path)) {
            if ([path containsString:@".dylib"] || [path containsString:@".framework"]) {
                NSLog(@"⚠️ DYLD注入: %@", path);
                hasIn = YES;
            }
        }
    }
    return hasIn;
}

#pragma mark - 检查环境变量

+ (BOOL)hasCydiaInstalled {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env != NULL) {
        return YES;
    }
    return NO;
}

+ (void)logSuspiciousIndicators {
    NSLog(@"[JailbreakDetectionTool] 是否检测到越狱文件: %@", [self hasJailbreakFiles] ? @"✅ 是" : @"❌ 否");
    NSLog(@"[JailbreakDetectionTool] 是否越权写文件: %@", [self canAccessOutsideSandbox] ? @"✅ 是" : @"❌ 否");
    NSLog(@"[JailbreakDetectionTool] 是否注入可疑动态库: %@", [self hasSuspiciousDyldInject] ? @"✅ 是" : @"❌ 否");
    NSLog(@"[JailbreakDetectionTool] 是否存在DYLD_INSERT_LIBRARIES: %@", [self hasCydiaInstalled] ? @"✅ 是" : @"❌ 否");
}

@end

