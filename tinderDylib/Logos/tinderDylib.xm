// See http://iphonedevwiki.net/index.php/Logos

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "fishhook.h"  // 请确保 fishhook 库已引入
#include <sys/sysctl.h>         // 导入 sysctl 系统控制函数，用于获取/修改系统信息

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
        NSLog(@"[Hook] 修改后的 JSON：%@", mutableJSON);
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

#pragma mark - NSURLSession
/*
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

- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    NSLog(@"Intercepted Request: %@", request.URL.absoluteString);
    NSLog(@"Headers: %@", request.allHTTPHeaderFields);
    
    // 1. 创建一个可变的 `NSMutableURLRequest`
//    NSMutableURLRequest *mutableRequest = [request mutableCopy];
//
    // 2. 创建可变的 Headers 复制
//    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:request.allHTTPHeaderFields];
//
//    // 3. 获取 `persistent-device-id`
//    NSString *myDeviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"c.deviceId"];
//    if (myDeviceId) {
//        headers[@"persistent-device-id"] = myDeviceId;
//        NSLog(@"[Legos] myDeviceId Header value: %@", myDeviceId);
//        [[NSUserDefaults standardUserDefaults] setObject:myDeviceId forKey:@"c.deviceId"];
//    }
//
//    // 4. 检查 Headers 是否已经存在 `persistent-device-id`
//    NSString *deviceId = headers[@"persistent-device-id"];
//    if (deviceId) {
//        NSLog(@"[Legos] deviceId Header value: %@", deviceId);
//        [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"c.deviceId"];
//    } else {
//        NSLog(@"[Legos] Header key 'persistent-device-id' not found");
//    }
//
//    // 5. 获取 `X-Auth-Token`
//    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"c.authToken"];
//    if (authToken) {
//        headers[@"X-Auth-Token"] = authToken;
//        NSLog(@"[Legos] authToken Header value: %@", authToken);
//    } else {
//        NSLog(@"[Legos] Header key 'X-Auth-Token' not found");
//    }
//
    // 6. 重新设置请求的 HTTP 头
//    mutableRequest.allHTTPHeaderFields = headers;
//
    // 打印入参（请求体
    NSString *requestBody;
    if (request.HTTPBody) {
        requestBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"[Legos] Request Body: %@", requestBody);
    }
    
    void (^complete)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        // 4. **打印出参（响应体）**
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"[Legos]请求：%@\n入参：%@\n出参：%@",request.URL.absoluteString, requestBody, responseBody);
//        if ([request.URL.absoluteString containsString:@"/auth/login"]) {
//            NSString *str = [[NSString alloc] initWithData:data encoding:4];
//            if (str == nil) {
//                str = [[NSString alloc] initWithData:data encoding:1];
//                if (str) {
//                    str = [str substringFromIndex:5];
//                    NSArray *splits = [str componentsSeparatedByString:@"$"];
//                    if (splits && [splits count] > 1) {
//                        NSString *refreshToken = [splits[0] substringToIndex:[splits[0] length] - 1];
//                        [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"c.refreshToken"];
//                        NSString *otherStr = splits[1];
//                        splits = [otherStr componentsSeparatedByString:@"\""];
//                        if (splits && [splits count] > 1) {
//                            NSString *authToken = splits[0];
//                            [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:@"c.authToken"];
//                        }
//                    }
//                }
//            }
////            NSDictionary *protobufDict = [self performSelector:@selector(parseProtobufData:) withObject:data];
////            NSLog(@"[Legos] Protobuf: %@", protobufDict);
//        }
        completionHandler(data, response, error);
    };
    
    // 7. 确保传递 `mutableRequest`
    return %orig(request, complete);
}

%end
*/

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

%end

#pragma mark - NSLocale
/*
%hook NSLocale
// 伪造 locale（zh_CN）
+ (id)currentLocale {
    NSLocale *fake = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
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
*/

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

#pragma mark - BugsnagDevice

%hook BugsnagDevice
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


%hook AFSDKChecksum
- (NSString *)calculateV2ValueWithTimestamp:(NSString *)timestamp
                                        uid:(NSString *)uid
                              systemVersion:(NSString *)systemVersion
                           firstLaunchDate:(NSString *)firstLaunchDate
                               AFSDKVersion:(NSString *)AFSDKVersion
                                isSimulator:(BOOL)isSimulator
                                 isDevBuild:(BOOL)isDevBuild
                               isJailBroken:(BOOL)isJailBroken
                            isCounterValid:(BOOL)isCounterValid
                       isDebuggerAttached:(BOOL)isDebuggerAttached {

    // 原始值打印
    NSLog(@"\n[HOOK] AFSDKChecksum::calculateV2ValueWithTimestamp 调用参数：\n\
timestamp: %@\n\
uid: %@\n\
systemVersion: %@\n\
firstLaunchDate: %@\n\
AFSDKVersion: %@\n\
isSimulator: %d\n\
isDevBuild: %d\n\
isJailBroken: %d\n\
isCounterValid: %d\n\
isDebuggerAttached: %d",
          timestamp, uid, systemVersion, firstLaunchDate, AFSDKVersion,
          isSimulator, isDevBuild, isJailBroken, isCounterValid, isDebuggerAttached);

    // 你要替换的字段
//    NSString *fakeSystemVersion = @"16.3.1"; // 可改成随机值
    BOOL fakeJailBroken = NO;

    // 调用原方法，传入你篡改后的值
    return %orig(timestamp, uid, systemVersion, firstLaunchDate,
                 AFSDKVersion, isSimulator, isDevBuild,
                 fakeJailBroken, isCounterValid, isDebuggerAttached);
}

%end
