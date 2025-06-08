//
//  FloatingWindow.h
//  WePopDylib
//
//  Created by ZB on 2025/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FloatingWindow : UIWindow

+ (instancetype)shared;

/// 设置点击回调
- (void)setActionBlock:(void (^)(void))action;

@end

NS_ASSUME_NONNULL_END
