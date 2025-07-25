// See http://iphonedevwiki.net/index.php/Logos

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "fishhook.h"  // 请确保 fishhook 库已引入
#include <sys/sysctl.h>         // 导入 sysctl 系统控制函数，用于获取/修改系统信息
#import <WebKit/WebKit.h>

#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"device_config.json"]
#define kAutoPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"auto_status.json"]


// 读取JSON配置文件
static NSDictionary *loadConfigJson() {
    // 获取 Documents 目录路径
    NSString *filePath = kFilePath;
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    if (!jsonData) {
        NSLog(@"[HOOK] 无法读取配置文件: %@", filePath);
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error || ![jsonDict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"[HOOK] 解析配置文件失败: %@", error ? error.localizedDescription : @"格式不正确");
        return nil;
    }
    return jsonDict;
}

//ua
static NSString *fakeUserAgent() {
    NSDictionary *config = loadConfigJson();
    NSString *uaStr = config[@"ua"];
    if ([uaStr isKindOfClass:[NSString class]] && uaStr.length > 0) {
        return uaStr;
    }
    // 默认伪造 UA
    return fakeUserAgent();
}

#pragma mark - IDFA
%hook ASIdentifierManager
//（IDFA）
- (NSUUID *)advertisingIdentifier {
    NSDictionary *config = loadConfigJson();
    NSString *customIDFA = config[@"idfa"];
    // 检查 config 是否为空，customIDFV 是否为空，是否为合法 UUID 字符串
    if ([customIDFA isKindOfClass:[NSString class]] && customIDFA.length > 0) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:customIDFA];
        if (uuid) {
            return uuid;
        }
    }
    //NSLog(@"[HOOK] 使用配置文件中的IDFA: %@", customIDFA);
    return %orig;
}
//- (NSUUID *)advertisingIdentifier {
//    NSLog(@"[Hooked] 原来的IDFA: %@", %orig);
//    NSString *key = @"my_hooked_advertisingIdentifier_key";
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *savedUUID = [defaults stringForKey:key];
//
//    if (savedUUID && savedUUID.length > 0) {
//        NSLog(@"[Hooked] Returning saved IDFA: %@", savedUUID);
//        return [[NSUUID alloc] initWithUUIDString:savedUUID];
//    } else {
//        NSUUID *newUUID = [NSUUID UUID];
//        NSString *newUUIDStr = [newUUID UUIDString];
//        NSLog(@"[Hooked] No saved IDFA. Generated new: %@", newUUIDStr);
//
//        [defaults setObject:newUUIDStr forKey:key];
//        [defaults synchronize];
//
//        return newUUID;
//    }
//    return %orig;
//}

%end

#pragma mark - UIDevice
%hook UIDevice
// 修改设备唯一标识符（IDFV）
- (NSUUID *)identifierForVendor {
    NSDictionary *config = loadConfigJson();
    NSString *customIDFV = config[@"idfv"];

    // 检查 config 是否为空，customIDFV 是否为空，是否为合法 UUID 字符串
    if ([customIDFV isKindOfClass:[NSString class]] && customIDFV.length > 0) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:customIDFV];
        if (uuid) {
            return uuid;
        }
    }
    // 如果无效或为空，回退到系统默认的 IDFV
    return %orig;
}

//（IDFV）
//- (NSUUID *)identifierForVendor {
//    NSLog(@"[Hooked] 原来的IDFV: %@", %orig);
//    NSString *key = @"my_hooked_identifierForVendor_key";
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *savedUUID = [defaults stringForKey:key];
//
//    if (savedUUID && savedUUID.length > 0) {
//        NSLog(@"[Hooked] 保存原来的IDFV（UUID）: %@", savedUUID);
//        return [[NSUUID alloc] initWithUUIDString:savedUUID];
//    } else {
//        // 生成新的 UUID
//        NSUUID *newUUID = [NSUUID UUID];
//        NSString *newUUIDStr = [newUUID UUIDString];
//        NSLog(@"[Hooked] 生成新的IDFV（UUID）: %@", newUUIDStr);
//
//        // 保存到 UserDefaults
//        [defaults setObject:newUUIDStr forKey:key];
//        [defaults synchronize];
//
//        return newUUID;
//    }
//    return %orig;
//}

// 伪造 model
- (NSString *)model {
    NSDictionary *config = loadConfigJson();
    NSString *revisionStr = config[@"revision"] ?: %orig;
    if (revisionStr) return revisionStr;
    return %orig; //@"iPhone15,2"; 伪造成 iPhone 14 Pro
}

// 修改设备名称（用户自定义名称 ZBiPhone）
- (NSString *)name {
    NSDictionary *config = loadConfigJson();
    return config[@"iPhone_name"] ?: %orig;
}

// 修改系统名称
- (NSString *)systemName {
    NSString *original = %orig;
    return @"iOS"; // 系统名称
}

// 修改系统版本 17.6.1
- (NSString *)systemVersion {
    NSDictionary *config = loadConfigJson();
    return config[@"osv"] ?: %orig;
}

// 修改电池电量
- (float)batteryLevel {
    float original = %orig;
    NSDictionary *config = loadConfigJson();
    
    if (config && [config[@"battery"] isKindOfClass:[NSNumber class]]) {
        float rawValue = [config[@"battery"] floatValue];
        float rounded = roundf(rawValue * 100) / 100.0f;
        //NSLog(@"[Hook] 配置电量覆盖: %f -> %.2f", rawValue, rounded);
        return rounded;
    }
    
    return 0.76f;
}

// 修改电池状态
- (UIDeviceBatteryState)batteryState {
    UIDeviceBatteryState origState = %orig;
//    0电池状态未知  1电池供电  2正在充电  3充满电
    //NSLog(@"[HOOK] 原始电池状态: %ld", (long)origState);
    
    NSDictionary *config = loadConfigJson();
    NSInteger state = 1; // 默认值为 1（Unplugged）
    id raw = config[@"batteryState"];
    if ([raw respondsToSelector:@selector(integerValue)]) {
        state = [raw integerValue] ?: 1;
    }
    UIDeviceBatteryState spoofedState = (UIDeviceBatteryState)state;
    return spoofedState;
}

// 修改设备方向
- (UIDeviceOrientation)orientation {
    UIDeviceOrientation original = %orig;
    return UIDeviceOrientationPortrait; // 竖屏
}

// 修改设备用户界面类型
- (UIUserInterfaceIdiom)userInterfaceIdiom {
    UIUserInterfaceIdiom original = %orig;
    return UIUserInterfaceIdiomPhone; // iPhone设备类型
}

// Hook 私有方法 - 序列号 (需确认方法是否存在)动态返回伪造随机序列号：
- (NSString *)serialNumber {
    %orig; // 先调用原始方法获取值（可选）
    return [NSString stringWithFormat:@"%02X%02X%02X%02X",
        arc4random_uniform(256), arc4random_uniform(256),
        arc4random_uniform(256), arc4random_uniform(256)];
}
%end

