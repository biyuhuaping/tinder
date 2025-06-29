//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  tinderDylib.m
//  tinderDylib
//
//  Created by ZB on 2025/4/6.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

#import "tinderDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>
#import <MDConfigManager.h>
#import "FloatingWindow.h"
#import "OCMethodTrace.h"

CHConstructor{
    printf(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
//#ifndef __OPTIMIZE__
//        CYListenServer(6666);
//
//        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
//        [manager loadCycript:NO];
//
//        NSError* error;
//        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
//        NSLog(@"result: %@", result);
//        if(error.code != 0){
//            NSLog(@"error: %@", error.localizedDescription);
//        }
//#endif
        
        MDConfigManager *manager = [MDConfigManager sharedInstance];
        [manager logInitializedClasses];
        
        dispatch_after(5.0, dispatch_get_main_queue(), ^{
            FloatingWindow *window = [FloatingWindow shared];
            [window setActionBlock:^{
                NSLog(@"按钮被点击了");
            }];
            [window makeKeyAndVisible];
        });

        Class metaNSURL = object_getClass(NSClassFromString(@"NSURL")); // 关键：类方法 = 元类
        [[OCMethodTrace sharedInstance] traceMethodWithClass:metaNSURL condition:^BOOL(SEL sel) {
            // Hook 类方法，例如 URLWithString:、fileURLWithPath: 等
            NSString *selName = NSStringFromSelector(sel);
            return [selName hasPrefix:@"URL"];
        } before:^(id target, Class cls, SEL sel, NSArray *args, int deep) {
            NSLog(@"[TRACE BEFORE] +[%@ %@] args = %@", cls, NSStringFromSelector(sel), args);
            NSLog(@"[Call Stack]\n%@", [NSThread callStackSymbols]);
        } after:^(id target, Class cls, SEL sel, id ret, int deep, NSTimeInterval interval) {
            NSLog(@"[TRACE AFTER] +[%@ %@] return = %@ time = %.2fms", cls, NSStringFromSelector(sel), ret, interval * 1000);
        }];
        
//        [[OCMethodTrace sharedInstance] traceMethodWithClass:NSClassFromString(@"NSURL") condition:^BOOL(SEL sel) {
//            // 只 hook setSkipAdvancedJailbreakValidation:
//            return sel == @selector(setSkipAdvancedJailbreakValidation:);
//        } before:^(id target, Class cls, SEL sel, NSArray *args, int deep) {
//            NSLog(@"[TRACE BEFORE] %@ %@ args = %@", cls, NSStringFromSelector(sel), args);
//        } after:^(id target, Class cls, SEL sel, id ret, int deep, NSTimeInterval interval) {
//            NSLog(@"[TRACE AFTER] %@ %@ return = %@ time = %.2fms", cls, NSStringFromSelector(sel), ret, interval * 1000);
//        }];
    }];
}


CHDeclareClass(CustomViewController)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

//add new method
CHDeclareMethod1(void, CustomViewController, newMethod, NSString*, output){
    NSLog(@"This is a new method : %@", output);
}

#pragma clang diagnostic pop

CHOptimizedClassMethod0(self, void, CustomViewController, classMethod){
    NSLog(@"hook class method");
    CHSuper0(CustomViewController, classMethod);
}

CHOptimizedMethod0(self, NSString*, CustomViewController, getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);
    
    NSLog(@"origin name is:%@",originName);
    
    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);
    
    NSLog(@"password is %@",password);
    
    [self newMethod:@"output"];
    
    //set new property
    self.newProperty = @"newProperty";
    
    NSLog(@"newProperty : %@", self.newProperty);
    
    //change the value
    return @"ZB";
    
}

//add new property
CHPropertyRetainNonatomic(CustomViewController, NSString*, newProperty, setNewProperty);

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook0(CustomViewController, getMyName);
    CHClassHook0(CustomViewController, classMethod);
    
    CHHook0(CustomViewController, newProperty);
    CHHook1(CustomViewController, setNewProperty);
}

