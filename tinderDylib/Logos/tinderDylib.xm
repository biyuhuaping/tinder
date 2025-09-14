// See http://iphonedevwiki.net/index.php/Logos

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CustomViewController

@property (nonatomic, copy) NSString* newProperty;

+ (void)classMethod;

- (NSString*)getMyName;

- (void)newMethod:(NSString*) output;

@end

%hook CustomViewController

+ (void)classMethod
{
	%log;

	%orig;
}

%new
-(void)newMethod:(NSString*) output{
    NSLog(@"This is a new method : %@", output);
}

%new
- (id)newProperty {
    return objc_getAssociatedObject(self, @selector(newProperty));
}

%new
- (void)setNewProperty:(id)value {
    objc_setAssociatedObject(self, @selector(newProperty), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)getMyName{
	%log;
    NSString* password = MSHookIvar<NSString*>(self,"_password");
    NSLog(@"password:%@", password);
    
    [%c(CustomViewController) classMethod];
    [self newMethod:@"output"];
    self.newProperty = @"newProperty";
    NSLog(@"newProperty : %@", self.newProperty);
    
	return %orig();
}

%end

#pragma mark - IDFA
%hook ASIdentifierManager
//（IDFA）
- (NSUUID *)advertisingIdentifier {
    NSLog(@"[Hooked] 原来的IDFA: %@", %orig);
    NSString *key = @"my_hooked_advertisingIdentifier_key";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedUUID = [defaults stringForKey:key];

    if (savedUUID && savedUUID.length > 0) {
        NSLog(@"[Hooked] Returning saved IDFA: %@", savedUUID);
        return [[NSUUID alloc] initWithUUIDString:savedUUID];
    } else {
        NSUUID *newUUID = [NSUUID UUID];
        NSString *newUUIDStr = [newUUID UUIDString];
        NSLog(@"[Hooked] No saved IDFA. Generated new: %@", newUUIDStr);

        [defaults setObject:newUUIDStr forKey:key];
        [defaults synchronize];

        return newUUID;
    }
    return %orig;
}

%end

#pragma mark - UIDevice（IDFV）
%hook UIDevice
//（IDFV）
- (NSUUID *)identifierForVendor {
    NSLog(@"[Hooked] 原来的IDFV: %@", %orig);
    NSString *key = @"my_hooked_identifierForVendor_key";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedUUID = [defaults stringForKey:key];

    if (savedUUID && savedUUID.length > 0) {
        NSLog(@"[Hooked] 保存原来的IDFV（UUID）: %@", savedUUID);
        return [[NSUUID alloc] initWithUUIDString:savedUUID];
    } else {
        // 生成新的 UUID
        NSUUID *newUUID = [NSUUID UUID];
        NSString *newUUIDStr = [newUUID UUIDString];
        NSLog(@"[Hooked] 生成新的IDFV（UUID）: %@", newUUIDStr);

        // 保存到 UserDefaults
        [defaults setObject:newUUIDStr forKey:key];
        [defaults synchronize];

        return newUUID;
    }
    return %orig;
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
+ (NSData *)dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error {
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


%hook SecTrust
// iOS 13 及以上：SecTrustEvaluateWithError
- (BOOL)evaluateWithError:(NSError **)error {
    NSLog(@"[HOOK] SecTrustEvaluateWithError 被调用，直接返回 YES");
    return YES; // 永远验证通过
}

%end


%hook UIApplication

- (BOOL)openURL:(NSURL *)url {
    NSLog(@"[hook] UIApplication openURL: %@", url);
    // 修改 URL 示例
    // NSURL *newURL = [NSURL URLWithString:@"myapp://hijacked"];
    // return %orig(newURL);

    // 拦截并阻止打开
    // return NO;

    // 继续原逻辑
    return %orig(url);
}
//iOS10+
- (void)openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey,id> *)options completionHandler:(void (^)(BOOL))completion {
    NSLog(@"[hook] openURL:options: %@", url);
    // 可以在这里修改 options 或 url
    NSURL *modified = url;
    // call original
    %orig(modified, options, completion);
}

%end

%hook AppDelegate // 或者你的具体 AppDelegate 类名

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"[hook] AppDelegate openURL: %@", url);
    // 拦截
    // return NO;
    return %orig(application, url, options);
}

%end

%hook SceneDelegate // 或者具体类名，如 "UIWindowSceneDelegate" 的实现类

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    for (UIOpenURLContext *ctx in URLContexts) {
        NSLog(@"[hook] Scene openURLContexts: %@", ctx.URL);
        // 修改或忽略
    }
    %orig(scene, URLContexts);
}

%end

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