#pragma mark - CLLocation
/*
%hook CLLocation
//- (id)copyWithZone:(NSZone *)zone {
//    NSLog(@"Hooked CLLocation copyWithZone");
//    return [[CLLocation alloc] initWithLatitude:31.2304 longitude:121.4737];
//}

- (instancetype)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    NSLog(@"Hooked CLLocation init: 原始经纬度 (%f, %f)", latitude, longitude);
    
    double storedLat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"c.latitude"];
    double storedLon = [[NSUserDefaults standardUserDefaults] doubleForKey:@"c.longitude"];
    
    // 只要存储的经纬度不是 (0, 0)，就用存储的
    if (storedLon != 0.0 || storedLat != 0.0) {
        NSLog(@"使用存储的经纬度: (%f, %f)", storedLat, storedLon);
        return %orig(storedLat, storedLon);
    }
    
    // 如果 `NSUserDefaults` 里没有存储，则存储当前的 latitude 和 longitude
    if (longitude != 0.0 || latitude != 0.0) {
        [[NSUserDefaults standardUserDefaults] setDouble:latitude forKey:@"c.latitude"];
        [[NSUserDefaults standardUserDefaults] setDouble:longitude forKey:@"c.longitude"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"存储新的经纬度: (%f, %f)", latitude, longitude);
    }

    return %orig(latitude, longitude);
}

%end

%hook CLLocationManager
// 直接访问 location，有些 App 可能会检测 CLLocationManager 是否被 Hook，可以在 location 方法中添加额外的日志，并避免直接返回新建的 CLLocation 对象
//- (CLLocation *)location {
//    NSLog(@"Hooked CLLocationManager location");
//
//    CLLocation *originalLocation = %orig;
//    if (originalLocation) {
//        NSLog(@"原始定位: %f, %f", originalLocation.coordinate.latitude, originalLocation.coordinate.longitude);
//    }
//
//    return [[CLLocation alloc] initWithLatitude:31.2304 longitude:121.4737];
//}

// 定期更新位置
- (void)startUpdatingLocation {
    NSLog(@"Hooked startUpdatingLocation");
    double lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"c.latitude"];
    double lon = [[NSUserDefaults standardUserDefaults] doubleForKey:@"c.longitude"];
    NSLog(@"Hooked CLLocation init: 开始经纬度 (%f, %f)", lon, lat);

    CLLocation *fakeLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    [self.delegate locationManager:self didUpdateLocations:@[fakeLocation]];
}

// 一次性请求定位
//- (void)requestLocation {
//    NSLog(@"Hooked requestLocation");
//    CLLocation *fakeLocation = [[CLLocation alloc] initWithLatitude:31.2304 longitude:121.4737];
//    [self.delegate locationManager:self didUpdateLocations:@[fakeLocation]];
//}
//
//// 定位回调（有些 App 可能不会实现）
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    NSLog(@"Hooked didUpdateLocations");
//
//    CLLocation *fakeLocation = [[CLLocation alloc] initWithLatitude:31.2304 longitude:121.4737]; // 伪造坐标
//    NSArray *fakeLocations = @[fakeLocation];
//
//    %orig(manager, fakeLocations); // 调用原方法，但传递假的位置
//}
%end
*/

#pragma mark - NSJSONSerialization
// Hook JSON 序列化，用于监控和分析数据包
%hook NSJSONSerialization

// JSON -> NSData
+ (NSData *)dataWithJSONObject11:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error {
    // 调用原始方法获取 JSON 数据
    NSData *result = %orig(obj, opt, error);
    // 分析生成的 JSON 数据，查找和监控特定字段
    if (result) {
//        NSString *jsonString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSError *err = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:&err];
        NSLog(@"[Hook] JSON -> NSData: %@", jsonDict);
    } else {
        NSLog(@"[Hook] JSON -> NSData Error: %@", *error);
    }
    return result;
}
id DeepMutableCopy(id obj) {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        for (id key in obj) {
            mutableDict[key] = DeepMutableCopy(obj[key]);
        }
        return mutableDict;
    } else if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (id item in obj) {
            [mutableArray addObject:DeepMutableCopy(item)];
        }
        return mutableArray;
    } else {
        return obj;
    }
}

+ (NSData *)dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error {
    // 打印调用堆栈
    NSLog(@"[Hook] NSJSONSerialization +dataWithJSONObject called with obj: %@", obj);
    
    // 获取调用栈符号字符串
    NSArray<NSString *> *callStack = [NSThread callStackSymbols];
    NSLog(@"Call Stack:\n%@", [callStack componentsJoinedByString:@"\n"]);
    
    // 只处理 NSDictionary 类型的数据
    if (![obj isKindOfClass:[NSDictionary class]]) {
        return %orig(obj, opt, error);
    }

    // 拷贝成可变结构（递归可变）
    NSMutableDictionary *mutableJSON = DeepMutableCopy(obj);

    // 加载配置
    NSDictionary *config = loadConfigJson();
    NSString *osv = config[@"osv"];
    if (osv && [osv isKindOfClass:[NSString class]]) {
        // 替换字段
        mutableJSON[@"system_version"] = osv;

        NSMutableDictionary *device = mutableJSON[@"device"];
        if ([device isKindOfClass:[NSMutableDictionary class]]) {
            device[@"osVersion"] = osv;
        }

        NSLog(@"[Hook] 替换 system_version / device.osVersion 为 %@", osv);
    }

    // 尝试序列化新的 JSON 数据
    NSError *localErr = nil;
    NSData *modifiedData = %orig(mutableJSON, opt, &localErr);
    if (modifiedData) {
        NSLog(@"[Hook] 修改后的 JSON708000：%@", mutableJSON);
        return modifiedData;
    } else {
        NSLog(@"[Hook] 重新编码 JSON 出错：%@", localErr);
        return %orig(obj, opt, error);
    }
}


// NSData -> JSON
+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error {
    id jsonObj = %orig;
//    NSLog(@"[Hook] NSData -> JSON: %@", jsonObj);
    return jsonObj;
}
%end



#pragma mark - NSURL

%hook NSURL
+ (NSURL *)URLWithString:(NSString *)URLString {
    NSLog(@"[HOOK] URLWithString (单参数): %@", URLString);
    // 可选替换
//    NSString *newURLString = [URLString stringByReplacingOccurrencesOfString:@"example.com" withString:@"intercepted.com"];

    NSURL *result = %orig(URLString);
    NSLog(@"[HOOK] 返回 NSURL (单参数): %@", result);
    return result;
}

+ (NSURL *)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL {
    NSLog(@"[HOOK] URLWithString: %@ relativeToURL: %@", URLString, baseURL);

    // 可选：你可以在这里修改 URLString 或 baseURL
//    NSString *newURLString = [URLString stringByReplacingOccurrencesOfString:@"example.com" withString:@"intercepted.com"];

    // 调用原始实现
    NSURL *result = %orig(URLString, baseURL);

    // 打印返回值
    NSLog(@"[HOOK] 返回 NSURL: %@", result);
    return result;
}
%end



#pragma mark - NSURLSession

