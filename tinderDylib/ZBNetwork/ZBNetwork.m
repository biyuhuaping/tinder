//
//  ZBNetwork.m
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "ZBNetwork.h"

#define APIDomain @"http://117.72.8.80:8989"

@interface ZBNetwork ()

@end

static ZBNetwork *manager = nil;

@implementation ZBNetwork

+ (instancetype)shared {
    static ZBNetwork *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (NSURL *)fullURLWithPath:(NSString *)path {
    if ([path hasPrefix:@"http"]) {
        return [NSURL URLWithString:path];
    } else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APIDomain, path]];
    }
}

#pragma mark - GET, POST 网络请求
+ (void)GET:(NSString *)path param:(NSDictionary *)param success:(Success)success failure:(Failure)failure {
    NSURLComponents *components = [NSURLComponents componentsWithURL:[self fullURLWithPath:path] resolvingAgainstBaseURL:NO];
    if (param) {
        NSMutableArray *queryItems = [NSMutableArray array];
        for (NSString *key in param) {
            NSString *value = [NSString stringWithFormat:@"%@", param[key]];
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:value]];
        }
        components.queryItems = queryItems;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:components.URL];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure(error);
        } else {
            success(data, response);
        }
    }] resume];
}

+ (void)POST:(NSString *)path param:(NSDictionary *)param success:(Success)success failure:(Failure)failure {
    NSURL *url = [self fullURLWithPath:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    if (error) {
        NSLog(@"❌ JSON 序列化失败：%@", error);
        failure(error);
        return;
    }
    request.HTTPBody = jsonData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    if (param) {
//        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
//    }
    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *raw;
        if (data) {
            raw = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"🔍 原始返回数据 string: %@", raw);
        } else {
            NSLog(@"❌ data 是 nil");
        }
        NSLog(@"👇👇👇👇👇👇👇👇👇👇\n地址：%@\n入参：%@\n出参：%@",url, param, raw);
        if (error) {
            failure(error);
        } else {
            success(data, response);
        }
    }] resume];
}

@end
