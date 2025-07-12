//
//  Tools.m
//  tinderDylib
//
//  Created by ZB on 2025/4/21.
//

#import "Tools.h"

@implementation Tools

//字典/数组转JSON
+ (NSString *)convert2JSONWithDictionary:(id)dicOrArray{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicOrArray options:0 error:&err];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",err);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@",jsonString);
    return jsonString;
}

//JSON转字典/数组
+ (NSDictionary *)convert2DictionaryWithJSONString:(NSString *)jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"%@",err);
        return nil;
    }
    return dic;
}

// 工具方法（如放在 UIWindow+ZBAdditions 里）
+ (UIWindow *)keyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    } else {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

@end
