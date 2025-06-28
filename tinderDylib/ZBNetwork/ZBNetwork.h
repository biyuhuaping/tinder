//
//  ZBNetwork.h
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import <Foundation/Foundation.h>

//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"\n %s:%d   %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]);
//#else
//#define NSLog(...)
//#endif

//typedef void(^Success)(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable response);
//typedef void(^Failure)(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error);

typedef void(^Success)(NSData * _Nullable data, NSURLResponse * _Nullable response);
typedef void(^Failure)(NSError * _Nullable error);

@interface ZBNetwork : NSObject

///get请求
//+ (void)GET:(NSString *_Nullable)urlStr param:(NSDictionary *_Nullable)param success:(Success _Nullable)success failure:(Failure _Nullable)failure;
//
/////post请求
//+ (void)POST:(NSString *_Nullable)urlStr param:(NSDictionary *_Nullable)param success:(Success _Nullable)success failure:(Failure _Nullable)failure;

+ (void)GET:(NSString *_Nullable)urlStr param:(NSDictionary *_Nullable)param success:(Success _Nullable)success failure:(Failure _Nullable)failure;
+ (void)POST:(NSString *_Nullable)urlStr param:(NSDictionary *_Nullable)param success:(Success _Nullable)success failure:(Failure _Nullable)failure;

@end
