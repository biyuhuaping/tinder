//
//  JailbreakDetectionTool.h
//  WePopDylib
//
//  Created by ZB on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JailbreakDetectionTool : NSObject

/// 是否检测到注入（任一方法命中即为 YES）
+ (BOOL)isInjected;

/// 打印当前加载的所有动态库
+ (void)printAllDylibs;

/// 检测是否越狱
+ (BOOL)isDeviceJailbroken;

/// 打印所有可疑项（仅调试使用）
+ (void)logSuspiciousIndicators;

@end

NS_ASSUME_NONNULL_END
