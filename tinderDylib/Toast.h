//
//  Toast.h
//  DCDAPPDylib
//
//  Created by ZB on 2025/4/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Toast : NSObject

+ (void)showToast:(NSString *)message;

+ (void)showToast:(NSString *)message duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