%hook NSURLSession
//
//%new
//- (NSData *)extractSecondProtobufMessage:(NSData *)data {
//    const uint8_t *bytes = (const uint8_t *)data.bytes;
//    NSUInteger length = data.length;
//
//    NSUInteger secondMessageIndex = NSNotFound;
//    for (NSUInteger i = 0; i < length; i++) {
//        if (bytes[i] == 8) {  // 发现第二个消息的标识
//            if (secondMessageIndex == NSNotFound) {
//                secondMessageIndex = i; // 记录起始位置
//            } else {
//                return [data subdataWithRange:NSMakeRange(secondMessageIndex, length - secondMessageIndex)];
//            }
//        }
//    }
//    return nil;
//}
//
//%new
//- (NSDictionary *)parseProtobufData:(NSData *)data {
//    NSData *filteredData = [self performSelector:@selector(extractSecondProtobufMessage:) withObject:data];
//    if (!filteredData) return nil;
//
//    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
//    const uint8_t *bytes = (const uint8_t *)data.bytes;
//    NSUInteger length = data.length;
//
//    for (NSUInteger i = 0; i < length; ) {
//        uint8_t key = bytes[i++];
//        if (key == 1 || key == 2 || key == 4) {
//            // 解析字符串
//            uint8_t strLength = bytes[i++];
//            NSString *value = [[NSString alloc] initWithBytes:&bytes[i] length:strLength encoding:NSUTF8StringEncoding];
//            resultDict[@(key)] = value;
//            i += strLength;
//        } else if (key == 5) {
//            // 解析嵌套数字
//            uint8_t nestedKey = bytes[i++];
//            if (nestedKey == 1) {
//                uint32_t number;
//                memcpy(&number, &bytes[i], sizeof(uint32_t));
//                resultDict[@(5)] = @{ @(1): @(number) };
//                i += sizeof(uint32_t);
//            }
//        }
//    }
//    return resultDict;
//}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler{
    NSString *url = request.URL.absoluteString;
    NSLog(@"Intercepted Request: %@", url);

    __block NSString *requestBody = nil;
    if (request.HTTPBody) {
        requestBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"[Legos] Request Body: %@", requestBody);
    }

    void (^customCompletion)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"[Legos] 请求：%@\n入参：%@\n出参：%@", url, requestBody, responseBody);

        NSDictionary *fakeResponse = nil;
        if ([url containsString:@"/v2/device-check/ios"]) {
            fakeResponse = @{
                @"data": @{ @"action": @1, @"result": @{ @"action": @1 } },
                @"meta": @{ @"status": @200 }
            };
        } else if ([url containsString:@"/v2/insendio/templates/active"]) {
            fakeResponse = @{
                @"data": @{ @"templates": @[] },
                @"meta": @{ @"status": @200 }
            };
        }

        if (fakeResponse) {
            NSData *fakeData = [NSJSONSerialization dataWithJSONObject:fakeResponse options:0 error:nil];
            NSHTTPURLResponse *fakeResp = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type": @"application/json"}];
            NSLog(@"[Legos] 使用自定义响应覆盖 %@", url);
            completionHandler(fakeData, fakeResp, nil);
            return;
        }
        // 否则使用原始返回
        completionHandler(data, response, error);
    };
    return %orig(request, customCompletion);
}
%end


#pragma mark - WKWebView
%hook WKWebView
- (void)loadRequest:(NSURLRequest *)request {
    NSLog(@"📦 WKWebView 请求：%@", request.URL.absoluteString);
    return %orig;
}
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id result, NSError *error))completionHandler {
    NSLog(@"📡 [WKWebView] evaluateJavaScript called:\n%@", javaScriptString);

    // 如果你想注入 JS 拦截表单提交等，可以在这里修改字符串
    // 比如：监控用户名和密码字段
    if ([javaScriptString containsString:@"submit"]) {
        NSLog(@"🚨 可能是提交表单相关 JS");
    }
    // 可以调用 %orig 来继续原本的逻辑
    %orig;
}
%end


#pragma mark - NSBundle
%hook NSBundle

- (NSDictionary *)infoDictionary {
    NSDictionary *originalDict = %orig;
    NSMutableDictionary *mutableDict = [originalDict mutableCopy];

    NSDictionary *config = loadConfigJson();
    NSString *fakeOS = config[@"osv"];
    if (fakeOS && mutableDict[@"DTPlatformVersion"]) {
//        NSLog(@"[HOOK] 替换 Info.plist 中的 DTPlatformVersion: %@", fakeOS);
        mutableDict[@"DTPlatformVersion"] = fakeOS;
    }

    return [mutableDict copy];
}

NSString *fake_NSStringFromClass(Class cls) {
    NSString *className = NSStringFromClass(cls);
    if ([className isEqualToString:@"FloatingExtendVC"]) {
        return @"UIViewController";
    }
    return className;
}

%end

#pragma mark - NSLocale

%hook NSLocale
// 伪造 locale（zh_CN）
+ (id)currentLocale {
    NSLocale *fake = [NSLocale localeWithLocaleIdentifier:@"locale"];
    return fake;
}

//地区设置
- (NSString *)localeIdentifier {
    //NSLog(@"[Hook] NSLocale localeIdentifier 被调用:%@", %orig);
    // 从配置文件读取参数
    NSDictionary *config = loadConfigJson();
    // 如果配置文件存在且包含必要参数，则使用配置值，否则使用默认值
    NSString *locale = config[@"locale"] ?: %orig;
    return locale;
}

//可以用它来识别模拟器、自动化或国外设备伪装
+ (NSArray<NSString *> *)preferredLanguages {
    NSArray *orig = %orig;
    //NSLog(@"[HOOK] 原始系统语言列表: %@", orig);

    NSDictionary *config = loadConfigJson();
    NSString *spoofed = config[@"kb"]; // en-Latn-US
    if (spoofed) {
        return @[spoofed];
    }
    return orig;
}
%end


#pragma mark - NSTimeZone

%hook NSTimeZone
// Hook 当前本地时区
+ (NSTimeZone *)localTimeZone {
    NSTimeZone *orig = %orig;
    //NSLog(@"[Hook] localTimeZone 原始值: %@", orig.name);

    NSDictionary *config = loadConfigJson();
    NSString *timezoneName = config[@"tz_offset"];

    // 如果 tz_offset 存在且是字符串，就尝试使用该时区；否则返回原始值
    if ([timezoneName isKindOfClass:[NSString class]]) {
        NSTimeZone *fakeTZ = [NSTimeZone timeZoneWithName:timezoneName];
        if (fakeTZ) {
            //NSLog(@"[Hook] 使用伪造时区: %@", timezoneName);
            return fakeTZ;
        } else {
           // NSLog(@"[Hook] 伪造时区无效，使用原始值");
        }
    }
    return orig;
}

// Hook 系统时区
+ (NSTimeZone *)systemTimeZone {
    NSTimeZone *orig = %orig;
    //NSLog(@"[Hook] systemTimeZone 原始值: %@", orig.name);

    NSDictionary *config = loadConfigJson();
    NSString *timezoneName = config[@"tz_offset"];

    if ([timezoneName isKindOfClass:[NSString class]]) {
        NSTimeZone *fakeTZ = [NSTimeZone timeZoneWithName:timezoneName];
        if (fakeTZ) {
            NSLog(@"[Hook] 使用伪造时区: %@", timezoneName);
            return fakeTZ;
        } else {
            NSLog(@"[Hook] 伪造时区无效，使用原始值");
        }
    }
    return orig;
}
%end


#pragma mark - 修改 machine的系统版本号
static int (*orig_sysctlbyname)(const char *, void *, size_t *, const void *, size_t);
static int my_sysctlbyname(const char *name, void *oldp, size_t *oldlenp, const void *newp, size_t newlen) {
    NSDictionary *config = loadConfigJson();
    if (strcmp(name, "kern.osproductversion") == 0) {
//        NSDictionary *config = loadConfigJson();
        NSString *osv = config[@"osv"];  // "17.6.1"
        if (osv && [osv isKindOfClass:[NSString class]]) {
            const char *fake = [osv UTF8String];
            size_t len = strlen(fake) + 1;

            if (oldp && oldlenp && *oldlenp >= len) {
                memcpy(oldp, fake, len);
                *oldlenp = len;
                return 0;
            } else if (oldlenp) {
                *oldlenp = len;
                return 0;
            }
        }
    }else if (strcmp(name, "kern.osversion") == 0) {
        NSString *osv = config[@"osversion"];//21G93
        if ([osv isKindOfClass:[NSString class]]) {
            const char *fakeVersion = [osv UTF8String];
            size_t len = strlen(fakeVersion) + 1;
            if (oldp && oldlenp && *oldlenp >= len) {
                memcpy(oldp, fakeVersion, len);
                *oldlenp = len;
                return 0;
            } else if (oldlenp) {
                *oldlenp = len;
                return 0;
            }
        }
    } else if (strcmp(name, "hw.machine") == 0) {
        NSString *revision = config[@"revision"];
        if ([revision isKindOfClass:[NSString class]]) {
            const char *fakeMachine = [revision UTF8String];
            size_t len = strlen(fakeMachine) + 1;
            if (oldp && oldlenp && *oldlenp >= len) {
                memcpy(oldp, fakeMachine, len);
                *oldlenp = len;
                return 0;
            } else if (oldlenp) {
                *oldlenp = len;
                return 0;
            }
        }
    } else if (strcmp(name, "hw.model") == 0) {
        NSString *str = config[@"model"];//D84AP
        if ([str isKindOfClass:[NSString class]]) {
            const char *fakeMachine = [str UTF8String];
            size_t len = strlen(fakeMachine) + 1;
            if (oldp && oldlenp && *oldlenp >= len) {
                memcpy(oldp, fakeMachine, len);
                *oldlenp = len;
                return 0;
            } else if (oldlenp) {
                *oldlenp = len;
                return 0;
            }
        }
    }
    return orig_sysctlbyname(name, oldp, oldlenp, newp, newlen);
}

