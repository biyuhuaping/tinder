//
//  Toast.m
//  DCDAPPDylib
//
//  Created by ZB on 2025/4/2.
//

#import "Toast.h"

@implementation Toast

+ (void)showToast:(NSString *)message{
    [self showToast:message duration:1.2];
}

+ (void)showToast:(NSString *)message duration:(NSTimeInterval)duration {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    // 创建Label
    UILabel *toastLabel = [[UILabel alloc] init];
    toastLabel.text = message;
    toastLabel.textColor = UIColor.whiteColor;
    toastLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds = YES;
    toastLabel.numberOfLines = 0;
    
    // 自适应尺寸
    CGSize maxSize = CGSizeMake(window.bounds.size.width-40, CGFLOAT_MAX);
    CGSize textSize = [message boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:toastLabel.font} context:nil].size;
    
    toastLabel.frame = CGRectMake(0, 0, textSize.width + 40, textSize.height + 20);
    toastLabel.center = window.center;
    
    // 添加并设置动画
    [window addSubview:toastLabel];
    toastLabel.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        toastLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:duration options:0 animations:^{
            toastLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [toastLabel removeFromSuperview];
        }];
    }];
}

@end
