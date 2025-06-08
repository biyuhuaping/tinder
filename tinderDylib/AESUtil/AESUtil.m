//
//  AESUtil.m
//  YaoBangMang
//
//  Created by ZB on 2021/8/18.
//  Copyright © 2021 XiaoYaoYao.Ltd. All rights reserved.
//

#import "AESUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

// 激活码秘钥key
NSString *kAESKey = @"1234567890abcdef";

@implementation AESUtil

/// AES加密
+ (NSString *)aesEncrypt:(NSString *)sourceStr{
    return [self aesEncrypt:sourceStr AESKey:kAESKey];
}
/// AES解密
+ (NSString *)aesDecrypt:(NSString *)secretStr{
    return [self aesDecrypt:secretStr AESKey:kAESKey];
}

#pragma mark -
// AES加密
+ (NSString *)aesEncrypt:(NSString *)sourceStr AESKey:(NSString *)key{
    if (!sourceStr) {
        return nil;
    }
    
    NSData *contentData = [sourceStr dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    // 为结束符'\\0' +1
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    //16位偏移，CBC模式才有
    NSData *initVector = [key dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(
                                          kCCEncrypt,//kCCEncrypt 代表加密 kCCDecrypt代表解密
                                          kCCAlgorithmAES,//加密算法
                                          kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding，iOS只有CBC和ECB模式，如果想使用ECB模式，可以这样编写  kCCOptionPKCS7Padding | kCCOptionECBMode
                                          keyPtr,//公钥
                                          kCCKeySizeAES128,//密钥长度128
                                          initVector.bytes,//偏移字符串
                                          contentData.bytes,//编码内容
                                          dataLength,//数据长度
                                          encryptedBytes,//加密输出缓冲区
                                          encryptSize,//加密输出缓冲区大小
                                          &actualOutSize);//实际输出大小
    if (cryptStatus == kCCSuccess) {
        //对加密后的二进制数据进行base64转码
        NSData *encryptData = [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
        NSString *result = [encryptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
//        NSString *str = [self aesDecrypt:result];
//        NSLog(@"===--- %@",str);
        return result;
    }else{
        free(encryptedBytes);
        return nil;
    }
}

// AES解密
+ (NSString *)aesDecrypt:(NSString *)secretStr AESKey:(NSString *)key{
    if (!secretStr) {
        return nil;
    }
    // 1️⃣ Base64 解码密文字符串，得到原始的加密数据
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:secretStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

    // 2️⃣ 准备密钥：将 key 字符串转成 C 字符数组 keyPtr
    char keyPtr[kCCKeySizeAES128 + 1];// AES128 = 16字节 +1是为了清零补位
    bzero(keyPtr, sizeof(keyPtr));// 清空 keyPtr
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];// UTF8编码拷贝到 keyPtr
    NSUInteger dataLength = [decodeData length];// 原始密文长度
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;// 原始密文长度
    
    // 4️⃣ 设置 IV（初始向量），这里直接使用 key 转 NSData，16位偏移，CBC模式才有
    NSData *initVector = [key dataUsingEncoding:NSUTF8StringEncoding];
    // 5️⃣ 执行解密（使用 AES-CBC 模式 + PKCS7Padding）
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, keyPtr, kCCBlockSizeAES128, initVector.bytes, [decodeData bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess){
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return result;
    }else{
        free(buffer);
        return nil;
    }
}

@end
