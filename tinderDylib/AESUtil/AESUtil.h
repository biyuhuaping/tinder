//
//  AESUtil.h
//  YaoBangMang
//
//  Created by ZB on 2021/8/18.
//  Copyright © 2021 XiaoYaoYao.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// AES工具类
@interface AESUtil : NSObject

/// AES加密
+ (NSString *)aesEncrypt:(NSString *)sourceStr;
/// AES解密
+ (NSString *)aesDecrypt:(NSString *)secretStr;

#pragma mark -

/// AES加密
/// - Parameters:
///   - sourceStr: 需要加密的内容
///   - key: 密钥
+ (NSString *)aesEncrypt:(NSString *)sourceStr AESKey:(NSString *)key;

/// AES解密
/// - Parameters:
///   - sourceStr: 需要解密的内容
///   - key: 密钥
+ (NSString *)aesDecrypt:(NSString *)secretStr AESKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