// ✅ fishhook 替换符号
__attribute__((constructor))
static void hook_sysctlbyname_func() {
    struct rebinding reb = {
        "sysctlbyname",
        (void *)my_sysctlbyname,
        (void **)&orig_sysctlbyname
    };
    rebind_symbols(&reb, 1);
}

#pragma mark -  hook getenv 环境变量
// 原始 getenv 函数指针
static char *(*orig_getenv)(const char *name) = NULL;

// 我们的自定义 getenv
static char *my_getenv(const char *name) {
    if (name && strcmp(name, "DYLD_INSERT_LIBRARIES") == 0) {
        // 打印检测意图
        NSLog(@"⚠️ 已拦截 getenv(\"DYLD_INSERT_LIBRARIES\")，返回 NULL 以绕过检测");
        return NULL; // 返回 NULL 代表这个环境变量不存在
    }
    // 其他正常返回
    return orig_getenv(name);
}

// 在 tweak 初始化时替换 getenv
__attribute__((constructor))
static void init_env_hook() {
    struct rebinding getenv_rebinding = {
        .name = "getenv",
        .replacement = (void *)my_getenv,
        .replaced = (void **)&orig_getenv
    };
    rebind_symbols(&getenv_rebinding, 1);
}


#pragma mark - NSDictionary
/*
%hook NSDictionary
- (id)objectForKey:(id)key {
    // 检查是否在访问系统启动时间相关键值
    NSLog(@"[HOOK] NSDictionary读取 %@:%@",key, %orig(key));
//    if ([key isKindOfClass:[NSString class]] && [key isEqualToString:@"bt_ms_2"]) {
//        id value = %orig(key);
//        // 注释掉的代码，用于返回自定义值
//        // return @"hooked_bt_value";
//        return value;
//    }
    return %orig(key);
}
+ (instancetype)dictionaryWithContentsOfFile:(NSString *)path {
    // 调用原始方法，读取原始 plist 内容
    NSDictionary *origDict = %orig(path);
    NSLog(@"[HOOK] dictionaryWithContentsOfFile：%@ \n内容: %@",path, origDict);
    // 举例：如果路径包含 "VersionInfo.plist" 并且包含键 "CFBundleVersion"，我们替换它
    NSString *src = [[NSBundle mainBundle] pathForResource:@"MBModel.momd/VersionInfo" ofType:@"plist"];
    NSString *dst = [NSTemporaryDirectory() stringByAppendingPathComponent:@"VersionInfo.plist"];
    [[NSFileManager defaultManager] copyItemAtPath:src toPath:dst error:nil];
    NSLog(@"已复制 VersionInfo.plist 到: %@", dst);

    if ([path containsString:@"VersionInfo.plist"]) {
        NSMutableDictionary *mutableDict = [origDict mutableCopy];

        if (mutableDict[@"CFBundleVersion"]) {
            NSDictionary *config = loadConfigJson(); // 你已有的加载方法
            NSString *osv = config[@"osv"];
            if (osv){
                mutableDict[@"CFBundleVersion"] = @"9999.9.9";  // 自定义版本号
                NSLog(@"[HOOK] 修改后 Plist 内容: %@", mutableDict);
            }
        }
        return [mutableDict copy];  // 返回修改后的版本
    }
    // 对其他 plist 不处理，正常返回
    return origDict;
}
%end
*/
#pragma mark - Auth.RefreshTokenInteractor
/*
%hook ARefreshTokenInteractor

- (instancetype)init {
    return %orig;
}

- (void)storeRefreshToken:(NSString *)token {
    return %orig;
}

- (NSString *)currentRefreshToken {
    %log;
    NSString *token = %orig;
    
    // 打印 token
    NSLog(@"[HOOK] currentRefreshToken: %@", token);
    
    // 存入 UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"hooked_refresh_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return token;
}

%end

%ctor {
    %init(ARefreshTokenInteractor=objc_getClass("Auth.RefreshTokenInteractor"));
//     %init(ARefreshTokenInteractor = NSClassFromString(@"Auth.RefreshTokenInteractor"));
}
 */


//%hook FIRInstallations
//
//- (id)initWithAppOptions:(id)options appName:(NSString *)appName installationsIDController:(id)installationsIDController prefetchAuthToken:(NSString *)token {
//    %log;
//    // options FIROptions
//    // appName __FIRAPP_DEFAULT
//    // installationsIDController FIRInstallationsIDController
//    // token FIRInstallationsIDController
//
//    return %orig(options, appName, installationsIDController, token);
//}
//
//- (void)authTokenWithCompletion:(void (^)(NSString * _Nullable ide, NSError * _Nullable))completion {
//    %log;
//
//    %orig(completion);
//}
//
//
//%end
//
//%hook FIRInstallationsAPIService
//
////- (void)registerInstallation:(id)installation {
////    %log; // FIRInstallationsItem
////    return %orig(installation);
////}
//
//- (NSString *)authTokenRequestWithInstallation:(id)installation {
//    %log;
//    return %orig(installation);
//}
//
//-(void)requestWithURL:(NSURL *)url HTTPMethod:(NSString *)HTTPMethod bodyDict:(id )bodyDict refreshToken:(NSString *)refreshToken {
//    %log;
//    %orig(url, HTTPMethod, bodyDict, refreshToken);
//}
//
//%end
//
//%hook FIRInstallationsItem
//
//- (NSString *)refreshToken {
//    %log;
//    NSString *token = %orig;
//    return token;
//}
//
//- (void)setRrefreshToken:(NSString *)token {
//    %log;
//    %orig(token);
//}
//
//- (NSString *)authToken {
//    %log;
//    NSString *token = %orig;
//    return token;
//}
//
//- (void)setAuthToken:(NSString *)token {
//    %log;
//    %orig(token);
//}
//
//%end
//
//%hook FIRInstallationsStoredItem
//
//- (NSString *)refreshToken {
//    %log;
//    NSString *token = %orig;
//    return token;
//}
//
//- (void)setRefreshToken:(NSString *)token {
//    %log;
//    %orig(token);
//}
//
//%end
//
//%hook FIRInstallationsAuthTokenResult
//
//- (id)initWithToken:(NSString *)token expirationDate:(id)expirationDate {
//    %log;
//    return %orig;
//}
//
//- (NSString *)authToken {
//    %log;
//    NSString *token = %orig;
//    return token;
//}
//
//%end

//%hook FIRInstallationsStoredAuthToken
//
//- (NSString *)token {
//    %log;
//    NSString *token = %orig;
//    return token;
//}
//
//%end

