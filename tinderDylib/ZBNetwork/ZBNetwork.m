//
//  ZBNetwork.m
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "ZBNetwork.h"
#import <sys/utsname.h> // 导入sys/utsname.h头文件

#define APIDomain @"http://117.72.8.80:8989"

@interface ZBNetwork ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

static ZBNetwork *manager = nil;

@implementation ZBNetwork

+ (void)initialize{
    [self shareManager];
}

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        // 设置请求以及相应的序列化器
        self.sessionManager = [[AFHTTPSessionManager alloc]init];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:APIDomain]];
#ifdef DEBUG
        self.sessionManager.requestSerializer.timeoutInterval = 60.0f;// 设置超时时间
#else
        self.sessionManager.requestSerializer.timeoutInterval = 20.0;// 设置超时时间
//        [self.sessionManager setSecurityPolicy:[self customSecurityPolicy]];
#endif
        self.sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
        
    }
    return self;
}

#pragma mark - GET, POST 网络请求
//get请求
+ (void)GET:(NSString *_Nullable)urlStr param:(NSDictionary *_Nullable)param success:(Success)success failure:(Failure)failure{
    [manager sendRequestMethod:HTTPMethodGET requestPath:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        BOOL isValid = [manager networkResponseData:response];
        if (success && isValid) {
            success(task, response);
        }else{
            NSError *error = [[NSError alloc]initWithDomain:urlStr code:0 userInfo:response];
            failure(task, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

//post请求
+ (void)POST:(NSString *_Nullable)urlStr param:(NSDictionary *_Nullable)param success:(Success)success failure:(Failure)failure{
    [manager sendRequestMethod:HTTPMethodPOST requestPath:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        BOOL isValid = [manager networkResponseData:response];
        if (success && isValid) {
            success(task, response);
        }else{
            NSError *error = [[NSError alloc]initWithDomain:urlStr code:0 userInfo:response];
            failure(task, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            NSString *message = obj[@"message"];
//            if (message.length > 0) {
////                ShowToast(message);
//            }
//        }
    }];
}

/// 上传文件
/// @param url 服务器地址
/// @param data data类型的文件
/// @param name 名称
/// @param fileName 文件名
/// @param mimeType 文件类型
/// @param progress 上传进度
/// @param success 成功
/// @param failure 失败
+ (nullable NSURLSessionDataTask *)POSTFileWithUrl:(NSString *_Nullable)url fileData:(NSData *_Nullable)data name:(NSString *_Nonnull)name fileName:(NSString *_Nonnull)fileName mimeType:(NSString *_Nonnull)mimeType progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure{
    NSURLSessionDataTask * session = nil;
    NSString *baseUlr = manager.sessionManager.baseURL.absoluteString;

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    
    NSMutableDictionary *headDic = [NSMutableDictionary new];
    headDic[@"UA"] = @"ios";//系统
    headDic[@"version"] = currentVersion;//app版本号
    headDic[@"uuid"] = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    headDic[@"IMEI"] = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    session = [manager.sessionManager POST:url parameters:nil headers:headDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:[NSString stringWithFormat:@"%@.PNG",[NSDate date]] mimeType:@"image/jpeg"];
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"👇👇👇👇👇👇👇👇👇👇\n地址：%@%@\n入参：%@\n出参：%@",baseUlr, url, data, responseObject);
        if (success)success(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"👇👇👇👇👇👇👇👇👇👇\n请求失败地址：%@%@\n入参：%@\n出参：%@",baseUlr, url, data, error.userInfo);
        if (failure) failure([manager failHandleWithErrorResponse:error task:task]);
    }];
    return session;
}

/// 上传图片
/// @param requestPath 服务器地址
/// @param parameters 参数
/// @param imageArray 图片
/// @param width 图片宽度
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
+ (nullable NSURLSessionDataTask *)POSTRequestWithPath:(nonnull NSString *)requestPath parameters:(nullable id)parameters imageArray:(NSArray *_Nullable)imageArray targetWidth:(CGFloat )width progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure {
    NSURLSessionDataTask * task = nil;
    task = [manager.sessionManager POST:requestPath parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSUInteger i = 0 ;
        // 上传图片时，为了用户体验或是考虑到性能需要进行压缩
        for (UIImage * image in imageArray) {
            // 压缩图片，指定宽度（注释：imageCompressed：withdefineWidth：图片压缩的category）
            //            UIImage *  resizedImage =  [UIImage imageCompressed:image withdefineWidth:width];
            NSData * imgData = UIImageJPEGRepresentation(image, 0.5);
            // 拼接Data
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
            i++;
        }
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)success(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure([manager failHandleWithErrorResponse:error task:task]);
    }];
    return task;
}

+ (nullable NSURLSessionDataTask *)POSTRequestWithPath:(nonnull NSString *)requestPath parameters:(nullable id)parameters image:(UIImage *)image targetWidth:(CGFloat )width progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure {
    NSURLSessionDataTask * task = nil;
//    [manager.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"SESSIONTOKEN=%@",AccessToken] forHTTPHeaderField:@"Cookie"];
    NSLog(@"%@",parameters);
    task = [manager.sessionManager POST:requestPath parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
    
        }
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)success(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure([manager failHandleWithErrorResponse:error task:task]);
    }];
    return task;
}

