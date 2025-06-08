//
//  ZBNetwork.h
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"\n %s:%d   %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]);
//#else
//#define NSLog(...)
//#endif

/**
 * GET：获取资源，不会改动资源
 * POST：创建记录
 * PATCH：改变资源状态或更新部分属性
 * PUT：更新全部属性
 * DELETE：删除资源
 */
typedef NS_ENUM(NSUInteger, HTTPMethod) {
    HTTPMethodGET,
    HTTPMethodPOST,
    HTTPMethodPUT,
    HTTPMethodPATCH,
    HTTPMethodDELETE,
};

typedef void(^Success)(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable response);
typedef void(^Failure)(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error);


@interface ZBNetwork : NSObject

///get请求
+ (void)GET:(NSString *_Nullable)urlStr param:(NSDictionary *_Nullable)param success:(Success _Nullable)success failure:(Failure _Nullable)failure;

///post请求
+ (void)POST:(NSString *_Nullable)urlStr param:(NSDictionary *_Nullable)param success:(Success _Nullable)success failure:(Failure _Nullable)failure;


/// 上传文件
/// @param url 服务器地址
/// @param data data类型的文件
/// @param name 名称
/// @param fileName 文件名
/// @param mimeType 文件类型
/// @param progress 上传进度
/// @param success 成功
/// @param failure 失败
+ (nullable NSURLSessionDataTask *)POSTFileWithUrl:(NSString *_Nullable)url fileData:(NSData *_Nullable)data name:(NSString *_Nonnull)name fileName:(NSString *_Nonnull)fileName mimeType:(NSString *_Nonnull)mimeType progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure;


/// 上传图片
/// @param requestPath 服务器地址
/// @param parameters 参数
/// @param imageArray 图片
/// @param width 图片宽度
/// @param progress 进度
/// @param success 成功
/// @param failure 失败
+ (nullable NSURLSessionDataTask *)POSTRequestWithPath:(nonnull NSString *)requestPath parameters:(nullable id)parameters imageArray:(NSArray *_Nullable)imageArray targetWidth:(CGFloat )width progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure;

+ (nullable NSURLSessionDataTask *)POSTRequestWithPath:(nonnull NSString *)requestPath parameters:(nullable id)parameters image:(UIImage *_Nullable)image targetWidth:(CGFloat )width progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure;


/// 下载文件
/// @param urlStr 下载文件地址
/// @param writePath 写入文件地址
/// @param downloadProgressBlock 下载进度
/// @param completionHandler 成功或失败回调
+ (void) downloadUrlString:(NSString *_Nullable)urlStr writePath:(NSString *_Nullable)writePath progress:(void (^_Nullable)(NSProgress * _Nullable downloadProgress)) downloadProgressBlock completionHandler:(void (^_Nullable)(NSURLResponse * _Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

@end