//%hook NSURLSessionDataTask
//
//// 关联对象存储响应数据
//static char kResponseDataKey;
//
//- (void)didReceiveData:(NSData *)data {
//    %orig; // 调用原始实现
//
//    NSURLRequest *request = [self currentRequest];
//    if ([request.URL.absoluteString containsString:@"/login"]) {
//        NSMutableData *responseData = objc_getAssociatedObject(self, &kResponseDataKey);
//        if (!responseData) {
//            responseData = [NSMutableData data];
//            objc_setAssociatedObject(self, &kResponseDataKey, responseData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        }
//        [responseData appendData:data];
//    }
//}
//
//- (void)didCompleteWithError:(NSError *)error {
//    %orig; // 调用原始实现
//
//    NSURLRequest *request = [self currentRequest];
//    if ([request.URL.absoluteString containsString:@"/login"]) {
//        NSMutableData *responseData = objc_getAssociatedObject(self, &kResponseDataKey);
//        if (responseData) {
//            NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"✅ /login Response (NSURLSession): %@", responseBody);
//            objc_setAssociatedObject(self, &kResponseDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        }
//    }
//}
//
//%end
//
//%hook AFDataResponseSerializer
//- (id)responseObjectForResponse:(NSURLResponse *)response
//                          data:(NSData *)data
//                         error:(NSError *__autoreleasing *)error {
//    id result = %orig;
//    if ([response.URL.absoluteString containsString:@"/login"]) {
//        NSLog(@"✅ /login Response (Alamofire): %@", result);
//    }
//    return result;
//}
//%end

//%hook _TtC4Auth25PersistentDeviceIDContext
//
//- (NSString *)persistentDeviceID {
//    NSString *token = %orig;
//    return token;
//}
//
//%end
//
//%hook Auth.PersistentDeviceIDContext
//
//- (NSString *)persistentDeviceID {
//    NSString *token = %orig;
//    return token;
//}
//
//%end

%hook NSFileManager
- (NSURL *)containerURLForSecurityApplicationGroupIdentifier:(NSString *)groupIdentifier {
    NSURL *url = %orig;
    NSLog(@"[HOOK] containerURLForSecurityApplicationGroupIdentifier: %@ => %@", groupIdentifier, url);
    return url;
}
%end


%hook NSData
- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)useAuxiliaryFile {
    if ([url.absoluteString containsString:@"group."]) {
        NSLog(@"[HOOK] NSData writeToURL in AppGroup: %@ (length: %lu)", url, (unsigned long)self.length);
        // 可在这里打印内容：NSLog(@"%@", [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding]);
    }
    return %orig;
}
%end


%hook NSString
- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error {
    if ([url.absoluteString containsString:@"group."]) {
        NSLog(@"[HOOK] NSString writeToURL in AppGroup: %@\n内容: %@", url, self);
    }
    return %orig;
}
+ (NSString *)stringWithContentsOfURL:(NSURL *)url encoding:(NSStringEncoding)enc error:(NSError **)error {
    NSString *str = %orig;
    if ([url.absoluteString containsString:@"group."]) {
        NSLog(@"[HOOK] Read from AppGroup file: %@\n内容: %@", url, str);
    }
    return str;
}
%end


#pragma mark - BugsnagDevice
%hook BugsnagDevice
//- (void)setJailbroken:(int)arg2 {
//    NSLog(@"[Hook] setJailbroken called with arg: %d", arg2);
//    // 强制伪装为未越狱状态
//    %orig(0);
//}
// 伪装未越狱
- (int)jailbroken{
    int jailbroken = %orig;
    NSLog(@"[Hook]jailbroken: %d", jailbroken);
    return 0;
}
- (NSString *)locale {
    NSString *orig = %orig;
    NSLog(@"[Hook] locale: %@", orig);
    NSDictionary *config = loadConfigJson();
    NSString *locale = config[@"locale"] ?: %orig;
    return locale;//@"en_US"; // 返回你伪装的 locale
}
- (NSString *)modelNumber {
    NSString *orig = %orig;
    NSLog(@"[Hook] modelNumber (orig): %@", orig);//D84AP
    return orig;
}
// Hook setter 方法：- (void)setOsVersion:(NSString *)
- (void)setOsVersion:(NSString *)osVersion {
    NSDictionary *config = loadConfigJson();
    NSString *fakeOSV = config[@"osv"];
    if (fakeOSV && [fakeOSV isKindOfClass:[NSString class]]) {
        NSLog(@"[HOOK] 替换 setOsVersion: %@ -> %@", osVersion, fakeOSV);
        %orig(fakeOSV);
    } else {
        %orig(osVersion);
    }
}
//- (NSString *)osVersion {
//    NSString *orig = %orig;
//    NSDictionary *config = loadConfigJson();
//    orig = config[@"osv"] ?: %orig;
//    NSLog(@"[Hook] osVersion (orig): %@ -> %@",%orig, orig);//"18.1.1"
//    return orig;
//}
%end

%hook AppsFlyerLib
- (int)skipAdvancedJailbreakValidation{
    int jailbroken = %orig;
    NSLog(@"[Hook]skipAdvancedJailbreakValidation: %d", jailbroken);
    return 0;
}
// hook 方法 - (void)setSkipAdvancedJailbreakValidation:(BOOL)skip
- (void)setSkipAdvancedJailbreakValidation:(BOOL)skip {
    NSLog(@"[HOOK] AppsFlyerLib setSkipAdvancedJailbreakValidation: %d", skip);

    // 你可以修改参数，比如强制为 YES（跳过越狱检测）
    %orig(YES);
}
%end

%hook AppsFlyerUtils
//是否被注入代码
+ (int)isJailbrokenWithSkipAdvancedJailbreakValidation:(int)skipAdvanced {
    NSLog(@"[Hook] AppsFlyerUtils isJailbrokenWithSkipAdvancedJailbreakValidation: %d", skipAdvanced);
    return 0; // 始终返回“未越狱”
}
//是否开启了vpn
+ (int)isVPNConnected {
    NSLog(@"[Hook] AppsFlyerUtils isVPNConnected %d", %orig);
    return 0; // 始终返回“未越狱”
}
/*
/// 获取App Store收据数据
+ (id)getStoreReceipt {
    id original = %orig;
    NSLog(@"🍌 [Original Receipt] %@", original);
    return original; // 保持原值
}

/// 检查深度链接有效性
+ (int)isValidDeeplink:(int)arg {
    int original = %orig(arg);
    NSLog(@"🍌 [Original Deeplink] %d", original);
    return 1; // 强制返回有效
}

/// 检查OneLink有效性
+ (int)isOneLinkValid:(int)arg {
    int original = %orig(arg);
    NSLog(@"🍌 [Original OneLink] %d", original);
    return 1; // 强制返回有效
}

/// 检查版本号是否符合模式
+ (int)currentVersionMatchesPattern:(int)arg1 version:(int)arg2 {
    int original = %orig(arg1, arg2);
    NSLog(@"🍌 [Original VersionMatch] %d", original);
    return 1; // 强制匹配
}
*/
// MARK: - 应用版本
/// 获取短版本号 (CFBundleShortVersionString)
//+ (NSString *)getShortBundleVersion {
//    NSString *original = %orig;
//    NSLog(@"🍌 [Original BundleVersion] %@", original);
//    return @"6.6.6"; // 修改为固定版本
//}

// MARK: - 购买事件
/// 是否缓存购买事件（根据状态码）
+ (int)shouldCachePurchaseEventWithStatusCode:(int)arg {
    int original = %orig(arg);
    NSLog(@"🍌 [Original CachePurchase] %d", original);
    return 1; // 强制缓存
}

%end