/// 下载文件
/// @param urlStr 下载文件地址
/// @param writePath 写入文件地址
/// @param downloadProgressBlock 下载进度
/// @param completionHandler 成功或失败回调
+ (void) downloadUrlString:(NSString *)urlStr writePath:(NSString *)writePath progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",writePath]];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:path]) {
        //  创建目录
        [fileManger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    if ([fileManger fileExistsAtPath:filePath]) {
        //  创建目录
        completionHandler(nil, [NSURL URLWithString:filePath], nil);
    }else {
        NSURLSessionDownloadTask *downloadTask = [manager.sessionManager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            /* 设定下载到的位置 */
            return [NSURL fileURLWithPath:filePath];
        } completionHandler:completionHandler];
        [downloadTask resume];
    }
}

#pragma mark -
// 获取设备型号
- (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceModel;
}
#pragma mark - 常用网络请求(GET, POST, PUT, PATCH, DELETE)
/**
 常用网络请求方式
 
 @param requestMethod 请求方试
 @param requestPath 请求地址
 @param parameters 参数
 @param progress 进度
 @param success 成功
 @param failure 失败
 @return return value description
 */
- (nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod requestPath:(nonnull NSString *)requestPath parameters:(nullable id)parameters progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(Success)success failure:(Failure)failure {
    NSString *baseUlr = self.sessionManager.baseURL.absoluteString;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    
    NSMutableDictionary *headDic = [NSMutableDictionary new];
    headDic[@"UA"] = @"ios";//系统
    headDic[@"version"] = currentVersion;//app版本号
    headDic[@"uuid"] = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    headDic[@"IMEI"] = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    
    NSURLSessionDataTask * task = nil;
    switch (requestMethod) {
        case HTTPMethodGET: {
            task = [self.sessionManager GET:requestPath parameters:parameters headers:headDic progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"👇👇👇👇👇👇👇👇👇👇\n地址：%@%@\n入参：%@\n出参：%@",baseUlr, requestPath, parameters, responseObject);
                if (success) {
                    success(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"👇👇👇👇👇👇👇👇👇👇\n请求失败地址：%@%@\n入参：%@\n出参：%@",baseUlr, requestPath, parameters, error.userInfo);
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
            
        case HTTPMethodPOST: {
            task = [self.sessionManager POST:requestPath parameters:parameters headers:headDic progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"👇👇👇👇👇👇👇👇👇👇\n地址：%@%@\n入参：%@\n出参：%@",baseUlr, requestPath, parameters, responseObject);
                if (success) {
                    success(task, responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"👇👇👇👇👇👇👇👇👇👇\n请求失败地址：%@%@\n入参：%@\n出参：%@",baseUlr, requestPath, parameters, error.userInfo);
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
        default:break;
    }
    return task;
}

#pragma mark - 网络回调统一处理
//网络回调统一处理
- (BOOL)networkResponseData:(id)response{
    id data = response[@"data"];
    if (!data || [data isKindOfClass:NSArray.class] || [data isKindOfClass:NSNull.class]) {
        
    }
    int code = [response[@"code"] intValue];//0000 为正确
//    if (status == 2000) {
//        [Tools removeCookie];
//        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
//        UIViewController *vc = [Tools getCurrentVC];
//        [vc.navigationController popToRootViewControllerAnimated:YES];
//        [ZBAlertView showAlertWithTitile:@"提示:" message:@"登录过期请重新登录" leftTitle:@"取消" rightTitle:@"重新登录" clickButton:^(NSInteger index) {
//            if (index == 1) {
//                UIViewController *vc = [Tools getCurrentVC];
//                if (vc) {
//                    [vc presentViewController:[[BaseNavigationController alloc] initWithRootViewController:[DRRegisterViewController new]] animated:YES completion:nil];
//                }
//            }
//        }];
//    }
//    if (status >= 1000 && status < 2000) {//请求成功
//        return YES;
//    }else if ([response isKindOfClass:[NSDictionary class]]) {//请求失败，显示提示
//        NSString *message = response[@"message"];
//        if (message.length > 0) {
////            ShowToast(message);
//        }
//        return NO;
//    }
    
    switch (code) {
        case 0:{// 请求失败
            return NO;
        }break;
        case 1:{//请求成功
            return YES;
        }break;
        case -1:{//强制退出
            
            return NO;
        }break;
        case -2:{//强制更新
            return NO;
        }break;
        case 200:{//弹出对话框
            return YES;
        }break;
    }
    return YES;
}

#pragma mark 报错信息
/**
 处理报错信息
 
 @param error AFN返回的错误信息
 @param task 任务
 @return description
 */
- (NSString *)failHandleWithErrorResponse:( NSError * _Nullable )error task:( NSURLSessionDataTask * _Nullable )task {
    // 这里可以直接设定错误反馈，也可以利用AFN 的error信息直接解析展示
    NSData *afNetworking_errorMsg = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSLog(@"afNetworking_errorMsg == %@",[[NSString alloc]initWithData:afNetworking_errorMsg encoding:NSUTF8StringEncoding]);
    __block NSString *message = nil;
    if (!afNetworking_errorMsg) {
        message = @"网络连接失败";
    }
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger responseStatue = response.statusCode;
    if (responseStatue >= 500) {  // 网络错误
        message = @"服务器维护升级中,请耐心等待";
    } else if (responseStatue >= 400) {
        // 错误信息
        NSDictionary *responseObject = @{};
        if (afNetworking_errorMsg) {
            responseObject = [NSJSONSerialization JSONObjectWithData:afNetworking_errorMsg options:NSJSONReadingAllowFragments error:nil];
        }
        message = responseObject[@"error"];
    }
    NSLog(@"error == %@",error);
    return message;
}

- (AFSecurityPolicy*)customSecurityPolicy{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server1" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSMutableSet<NSData *> *pinnedCertificates = [NSMutableSet set];
    [pinnedCertificates addObject:certData];
    securityPolicy.pinnedCertificates = pinnedCertificates;
    
    return securityPolicy;
}

#pragma mark - 取消全部请求
+ (void)cancelAllNetworkRequest {
    [[ZBNetwork shareManager].sessionManager.operationQueue cancelAllOperations];
}

#pragma mark 取消指定请求
/**
 *  取消指定的url请求
 *
 *  @param type 该请求的请求类型
 *  @param path 该请求的完整url
 */
+ (void)cancelHttpRequestWithType:(NSString *)type WithPath:(NSString *)path {
    NSError * error;
    // 根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求
    NSString * urlToPeCanced = [[[[ZBNetwork shareManager].sessionManager.requestSerializer requestWithMethod:type URLString:path parameters:nil error:&error] URL] path];
    
    for (NSOperation * operation in [ZBNetwork shareManager].sessionManager.operationQueue.operations) {
        // 如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            // 请求的类型匹配
            BOOL hasMatchRequestType = [type isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            // 请求的url匹配
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            // 两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                [operation cancel];
            }
        }
    }
}

@end
