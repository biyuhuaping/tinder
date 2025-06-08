//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  MDConfigManager.m
//  MonkeyDev
//
//  Created by AloneMonkey on 2018/4/24.
//  Copyright © 2018年 AloneMonkey. All rights reserved.
//

#define CONFIG_FILE_NAME        @"MDConfig"

#import "MDConfigManager.h"
#import <objc/runtime.h>

@implementation MDConfigManager{
    NSString* _filepath;
}

+ (instancetype)sharedInstance{
    static MDConfigManager *sharedInstance = nil;
    if (!sharedInstance){
        sharedInstance = [[MDConfigManager alloc] init];
    }
    return sharedInstance;
}

- (BOOL)isActive{
    _filepath = [[NSBundle mainBundle] pathForResource:CONFIG_FILE_NAME ofType:@"plist"];
    if(_filepath == nil){
        return NO;
    }
    return YES;
}

- (NSDictionary*) readConfigByKey:(NSString*) key{
    if([self isActive]){
        NSDictionary* contentDict = [NSDictionary dictionaryWithContentsOfFile:_filepath];
        if([contentDict.allKeys containsObject:key]){
            return contentDict[key];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

#pragma mark - Section
- (void)logInitializedClasses {
    NSArray <NSString *>*arr = [self getResourceClassNames];
    __block NSInteger biz_all_count = 0;
    __block NSInteger inited_count = 0;
    NSMutableArray *ret = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.uppercaseString hasPrefix:@"BP"] || [obj.uppercaseString hasPrefix:@"YC"]) {
            biz_all_count++;
            BOOL isInited = [self class_hasInitialized:obj.UTF8String];
            if (isInited) {
                NSLog(@"--->: %@ is init", obj);
                [ret addObject:obj];
                inited_count ++;
            }
//        }
    }];
    NSLog(@"Total Classes: %ld, Initialized: %ld", biz_all_count, biz_all_count);

//    SEL selector = NSSelectorFromString(@"currentRefreshToken");
//
//    if ([cls instancesRespondToSelector:selector]) {
//        // 实例方法
//        NSString *token = [cls performSelector:selector];
//        NSLog(@"获取的 refreshToken: %@", token);
//    } else {
//        NSLog(@"Auth.RefreshTokenInteractor 没有实现 currentRefreshToken 方法");
//    }
//
//    if ([cls respondsToSelector:@selector(currentRefreshToken)]) {
//        NSString *token = [cls performSelector:@selector(currentRefreshToken)];
//        NSLog(@"获取的 refreshToken: %@", token);
//    } else {
//        NSLog(@"Auth.RefreshTokenInteractor 没有实现 +currentRefreshToken 方法");
//    }
}

#define FAST_DATA_MASK  0x00007ffffffffff8UL
#define RW_INITIALIZED  (1<<29)

/*
// objc_class 代码片段
struct objc_class : objc_object {//8bytes
    // Class ISA;
    Class superclass;   //8bytes
    cache_t cache;      //16bytes
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
...
    class_rw_t *data() const {
        return bits.data();
    }
...
    bool isInitialized() {
        return getMeta()->data()->flags & RW_INITIALIZED;
    }
...
}
*/

//判断某个类是否已经完成了 +initialize 方法的调用，即 类是否已经初始化
- (BOOL)class_hasInitialized:(const char * _Nullable)className {
    Class metaCls = objc_getMetaClass(className); // 获取元类（Meta-Class）
    if (metaCls) {
        // https://opensource.apple.com/source/objc4/objc4-787.1/runtime/objc-runtime-new.h.auto.html
        uint64_t *bits = (__bridge void *)metaCls + 32; // 获取 `class_rw_t *` 指针
        uint32_t *data = (uint32_t *)(*bits & FAST_DATA_MASK); // 提取数据部分
        uint64_t result = (*data & RW_INITIALIZED); // 判断 `RW_INITIALIZED` 标志位
        return result != 0; // 返回是否已初始化
    }
    return false;
}

// 获取工程里的所有类
- (NSArray <NSString *>*)getResourceClassNames {
    NSArray *(^block)(const char *) = ^(const char *imageName) {
        unsigned int classCount;
        const char **classes = objc_copyClassNamesForImage(imageName, &classCount);
        NSMutableArray *arr = nil;
        if (classes && classCount) {
            arr = [NSMutableArray arrayWithCapacity:classCount];
            for (int i = 0; i < classCount; i++) {
                const char *name = classes[i];
                NSString *clsName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                [arr addObject:clsName];
                
                //打印每个类里的方法
                Class cls = NSClassFromString(clsName);
                [self printMethodsForClass:cls];
            }
            free(classes);    // runtime中包含copy的方法都需要手动free
        }
        return arr.copy;
    };
    
    NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    
    unsigned int imageCount = 0;
    const char **imageList = objc_copyImageNames(&imageCount);
    
    NSUInteger totalCount = 0;
    // image : classes names，先存dic，说不定有啥用
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:64];
    
    if (imageList && imageCount) {
        for (int i = 0; i < imageCount; i++) {
            NSString *img = [NSString stringWithCString:imageList[i] encoding:NSUTF8StringEncoding];
            if ([img rangeOfString:bundleName].location != NSNotFound) {
                NSArray *arr = block(imageList[i]);
                if (arr) {
                     dic[img] = arr;
                      totalCount += arr.count;
                }
            }
        }
        free(imageList);
    }

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:totalCount];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray *_Nonnull obj, BOOL * _Nonnull stop) {
        [arr addObjectsFromArray:obj];
    }];
    
    return arr.copy;
}

// 获取类的所有方法
- (void)printMethodsForClass:(Class)cls {
    unsigned int methodCount = 0;
    // 获取类的所有方法
    Method *methods = class_copyMethodList(cls, &methodCount);
    if (methods) {
        NSLog(@"ClassName：===== %@ =====",NSStringFromClass(cls));
        for (unsigned int i = 0; i < methodCount; i++) {
            Method method = methods[i];
            SEL methodSelector = method_getName(method);
            const char *methodName = sel_getName(methodSelector);
            NSLog(@"Cls：%@  Method: %s", NSStringFromClass(cls), methodName);
        }
        free(methods);
    } else {
        NSLog(@"无法获取方法列表");
    }

    // 👇👇👇 打印属性列表
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (properties) {
        NSLog(@"--- 属性列表 ---");
        for (unsigned int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            const char *attributes = property_getAttributes(property);
            NSLog(@"Cls：%@  Property: %s  Attr: %s", NSStringFromClass(cls), propertyName, attributes);
        }
        free(properties);
    } else {
        NSLog(@"没有属性");
    }
}

@end