#pragma mark - BSGPersistentDeviceID
//%hook BSGPersistentDeviceID
//
//// Hook 类方法 +current
//+ (id)current {
//    id result = %orig;
//    NSLog(@"[HOOK] +[BSGPersistentDeviceID current] -> %@", result);
//    return result;
//}
//
////- (id)initWithExternalID:(int)arg2 internalID:(int)arg3 {
////    NSLog(@"[HOOK] initWithExternalID:%d internalID:%d", arg2, arg3);
////
////    id instance = %orig(arg2, arg3); // 确保传递参数
////    NSLog(@"[HOOK] Created instance: %@", instance);
////
////    return instance;
////}
//
//// Hook 实例方法 -internal:
//- (int)internal:(int)arg0 {
//    int result = %orig;
//    NSLog(@"[HOOK] -[BSGPersistentDeviceID internal:] arg0=%d -> %d", arg0, result);
//    return result;
//}
//
//// Hook 实例方法 -external:
//- (int)external:(int)arg0 {
//    int result = %orig;
//    NSLog(@"[HOOK] -[BSGPersistentDeviceID external:] arg0=%d -> %d", arg0, result);
//    return result;
//}
//
//%end

#pragma mark - CTCarrier
%hook CTCarrier
// 修改运营商名称（用户在设备上看到的运营商名称）
- (NSString *)carrierName {
    // 记录原始运营商名称，便于调试
    NSString *originalName = %orig;
    // 返回伪造的运营商名称
    NSDictionary *config = loadConfigJson();
    return config[@"carrier"];
}
%end

#pragma mark - NSProcessInfo
%hook NSProcessInfo
//设备运行总内存（RAM）
- (unsigned long long)physicalMemory {
    unsigned long long orig = %orig;
    //NSLog(@"[HOOK] 原始物理内存: %llu", orig);
    NSDictionary *config = loadConfigJson();
    NSNumber *tmValue = config[@"tm"];
    
    if (tmValue && [tmValue isKindOfClass:[NSNumber class]]) {
        return [tmValue unsignedLongLongValue];
    } else {
        return orig; // 使用原始值作为默认
    }
}

//是否省电模式
- (BOOL)isLowPowerModeEnabled {
    NSDictionary *config = loadConfigJson();
    BOOL isLpm = [config[@"lpm"] boolValue];
    return isLpm; // NO没开省电；YES省电模式
}

//修改系统版本
- (NSOperatingSystemVersion)operatingSystemVersion {
    // 读取 config 中的伪造版本号字符串
    NSDictionary *config = loadConfigJson();
    NSString *versionStr = config[@"osv"] ?: nil;

    // 打印原始值
    NSOperatingSystemVersion original = %orig;
    NSLog(@"[HOOK] NSProcessInfo operatingSystemVersion (original): %ld.%ld.%ld",
          (long)original.majorVersion,
          (long)original.minorVersion,
          (long)original.patchVersion);

    // 如果 revision 配置存在且格式正确，解析为结构体返回
    if (versionStr && [versionStr containsString:@"."]) {
        NSArray *parts = [versionStr componentsSeparatedByString:@"."];
        if (parts.count >= 2) {
            NSInteger major = [parts[0] integerValue];
            NSInteger minor = [parts[1] integerValue];
            NSInteger patch = (parts.count >= 3) ? [parts[2] integerValue] : 0;

            NSOperatingSystemVersion fakeVersion = {
                .majorVersion = major,
                .minorVersion = minor,
                .patchVersion = patch
            };

            NSLog(@"[HOOK] returning fake OS version: %ld.%ld.%ld",
                  (long)major, (long)minor, (long)patch);
            return fakeVersion;
        }
    }
    // fallback to original if not valid
    return original;
}

//修改系统版本
- (NSString *)operatingSystemVersionString {
    NSString *original = %orig;
    NSDictionary *config = loadConfigJson();
    NSString *fake = config[@"osv"];
    if (fake) {
        NSString *result = [NSString stringWithFormat:@"Version %@ (Build 21G82)", fake];
        NSLog(@"[HOOK] 替换 operatingSystemVersionString: %@", result);
        return result;
    }
    return original;
}

%end


#pragma mark - UIScreen
// Hook UIScreen 类，伪造屏幕尺寸和分辨率
%hook UIScreen
/*
// 修改分辨率
- (CGRect)bounds {
    CGRect value = %orig;
    NSDictionary *config = loadConfigJson();
    
    NSNumber *dx = config[@"dx"];
    NSNumber *dy = config[@"dy"];
    
    if ([dx isKindOfClass:[NSNumber class]] && [dy isKindOfClass:[NSNumber class]]) {
        CGFloat w = dx.floatValue;
        CGFloat h = dy.floatValue;
        //NSLog(@"[Hook] 配置伪造 bounds: %.0f x %.0f", w, h);
        return CGRectMake(0, 0, w, h);
    }
    //NSLog(@"[Hook] 使用原始 bounds: %@", NSStringFromCGRect(value));
    return value;
}

// 修改屏幕缩放比例为 3x
- (CGFloat)scale {
    CGFloat value = %orig;
   // NSLog(@"[Hook] 原始屏幕缩放比例: %f", value);
    NSDictionary *config = loadConfigJson();
    NSNumber *configScale = config[@"scale"];
    if ([configScale isKindOfClass:[NSNumber class]]) {
       // NSLog(@"[Hook] 屏幕缩放比例: %f", configScale.floatValue);
        value = configScale.floatValue;
    }
    return value;
}

// 修改物理分辨率
- (CGRect)nativeBounds {
    CGRect value = %orig;
    NSDictionary *config = loadConfigJson();
    
    NSNumber *ndx = config[@"ndx"];
    NSNumber *ndy = config[@"ndy"];
    
    if ([ndx isKindOfClass:[NSNumber class]] && [ndy isKindOfClass:[NSNumber class]]) {
        CGFloat w = ndx.floatValue;
        CGFloat h = ndy.floatValue;
       // NSLog(@"[Hook] 配置伪造 nativeBounds: %.0f x %.0f", w, h);
        return CGRectMake(0, 0, w, h);
    }
   // NSLog(@"[Hook] 使用原始 nativeBounds: %@", NSStringFromCGRect(value));
    return value;
}
*/
// 屏幕亮度
- (CGFloat)brightness {
    CGFloat sbValue = %orig;
    //NSLog(@"[Hook] 原始屏幕亮度: %f", sbValue);
    
    NSDictionary *config = loadConfigJson();
    NSNumber *configBrightness = config[@"brightness"];
    if ([configBrightness isKindOfClass:[NSNumber class]]) {
        CGFloat rawValue = configBrightness.floatValue;
        // 保留两位小数
        CGFloat rounded = round(rawValue * 100) / 100.0;
        //NSLog(@"[Hook] 配置亮度覆盖: %f -> %.2f", rawValue, rounded);
        sbValue = rounded;
    }
    return sbValue;
}

%end

#pragma mark - Section
%hook GADOMIDDevice

+ (NSString *)deviceOsVersion {
    NSDictionary *config = loadConfigJson();
    NSString *fakeOSV = config[@"osv"];
    if (fakeOSV && [fakeOSV isKindOfClass:[NSString class]]) {
        NSLog(@"[HOOK] +[BNCSystemObserver osVersion] -> %@", fakeOSV);
        return fakeOSV;
    }
    return %orig;
}

%end

%hook USRVDevice

+ (NSString *)getOsVersion {
    NSDictionary *config = loadConfigJson();
    NSString *fakeOSV = config[@"osv"];
    if (fakeOSV && [fakeOSV isKindOfClass:[NSString class]]) {
        NSLog(@"[HOOK] +[BNCSystemObserver osVersion] -> %@", fakeOSV);
        return fakeOSV;
    }
    return %orig;
}

%end

#pragma mark - GADDevice
%hook GADDevice
- (NSString *)systemVersion {
    NSLog(@"[HOOK] GADDevice systemVersion (orig): %@", %orig);
    return @"15.0.0"; // 替换成你需要的值
}
%end


