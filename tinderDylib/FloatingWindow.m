#import "FloatingWindow.h"
#import "FloatingExtendVC.h"

@interface FloatingWindow ()

@property (nonatomic, copy) void (^actionBlock)(void);
@property (nonatomic, strong) UIButton *floatingButton;

@end

@implementation FloatingWindow

+ (instancetype)shared {
    static FloatingWindow *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat buttonW = 44;
        CGFloat centerY = (screenHeight - buttonW) / 2;
        CGRect frame = CGRectMake(0, centerY, buttonW, buttonW);
        
        instance = [[FloatingWindow alloc] initWithFrame:frame];
        instance.windowLevel = UIWindowLevelAlert + 1;
        instance.backgroundColor = [UIColor clearColor];
        [instance setupFloatingButton];
    });
    return instance;
}

- (void)setupFloatingButton {
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = self.bounds;
    self.floatingButton.layer.cornerRadius = self.bounds.size.width / 2;
    self.floatingButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.floatingButton.layer.masksToBounds = YES;

    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:32 weight:UIImageSymbolWeightRegular];
        UIImage *gearImage = [UIImage systemImageNamed:@"gear" withConfiguration:config];
        [self.floatingButton setImage:gearImage forState:UIControlStateNormal];
    } else {
        [self.floatingButton setTitle:@"调试" forState:UIControlStateNormal];
    }

    self.floatingButton.tintColor = [UIColor whiteColor];
    [self.floatingButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];

    [self addSubview:self.floatingButton];
}

- (void)setActionBlock:(void (^)(void))block {
    _actionBlock = block;
}

#pragma mark - Button Action

- (void)tapAction {
    if (_actionBlock) {
        _actionBlock();
    }
    
    UIViewController *topVC = [self topMostViewControllerFrom:[self mainApplicationWindow].rootViewController];
    if ([topVC isKindOfClass:UIAlertController.class]) {
        return;
    }
    if ([topVC isKindOfClass:[FloatingExtendVC class]]) {
        NSLog(@"目标VC已存在，取消重复打开");
        [topVC.navigationController popToRootViewControllerAnimated:YES];
        [topVC dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    FloatingExtendVC *vc = [[FloatingExtendVC alloc] init];
    if (topVC.navigationController) {
        for (UIViewController *vcInNav in topVC.navigationController.viewControllers) {
            if ([vcInNav isKindOfClass:[vc class]]) {
                NSLog(@"目标VC已在导航栈中，取消重复push");
                return;
            }
        }
        [topVC.navigationController pushViewController:vc animated:YES];
    } else {
        if ([topVC.presentedViewController isKindOfClass:[vc class]]) {
            NSLog(@"目标VC已被present，取消重复present");
            return;
        }
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [topVC presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - Dragging

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    CGPoint newCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    self.center = newCenter;
    [gesture setTranslation:CGPointZero inView:self];

    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self adjustPosition];
    }
}

- (void)adjustPosition {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat btnWidth = self.frame.size.width;
    CGFloat btnHeight = self.frame.size.height;

    CGFloat safeTop = [self safeAreaTop];
    CGFloat safeBottom = [self safeAreaBottom];

    CGFloat newY = self.frame.origin.y;
    CGFloat minY = safeTop + 10;
    CGFloat maxY = screenHeight - btnHeight - safeBottom - 10;
    newY = MAX(minY, MIN(maxY, newY));

    CGFloat newX = (self.center.x < screenWidth / 2) ? 0 : (screenWidth - btnWidth);

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(newX, newY, btnWidth, btnHeight);
    }];
}

#pragma mark - Top VC

- (UIViewController *)topMostViewControllerFrom:(UIViewController *)vc {
    UIViewController *current = vc;
    while (current.presentedViewController) {
        current = current.presentedViewController;
    }
    if ([current isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)current).visibleViewController;
    } else if ([current isKindOfClass:[UITabBarController class]]) {
        return [self topMostViewControllerFrom:((UITabBarController *)current).selectedViewController];
    } else {
        return current;
    }
}

#pragma mark - Safe Area

- (CGFloat)safeAreaTop {
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.keyWindow.safeAreaInsets.top;
    }
    return 0;
}

- (CGFloat)safeAreaBottom {
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
    }
    return 0;
}

//主应用 window
- (UIWindow *)mainApplicationWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *window in ((UIWindowScene *)scene).windows) {
                    if (window.windowLevel == UIWindowLevelNormal && window.isHidden == NO) {
                        return window;
                    }
                }
            }
        }
    }
    // iOS 13 以下 fallback
    return [UIApplication sharedApplication].keyWindow;
}

@end
