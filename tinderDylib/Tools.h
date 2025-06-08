//
//  Tools.h
//  tinderDylib
//
//  Created by ZB on 2025/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

/// 字典/数组转JSON
+ (NSString *)convert2JSONWithDictionary:(id)dicOrArray;
/// JSON转字典/数组
+ (NSDictionary *)convert2DictionaryWithJSONString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