%hook UADSMetricCommonTags
+ (NSString *)systemVersion {
    NSString *original = %orig;
    NSLog(@"[HOOK] UADSMetricCommonTags systemVersion (class method): %@", original);
    return original;
}
// 如果有实例属性 `_systemVersion` 对应的 getter：
- (NSString *)systemVersion {
    NSString *original = %orig;
    NSLog(@"[HOOK] UADSMetricCommonTags systemVersion (instance method): %@", original);
    return original;
}
- (instancetype)initWithCountryISO:(NSString *)countryISO
                          platform:(NSString *)platform
                        sdkVersion:(NSString *)sdkVersion
                     systemVersion:(NSString *)systemVersion
                          testMode:(BOOL)testMode
                        metricTags:(NSDictionary *)metricTags {

    NSLog(@"[HOOK] UADSMetricCommonTags initWithCountryISO:%@ platform:%@ sdkVersion:%@ systemVersion:%@ testMode:%d metricTags:%@",
          countryISO, platform, sdkVersion, systemVersion, testMode, metricTags);

    return %orig;
}

- (void)setSystemVersion:(NSString *)systemVersion {
    NSLog(@"[HOOK] UADSMetricCommonTags setSystemVersion: %@", systemVersion);
    %orig(systemVersion);
}
%end


//%hook AFSDKChecksum
//- (NSString *)calculateV2ValueWithTimestamp:(NSString *)timestamp
//                                        uid:(NSString *)uid
//                              systemVersion:(NSString *)systemVersion
//                           firstLaunchDate:(NSString *)firstLaunchDate
//                               AFSDKVersion:(NSString *)AFSDKVersion
//                                isSimulator:(BOOL)isSimulator
//                                 isDevBuild:(BOOL)isDevBuild
//                               isJailBroken:(BOOL)isJailBroken
//                            isCounterValid:(BOOL)isCounterValid
//                       isDebuggerAttached:(BOOL)isDebuggerAttached {
//
//    // 原始值打印
//    NSLog(@"\n[HOOK] AFSDKChecksum::calculateV2ValueWithTimestamp 调用参数：\n\
//            timestamp: %@\n\
//            uid: %@\n\
//            systemVersion: %@\n\
//            firstLaunchDate: %@\n\
//            AFSDKVersion: %@\n\
//            isSimulator: %d\n\
//            isDevBuild: %d\n\
//            isJailBroken: %d\n\
//            isCounterValid: %d\n\
//            isDebuggerAttached: %d",
//          timestamp, uid, systemVersion, firstLaunchDate, AFSDKVersion,
//          isSimulator, isDevBuild, isJailBroken, isCounterValid, isDebuggerAttached);
//
//    // 你要替换的字段
////    NSString *fakeSystemVersion = @"16.3.1"; // 可改成随机值
//    BOOL fakeJailBroken = NO;
//                           BOOL isDebug = NO;
//
//    // 调用原方法，传入你篡改后的值
//    return %orig(timestamp, uid, systemVersion, firstLaunchDate,
//                 AFSDKVersion, isSimulator, isDevBuild,
//                 fakeJailBroken, isCounterValid, isDebug);
//}
//
//- (int)calculateV2SanityFlagsWithIsSimulator:(int)isSimulator
//                                  isDevBuild:(int)isDevBuild
//                                isJailBroken:(int)isJailBroken
//                             isCounterValid:(int)isCounterValid
//                        isDebuggerAttached:(int)isDebuggerAttached
//{
//    NSLog(@"[Hook] isSimulator: %d, isDevBuild: %d, isJailBroken: %d, isCounterValid: %d, isDebuggerAttached: %d",
//        isSimulator, isDevBuild, isJailBroken, isCounterValid, isDebuggerAttached);
//
//    // 伪装为未越狱、未调试等（如你想绕过反调试/反越狱）
//    int fakeSimulator = 0;
//    int fakeDevBuild = 0;
//    int fakeJailbroken = 0;
//    int fakeCounterValid = 1;
//    int fakeDebuggerAttached = 0;
//
//    int result = %orig(fakeSimulator, fakeDevBuild, fakeJailbroken, fakeCounterValid, fakeDebuggerAttached);
//
//    NSLog(@"[Hook] calculateV2SanityFlags return: %d", result);
//    return result;
//}
//%end


%hook _TtC9TinderKit7TUIView

// Hook traitCollectionDidChange:
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    NSLog(@"[TinderKit] TraitCollectionDidChange called! Previous: %@", previousTraitCollection);
    // 调用原始方法
    %orig;
}

%end


%hook _TtC13TinderAuthSMS30EnterPhoneNumberViewController

- (int)overrideChildrenContentSizeCategories{
    NSLog(@"[TinderKit] overrideChildrenContentSizeCategories: %@", %orig);
    return %orig;
}

%end


%hook _TtC4Auth29GatedSMSCaptchaViewController
- (int)viewControllerNavigationKey{
    NSLog(@"[TinderKit] overrideChildrenContentSizeCategories: %@", %orig);
    return %orig;
}
%end

%hook _TtC11CaptchaView21ArkoseMessageReceiver
- (void)loadRequest:(NSURLRequest *)request {
    NSLog(@"📦 TtC11Captcha 请求：%@", request.URL.absoluteString);
    return %orig;
}
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id result, NSError *error))completionHandler {
    NSLog(@"📡 [TtC11Captcha] evaluateJavaScript called:\n%@", javaScriptString);

    // 如果你想注入 JS 拦截表单提交等，可以在这里修改字符串
    // 比如：监控用户名和密码字段
    if ([javaScriptString containsString:@"submit"]) {
        NSLog(@"🚨 TtC11Captcha可能是提交表单相关 JS");
    }
    // 可以调用 %orig 来继续原本的逻辑
    %orig;
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"💡 Hook 成功: JS 发送消息 = %@", message.body);
    // 可以添加条件判断 message.name / message.body 等内容
    if ([message.body isKindOfClass:[NSString class]] && [message.body isEqualToString:@"verifySuccess"]) {
        NSLog(@"✅ Arkose 验证通过");
        // 可执行下一步逻辑
    }
    %orig; // 保持原有逻辑
}
%end

//%hook ArkoseMessageReceiver
//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    NSLog(@"💡 Hook 成功: JS 发送消息 = %@", message.body);
//    // 可以添加条件判断 message.name / message.body 等内容
//    if ([message.body isKindOfClass:[NSString class]] && [message.body isEqualToString:@"verifySuccess"]) {
//        NSLog(@"✅ Arkose 验证通过");
//        // 可执行下一步逻辑
//    }
//    %orig; // 保持原有逻辑
//}
//%end

//%hook UINavigationController
//
//- (NSArray<UIViewController *> *)viewControllers {
//    NSArray *originalVCs = %orig;
//    NSMutableArray *filteredVCs = [NSMutableArray array];
//    
//    for (UIViewController *vc in originalVCs) {
//        NSString *className = NSStringFromClass([vc class]);
//        if ([className isEqualToString:@"FloatingExtendVC"]) {
//            // 替换成系统类名，或者忽略这类VC
//            // 比如用 UIViewController 伪装
//            UIViewController *fakeVC = [[UIViewController alloc] init];
//            [filteredVCs addObject:fakeVC];
//        } else {
//            [filteredVCs addObject:vc];
//        }
//    }
//    return filteredVCs;
//}
//
//%end


//%hook UIViewController
//
//- (NSString *)description {
//    NSString *desc = %orig;
//    NSString *className = NSStringFromClass([self class]);
//    if ([className isEqualToString:@"FloatingExtendVC"]) {
//        // 返回伪装描述
//        return @"<UIViewController: 0x12345678>";
//    }
//    return desc;
//}
//
//// 或者hook class，返回伪装类
//
//- (Class)class {
//    Class cls = %orig;
//    if ([NSStringFromClass(cls) isEqualToString:@"FloatingExtendVC"]) {
//        return [UIViewController class];
//    }
//    return cls;
//}
//
//%end

//%hook NSObject
//
//- (Class)class {
//    Class cls = %orig;
//    if ([NSStringFromClass(cls) isEqualToString:@"FloatingExtendVC"]) {
//        return [UIViewController class];
//    }
//    return cls;
//}
//
//%end



%hook USRVApiDeviceInfo

+ (int)WebViewExposed_getCurrentUITheme:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getCurrentUITheme called with arg: %d", arg2);
    // 你可以在这里修改返回值，比如强制返回 1 表示深色模式（或其他值）
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
    // return 1; // 强制深色模式
}
+ (int)WebViewExposed_getLocaleList:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getLocaleList called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+ (int)WebViewExposed_getSystemBootTime:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSystemBootTime called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+ (int)WebViewExposed_getDeviceName:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getDeviceName called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+ (int)WebViewExposed_getVendorIdentifier:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getVendorIdentifier called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+ (int)WebViewExposed_getElapsedRealtime:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getElapsedRealtime called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+ (int)WebViewExposed_getUptime:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getUptime called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+ (int)WebViewExposed_getCPUCount:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getCPUCount called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_unregisterVolumeChangeListener:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_unregisterVolumeChangeListener called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_registerVolumeChangeListener:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_registerVolumeChangeListener called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getDeviceMaxVolume:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getDeviceMaxVolume called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getGLVersion:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getGLVersion called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_isStatusBarHidden:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_isStatusBarHidden called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getStatusBarHeight:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getStatusBarHeight called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getStatusBarWidth:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getStatusBarWidth called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getProcessInfo:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getProcessInfo called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getSensorList:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSensorList called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getSupportedOrientations:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSupportedOrientations called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getAdNetworkIdsPlist:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getAdNetworkIdsPlist called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getSupportedOrientationsPlist:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSupportedOrientationsPlist called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_isSimulator:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_isSimulator called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getUserInterfaceIdiom:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getUserInterfaceIdiom called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getUniqueEventId:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getUniqueEventId called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_isRooted:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_isRooted called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getTotalMemory:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getTotalMemory called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getFreeMemory:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getFreeMemory called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getBatteryStatus:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getBatteryStatus called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getBatteryLevel:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getBatteryLevel called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getTotalSpace:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getTotalSpace called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getFreeSpace:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getFreeSpace called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getScreenBrightness:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getScreenBrightness called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getDeviceVolume:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getDeviceVolume called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getSystemLanguage:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSystemLanguage called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getTimeZoneOffset:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getTimeZoneOffset called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getTimeZone:(int)arg2 callback:(int)arg3 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getTimeZone called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getHeadset:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getHeadset called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getNetworkCountryISO:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getNetworkCountryISO called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getNetworkOperatorName:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getNetworkOperatorName called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_checkIsMuted:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_checkIsMuted called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getNetworkOperator:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getNetworkOperator called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getScreenHeight:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getScreenHeight called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getScreenWidth:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getScreenWidth called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getScreenScale:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getScreenScale called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getNetworkType:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getNetworkType called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getConnectionType:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getConnectionType called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getModel:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getModel called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getOsVersion:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getOsVersion called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getLimitAdTrackingFlag:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getLimitAdTrackingFlag called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
+(int)WebViewExposed_getAdvertisingTrackingId:(int)arg2 {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getAdvertisingTrackingId called with arg: %d", arg2);
    int original = %orig;
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}

%end



%hook BNCDeviceInfo

- (int)loadDeviceInfo {
    NSLog(@"[HOOK] BNCDeviceInfo -loadDeviceInfo called");

    // ✅ 你可以在这里篡改设备信息前做处理，比如：
    // 伪造 IDFV、系统版本、设备型号等

    int result = %orig;

    // 你也可以在 result 基础上修改
    NSLog(@"[HOOK] BNCDeviceInfo -loadDeviceInfo returned %d", result);
    return result;
}

- (void)setCountry:(id)value{
    NSLog(@"[Hook] setCountry called with value: %@", value);
    %orig(value);
}

- (NSString *)localIPAddress {
    NSString *realIP = %orig;
    NSLog(@"[BNCDeviceInfo] 当前本地 IP 地址: %@", realIP);
    return realIP;
}
//- (NSString *)userAgentString {
//    NSString *ua = %orig;
//    NSLog(@"[BNCDeviceInfo] User-Agent: %@", ua);
//    return ua;//User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148
//}
- (NSString *)userAgentString {
    NSString *ua = %orig;
    NSLog(@"[BNCDeviceInfo] Original User-Agent: %@", ua);

    NSDictionary *config = loadConfigJson(); // 加载 JSON 配置
    NSString *customOSV = config[@"osv"]; // 例如 @"17.6.1"

    if (customOSV && [customOSV isKindOfClass:[NSString class]] && customOSV.length > 0) {
        NSString *convertedOSV = [customOSV stringByReplacingOccurrencesOfString:@"." withString:@"_"]; // @"17_6_1"

        // 用正则替换 UA 中的版本部分
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"iPhone OS \\d+_\\d+(?:_\\d+)?" options:0 error:nil];
        ua = [regex stringByReplacingMatchesInString:ua options:0 range:NSMakeRange(0, ua.length) withTemplate:[NSString stringWithFormat:@"iPhone OS %@", convertedOSV]];
        NSLog(@"[BNCDeviceInfo] Patched User-Agent: %@", ua);
    }
    return ua;
}

%end


%hook FBSDKAppEventsDeviceInfo
- (void)setSysVersion:(int)value {
    NSLog(@"[Hook] setSysVersion called with value: %d", value);
    %orig(value); // 伪造为 iOS 16.0
}
- (NSString *)sysVersion {
    NSString *orig = %orig;
    NSLog(@"[Hook] sysVersion: %@", orig);
    return orig; // 伪造系统版本字符串
}
//- (int)sysVersion {
//    int orig = %orig;
//    NSLog(@"[Hook] sysVersion called, original: %d", orig);
//    return orig; // 返回伪造的版本号
//}
%end



%hook OTDeviceInfo

+ (NSString *)systemName {
    NSString *orig = %orig;
    NSLog(@"[Hook] +[OTDeviceInfo systemName] original: %@", orig);
    return orig; // 替换返回值
}
+ (NSString *)systemVersion {
    NSString *orig = %orig;
    NSLog(@"[Hook] +[OTDeviceInfo systemVersion] original: %@", orig);
    return orig; // 替换返回值
}
+ (NSString *)libOpentokVersion{
    NSString *orig = %orig;
    NSLog(@"[Hook] libOpentokVersion original: %@", orig);
    return orig;
}
+ (NSString *)libOpentokSHA1 {
    NSString *orig = %orig;
    NSLog(@"[Hook] libOpentokSHA1 original: %@", orig);
    return orig; // 替换为伪造的哈希值
}
+ (NSString *)machineName {
    NSString *orig = %orig;
    NSLog(@"[Hook] machineName original: %@", orig);
    return orig;
}
+ (NSString *)deviceUUID {
    NSString *orig = %orig;
    NSLog(@"[Hook] deviceUUID original: %@", orig);
    return orig;
}
+ (NSString *)userAgent {
    NSString *orig = %orig;
    NSLog(@"[Hook] userAgent original: %@", orig);
    return orig;
}
%end


%hook _TtC10TinderBase10DeviceInfo

- (instancetype)init {
    %log;  // 打印调用日志
    NSLog(@"[HOOK] DeviceInfo init called");

    // 调用原始构造方法
    id orig = %orig;

    // 在这里可以访问或修改对象的属性，例如:
    // [orig setSomeProperty:@"spoofed"];

    return orig;
}

%end
