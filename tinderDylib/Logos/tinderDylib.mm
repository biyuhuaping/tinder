#line 1 "/Users/zb/gitCode/tinder/tinderDylib/Logos/tinderDylib.xm"


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "fishhook.h"  
#include <sys/sysctl.h>         

#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"device_config.json"]
#define kAutoPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"auto_status.json"]



static NSDictionary *loadConfigJson() {
    
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


static NSString *fakeUserAgent() {
    NSDictionary *config = loadConfigJson();
    NSString *uaStr = config[@"ua"];
    if ([uaStr isKindOfClass:[NSString class]] && uaStr.length > 0) {
        return uaStr;
    }
    
    return fakeUserAgent();
}


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

__asm__(".linker_option \"-framework\", \"CydiaSubstrate\"");

@class GADOMIDDevice; @class BugsnagDevice; @class ASIdentifierManager; @class UIScreen; @class UIDevice; @class GADDevice; @class AppsFlyerUtils; @class NSJSONSerialization; @class AFSDKChecksum; @class WKWebView; @class CTCarrier; @class UADSMetricCommonTags; @class NSProcessInfo; @class NSBundle; @class USRVDevice; 
static NSUUID * (*_logos_orig$_ungrouped$ASIdentifierManager$advertisingIdentifier)(_LOGOS_SELF_TYPE_NORMAL ASIdentifierManager* _LOGOS_SELF_CONST, SEL); static NSUUID * _logos_method$_ungrouped$ASIdentifierManager$advertisingIdentifier(_LOGOS_SELF_TYPE_NORMAL ASIdentifierManager* _LOGOS_SELF_CONST, SEL); static NSUUID * (*_logos_orig$_ungrouped$UIDevice$identifierForVendor)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSUUID * _logos_method$_ungrouped$UIDevice$identifierForVendor(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$model)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$model(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$name)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$name(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$systemName)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$systemName(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$systemVersion)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$systemVersion(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static float (*_logos_orig$_ungrouped$UIDevice$batteryLevel)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static float _logos_method$_ungrouped$UIDevice$batteryLevel(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIDeviceBatteryState (*_logos_orig$_ungrouped$UIDevice$batteryState)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIDeviceBatteryState _logos_method$_ungrouped$UIDevice$batteryState(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIDeviceOrientation (*_logos_orig$_ungrouped$UIDevice$orientation)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIDeviceOrientation _logos_method$_ungrouped$UIDevice$orientation(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIUserInterfaceIdiom (*_logos_orig$_ungrouped$UIDevice$userInterfaceIdiom)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIUserInterfaceIdiom _logos_method$_ungrouped$UIDevice$userInterfaceIdiom(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$serialNumber)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$serialNumber(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSData * (*_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static NSData * _logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static NSData * (*_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static NSData * _logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static id (*_logos_meta_orig$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSData *, NSJSONReadingOptions, NSError **); static id _logos_meta_method$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSData *, NSJSONReadingOptions, NSError **); static void (*_logos_orig$_ungrouped$WKWebView$loadRequest$)(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSURLRequest *); static void _logos_method$_ungrouped$WKWebView$loadRequest$(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSURLRequest *); static void (*_logos_orig$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$)(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSString *, void (^)(id result, NSError *error)); static void _logos_method$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSString *, void (^)(id result, NSError *error)); static NSDictionary * (*_logos_orig$_ungrouped$NSBundle$infoDictionary)(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); static NSDictionary * _logos_method$_ungrouped$NSBundle$infoDictionary(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); static int (*_logos_orig$_ungrouped$BugsnagDevice$jailbroken)(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$BugsnagDevice$jailbroken(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$BugsnagDevice$locale)(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$BugsnagDevice$locale(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$BugsnagDevice$modelNumber)(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$BugsnagDevice$modelNumber(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$BugsnagDevice$setOsVersion$)(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL, NSString *); static void _logos_method$_ungrouped$BugsnagDevice$setOsVersion$(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL, NSString *); static int (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$isVPNConnected)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isVPNConnected(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static id (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$getStoreReceipt)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static id _logos_meta_method$_ungrouped$AppsFlyerUtils$getStoreReceipt(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static int (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$isValidDeeplink$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isValidDeeplink$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$isOneLinkValid$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isOneLinkValid$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$currentVersionMatchesPattern$version$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int, int); static int _logos_meta_method$_ungrouped$AppsFlyerUtils$currentVersionMatchesPattern$version$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int, int); static int (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static NSString * (*_logos_orig$_ungrouped$CTCarrier$carrierName)(_LOGOS_SELF_TYPE_NORMAL CTCarrier* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$CTCarrier$carrierName(_LOGOS_SELF_TYPE_NORMAL CTCarrier* _LOGOS_SELF_CONST, SEL); static unsigned long long (*_logos_orig$_ungrouped$NSProcessInfo$physicalMemory)(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static unsigned long long _logos_method$_ungrouped$NSProcessInfo$physicalMemory(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$NSProcessInfo$isLowPowerModeEnabled)(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$NSProcessInfo$isLowPowerModeEnabled(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static NSOperatingSystemVersion (*_logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersion)(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static NSOperatingSystemVersion _logos_method$_ungrouped$NSProcessInfo$operatingSystemVersion(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersionString)(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$NSProcessInfo$operatingSystemVersionString(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static CGFloat (*_logos_orig$_ungrouped$UIScreen$brightness)(_LOGOS_SELF_TYPE_NORMAL UIScreen* _LOGOS_SELF_CONST, SEL); static CGFloat _logos_method$_ungrouped$UIScreen$brightness(_LOGOS_SELF_TYPE_NORMAL UIScreen* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$GADOMIDDevice$deviceOsVersion)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$GADOMIDDevice$deviceOsVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$USRVDevice$getOsVersion)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$USRVDevice$getOsVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$GADDevice$systemVersion)(_LOGOS_SELF_TYPE_NORMAL GADDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$GADDevice$systemVersion(_LOGOS_SELF_TYPE_NORMAL GADDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$UADSMetricCommonTags$systemVersion)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$UADSMetricCommonTags$systemVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UADSMetricCommonTags$systemVersion)(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UADSMetricCommonTags$systemVersion(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST, SEL); static UADSMetricCommonTags* (*_logos_orig$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$)(_LOGOS_SELF_TYPE_INIT UADSMetricCommonTags*, SEL, NSString *, NSString *, NSString *, NSString *, BOOL, NSDictionary *) _LOGOS_RETURN_RETAINED; static UADSMetricCommonTags* _logos_method$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$(_LOGOS_SELF_TYPE_INIT UADSMetricCommonTags*, SEL, NSString *, NSString *, NSString *, NSString *, BOOL, NSDictionary *) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$_ungrouped$UADSMetricCommonTags$setSystemVersion$)(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST, SEL, NSString *); static void _logos_method$_ungrouped$UADSMetricCommonTags$setSystemVersion$(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST, SEL, NSString *); static NSString * (*_logos_orig$_ungrouped$AFSDKChecksum$calculateV2ValueWithTimestamp$uid$systemVersion$firstLaunchDate$AFSDKVersion$isSimulator$isDevBuild$isJailBroken$isCounterValid$isDebuggerAttached$)(_LOGOS_SELF_TYPE_NORMAL AFSDKChecksum* _LOGOS_SELF_CONST, SEL, NSString *, NSString *, NSString *, NSString *, NSString *, BOOL, BOOL, BOOL, BOOL, BOOL); static NSString * _logos_method$_ungrouped$AFSDKChecksum$calculateV2ValueWithTimestamp$uid$systemVersion$firstLaunchDate$AFSDKVersion$isSimulator$isDevBuild$isJailBroken$isCounterValid$isDebuggerAttached$(_LOGOS_SELF_TYPE_NORMAL AFSDKChecksum* _LOGOS_SELF_CONST, SEL, NSString *, NSString *, NSString *, NSString *, NSString *, BOOL, BOOL, BOOL, BOOL, BOOL); 

#line 42 "/Users/zb/gitCode/tinder/tinderDylib/Logos/tinderDylib.xm"
#pragma mark - IDFA


static NSUUID * _logos_method$_ungrouped$ASIdentifierManager$advertisingIdentifier(_LOGOS_SELF_TYPE_NORMAL ASIdentifierManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *config = loadConfigJson();
    NSString *customIDFA = config[@"idfa"];
    
    if ([customIDFA isKindOfClass:[NSString class]] && customIDFA.length > 0) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:customIDFA];
        if (uuid) {
            return uuid;
        }
    }
    
    return _logos_orig$_ungrouped$ASIdentifierManager$advertisingIdentifier(self, _cmd);
}
























#pragma mark - UIDevice


static NSUUID * _logos_method$_ungrouped$UIDevice$identifierForVendor(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *config = loadConfigJson();
    NSString *customIDFV = config[@"idfv"];

    
    if ([customIDFV isKindOfClass:[NSString class]] && customIDFV.length > 0) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:customIDFV];
        if (uuid) {
            return uuid;
        }
    }
    
    return _logos_orig$_ungrouped$UIDevice$identifierForVendor(self, _cmd);
}



























static NSString * _logos_method$_ungrouped$UIDevice$model(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *config = loadConfigJson();
    NSString *revisionStr = config[@"revision"] ?: _logos_orig$_ungrouped$UIDevice$model(self, _cmd);
    if (revisionStr) return revisionStr;
    return _logos_orig$_ungrouped$UIDevice$model(self, _cmd); 
}


static NSString * _logos_method$_ungrouped$UIDevice$name(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *config = loadConfigJson();
    return config[@"iPhone_name"] ?: _logos_orig$_ungrouped$UIDevice$name(self, _cmd);
}


static NSString * _logos_method$_ungrouped$UIDevice$systemName(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *original = _logos_orig$_ungrouped$UIDevice$systemName(self, _cmd);
    return @"iOS"; 
}


static NSString * _logos_method$_ungrouped$UIDevice$systemVersion(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *config = loadConfigJson();
    return config[@"osv"] ?: _logos_orig$_ungrouped$UIDevice$systemVersion(self, _cmd);
}


static float _logos_method$_ungrouped$UIDevice$batteryLevel(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    float original = _logos_orig$_ungrouped$UIDevice$batteryLevel(self, _cmd);
    NSDictionary *config = loadConfigJson();
    
    if (config && [config[@"battery"] isKindOfClass:[NSNumber class]]) {
        float rawValue = [config[@"battery"] floatValue];
        float rounded = roundf(rawValue * 100) / 100.0f;
        
        return rounded;
    }
    
    return 0.76f;
}


static UIDeviceBatteryState _logos_method$_ungrouped$UIDevice$batteryState(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UIDeviceBatteryState origState = _logos_orig$_ungrouped$UIDevice$batteryState(self, _cmd);

    
    
    NSDictionary *config = loadConfigJson();
    NSInteger state = 1; 
    id raw = config[@"batteryState"];
    if ([raw respondsToSelector:@selector(integerValue)]) {
        state = [raw integerValue] ?: 1;
    }
    UIDeviceBatteryState spoofedState = (UIDeviceBatteryState)state;
    return spoofedState;
}


static UIDeviceOrientation _logos_method$_ungrouped$UIDevice$orientation(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UIDeviceOrientation original = _logos_orig$_ungrouped$UIDevice$orientation(self, _cmd);
    return UIDeviceOrientationPortrait; 
}


static UIUserInterfaceIdiom _logos_method$_ungrouped$UIDevice$userInterfaceIdiom(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    UIUserInterfaceIdiom original = _logos_orig$_ungrouped$UIDevice$userInterfaceIdiom(self, _cmd);
    return UIUserInterfaceIdiomPhone; 
}


static NSString * _logos_method$_ungrouped$UIDevice$serialNumber(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$UIDevice$serialNumber(self, _cmd); 
    return [NSString stringWithFormat:@"%02X%02X%02X%02X",
        arc4random_uniform(256), arc4random_uniform(256),
        arc4random_uniform(256), arc4random_uniform(256)];
}


#pragma mark - CLLocation











































































#pragma mark - NSJSONSerialization




static NSData * _logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id obj, NSJSONWritingOptions opt, NSError ** error) {
    
    NSData *result = _logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$(self, _cmd, obj, opt, error);
    
    if (result) {

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

static NSData * _logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id obj, NSJSONWritingOptions opt, NSError ** error) {
    
    if (![obj isKindOfClass:[NSDictionary class]]) {
        return _logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$(self, _cmd, obj, opt, error);
    }

    
    NSMutableDictionary *mutableJSON = DeepMutableCopy(obj);

    
    NSDictionary *config = loadConfigJson();
    NSString *osv = config[@"osv"];
    if (osv && [osv isKindOfClass:[NSString class]]) {
        
        mutableJSON[@"system_version"] = osv;

        NSMutableDictionary *device = mutableJSON[@"device"];
        if ([device isKindOfClass:[NSMutableDictionary class]]) {
            device[@"osVersion"] = osv;
        }

        NSLog(@"[Hook] 替换 system_version / device.osVersion 为 %@", osv);
    }

    
    NSError *localErr = nil;
    NSData *modifiedData = _logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$(self, _cmd, mutableJSON, opt, &localErr);
    if (modifiedData) {
        NSLog(@"[Hook] 修改后的 JSON：%@", mutableJSON);
        return modifiedData;
    } else {
        NSLog(@"[Hook] 重新编码 JSON 出错：%@", localErr);
        return _logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$(self, _cmd, obj, opt, error);
    }
}



static id _logos_meta_method$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSData * data, NSJSONReadingOptions opt, NSError ** error) {
    id jsonObj = _logos_meta_orig$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$(self, _cmd, data, opt, error);

    return jsonObj;
}


#pragma mark - NSURLSession






































































































































#pragma mark - WKWebView

static void _logos_method$_ungrouped$WKWebView$loadRequest$(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURLRequest * request) {
    NSLog(@"📦 WKWebView 请求：%@", request.URL.absoluteString);
    return _logos_orig$_ungrouped$WKWebView$loadRequest$(self, _cmd, request);
}
static void _logos_method$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * javaScriptString, void (^completionHandler)(id result, NSError *error)) {
    NSLog(@"📡 [WKWebView] evaluateJavaScript called:\n%@", javaScriptString);

    
    
    if ([javaScriptString containsString:@"submit"]) {
        NSLog(@"🚨 可能是提交表单相关 JS");
    }
    
    _logos_orig$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$(self, _cmd, javaScriptString, completionHandler);
}



#pragma mark - NSBundle


static NSDictionary * _logos_method$_ungrouped$NSBundle$infoDictionary(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *originalDict = _logos_orig$_ungrouped$NSBundle$infoDictionary(self, _cmd);
    NSMutableDictionary *mutableDict = [originalDict mutableCopy];

    NSDictionary *config = loadConfigJson();
    NSString *fakeOS = config[@"osv"];
    if (fakeOS && mutableDict[@"DTPlatformVersion"]) {

        mutableDict[@"DTPlatformVersion"] = fakeOS;
    }

    return [mutableDict copy];
}



#pragma mark - NSLocale















































































#pragma mark - 修改 machine的系统版本号
static int (*orig_sysctlbyname)(const char *, void *, size_t *, const void *, size_t);
static int my_sysctlbyname(const char *name, void *oldp, size_t *oldlenp, const void *newp, size_t newlen) {
    NSDictionary *config = loadConfigJson();
    if (strcmp(name, "kern.osproductversion") == 0) {

        NSString *osv = config[@"osv"];  
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
        NSString *osv = config[@"osversion"];
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
        NSString *str = config[@"model"];
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

static char *(*orig_getenv)(const char *name) = NULL;


static char *my_getenv(const char *name) {
    if (name && strcmp(name, "DYLD_INSERT_LIBRARIES") == 0) {
        
        NSLog(@"⚠️ 已拦截 getenv(\"DYLD_INSERT_LIBRARIES\")，返回 NULL 以绕过检测");
        return NULL; 
    }
    
    return orig_getenv(name);
}


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









































#pragma mark - Auth.RefreshTokenInteractor













































































































































































































#pragma mark - BugsnagDevice



static int _logos_method$_ungrouped$BugsnagDevice$jailbroken(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    int jailbroken = _logos_orig$_ungrouped$BugsnagDevice$jailbroken(self, _cmd);
    NSLog(@"[Hook]jailbroken: %d", jailbroken);
    return 0;
}
static NSString * _logos_method$_ungrouped$BugsnagDevice$locale(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *orig = _logos_orig$_ungrouped$BugsnagDevice$locale(self, _cmd);
    NSLog(@"[Hook] locale: %@", orig);
    NSDictionary *config = loadConfigJson();
    NSString *locale = config[@"locale"] ?: _logos_orig$_ungrouped$BugsnagDevice$locale(self, _cmd);
    return locale;
}
static NSString * _logos_method$_ungrouped$BugsnagDevice$modelNumber(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *orig = _logos_orig$_ungrouped$BugsnagDevice$modelNumber(self, _cmd);
    NSLog(@"[Hook] modelNumber (orig): %@", orig);
    return orig;
}

static void _logos_method$_ungrouped$BugsnagDevice$setOsVersion$(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * osVersion) {
    NSDictionary *config = loadConfigJson();
    NSString *fakeOSV = config[@"osv"];
    if (fakeOSV && [fakeOSV isKindOfClass:[NSString class]]) {
        NSLog(@"[HOOK] 替换 setOsVersion: %@ -> %@", osVersion, fakeOSV);
        _logos_orig$_ungrouped$BugsnagDevice$setOsVersion$(self, _cmd, fakeOSV);
    } else {
        _logos_orig$_ungrouped$BugsnagDevice$setOsVersion$(self, _cmd, osVersion);
    }
}











static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int skipAdvanced) {
    NSLog(@"[Hook] AppsFlyerUtils isJailbrokenWithSkipAdvancedJailbreakValidation: %d", skipAdvanced);
    return 0; 
}

static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isVPNConnected(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"[Hook] AppsFlyerUtils isVPNConnected %d", _logos_meta_orig$_ungrouped$AppsFlyerUtils$isVPNConnected(self, _cmd));
    return 0; 
}



static id _logos_meta_method$_ungrouped$AppsFlyerUtils$getStoreReceipt(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    id original = _logos_meta_orig$_ungrouped$AppsFlyerUtils$getStoreReceipt(self, _cmd);
    NSLog(@"🍌 [Original Receipt] %@", original);
    return original; 
}



static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isValidDeeplink$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg) {
    int original = _logos_meta_orig$_ungrouped$AppsFlyerUtils$isValidDeeplink$(self, _cmd, arg);
    NSLog(@"🍌 [Original Deeplink] %d", original);
    return 1; 
}


static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isOneLinkValid$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg) {
    int original = _logos_meta_orig$_ungrouped$AppsFlyerUtils$isOneLinkValid$(self, _cmd, arg);
    NSLog(@"🍌 [Original OneLink] %d", original);
    return 1; 
}


static int _logos_meta_method$_ungrouped$AppsFlyerUtils$currentVersionMatchesPattern$version$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg1, int arg2) {
    int original = _logos_meta_orig$_ungrouped$AppsFlyerUtils$currentVersionMatchesPattern$version$(self, _cmd, arg1, arg2);
    NSLog(@"🍌 [Original VersionMatch] %d", original);
    return 1; 
}











static int _logos_meta_method$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg) {
    int original = _logos_meta_orig$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$(self, _cmd, arg);
    NSLog(@"🍌 [Original CachePurchase] %d", original);
    return 1; 
}



#pragma mark - BSGPersistentDeviceID


































#pragma mark - CTCarrier


static NSString * _logos_method$_ungrouped$CTCarrier$carrierName(_LOGOS_SELF_TYPE_NORMAL CTCarrier* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    
    NSString *originalName = _logos_orig$_ungrouped$CTCarrier$carrierName(self, _cmd);
    
    NSDictionary *config = loadConfigJson();
    return config[@"carrier"];
}


#pragma mark - NSProcessInfo


static unsigned long long _logos_method$_ungrouped$NSProcessInfo$physicalMemory(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    unsigned long long orig = _logos_orig$_ungrouped$NSProcessInfo$physicalMemory(self, _cmd);
    
    NSDictionary *config = loadConfigJson();
    NSNumber *tmValue = config[@"tm"];
    
    if (tmValue && [tmValue isKindOfClass:[NSNumber class]]) {
        return [tmValue unsignedLongLongValue];
    } else {
        return orig; 
    }
}


static BOOL _logos_method$_ungrouped$NSProcessInfo$isLowPowerModeEnabled(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *config = loadConfigJson();
    BOOL isLpm = [config[@"lpm"] boolValue];
    return isLpm; 
}


static NSOperatingSystemVersion _logos_method$_ungrouped$NSProcessInfo$operatingSystemVersion(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    
    NSDictionary *config = loadConfigJson();
    NSString *versionStr = config[@"osv"] ?: nil;

    
    NSOperatingSystemVersion original = _logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersion(self, _cmd);
    NSLog(@"[HOOK] NSProcessInfo operatingSystemVersion (original): %ld.%ld.%ld",
          (long)original.majorVersion,
          (long)original.minorVersion,
          (long)original.patchVersion);

    
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
    
    return original;
}


static NSString * _logos_method$_ungrouped$NSProcessInfo$operatingSystemVersionString(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *original = _logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersionString(self, _cmd);
    NSDictionary *config = loadConfigJson();
    NSString *fake = config[@"osv"];
    if (fake) {
        NSString *result = [NSString stringWithFormat:@"Version %@ (Build 21G82)", fake];
        NSLog(@"[HOOK] 替换 operatingSystemVersionString: %@", result);
        return result;
    }
    return original;
}




#pragma mark - UIScreen





















































static CGFloat _logos_method$_ungrouped$UIScreen$brightness(_LOGOS_SELF_TYPE_NORMAL UIScreen* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    CGFloat sbValue = _logos_orig$_ungrouped$UIScreen$brightness(self, _cmd);
    
    
    NSDictionary *config = loadConfigJson();
    NSNumber *configBrightness = config[@"brightness"];
    if ([configBrightness isKindOfClass:[NSNumber class]]) {
        CGFloat rawValue = configBrightness.floatValue;
        
        CGFloat rounded = round(rawValue * 100) / 100.0;
        
        sbValue = rounded;
    }
    return sbValue;
}



#pragma mark - Section


static NSString * _logos_meta_method$_ungrouped$GADOMIDDevice$deviceOsVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *config = loadConfigJson();
    NSString *fakeOSV = config[@"osv"];
    if (fakeOSV && [fakeOSV isKindOfClass:[NSString class]]) {
        NSLog(@"[HOOK] +[BNCSystemObserver osVersion] -> %@", fakeOSV);
        return fakeOSV;
    }
    return _logos_meta_orig$_ungrouped$GADOMIDDevice$deviceOsVersion(self, _cmd);
}





static NSString * _logos_meta_method$_ungrouped$USRVDevice$getOsVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *config = loadConfigJson();
    NSString *fakeOSV = config[@"osv"];
    if (fakeOSV && [fakeOSV isKindOfClass:[NSString class]]) {
        NSLog(@"[HOOK] +[BNCSystemObserver osVersion] -> %@", fakeOSV);
        return fakeOSV;
    }
    return _logos_meta_orig$_ungrouped$USRVDevice$getOsVersion(self, _cmd);
}



#pragma mark - GADDevice

static NSString * _logos_method$_ungrouped$GADDevice$systemVersion(_LOGOS_SELF_TYPE_NORMAL GADDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"[HOOK] GADDevice systemVersion (orig): %@", _logos_orig$_ungrouped$GADDevice$systemVersion(self, _cmd));
    return @"15.0.0"; 
}




static NSString * _logos_meta_method$_ungrouped$UADSMetricCommonTags$systemVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *original = _logos_meta_orig$_ungrouped$UADSMetricCommonTags$systemVersion(self, _cmd);
    NSLog(@"[HOOK] UADSMetricCommonTags systemVersion (class method): %@", original);
    return original;
}

static NSString * _logos_method$_ungrouped$UADSMetricCommonTags$systemVersion(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *original = _logos_orig$_ungrouped$UADSMetricCommonTags$systemVersion(self, _cmd);
    NSLog(@"[HOOK] UADSMetricCommonTags systemVersion (instance method): %@", original);
    return original;
}





static UADSMetricCommonTags* _logos_method$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$(_LOGOS_SELF_TYPE_INIT UADSMetricCommonTags* __unused self, SEL __unused _cmd, NSString * countryISO, NSString * platform, NSString * sdkVersion, NSString * systemVersion, BOOL testMode, NSDictionary * metricTags) _LOGOS_RETURN_RETAINED {

    NSLog(@"[HOOK] UADSMetricCommonTags initWithCountryISO:%@ platform:%@ sdkVersion:%@ systemVersion:%@ testMode:%d metricTags:%@",
          countryISO, platform, sdkVersion, systemVersion, testMode, metricTags);

    return _logos_orig$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$(self, _cmd, countryISO, platform, sdkVersion, systemVersion, testMode, metricTags);
}

static void _logos_method$_ungrouped$UADSMetricCommonTags$setSystemVersion$(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * systemVersion) {
    NSLog(@"[HOOK] UADSMetricCommonTags setSystemVersion: %@", systemVersion);
    _logos_orig$_ungrouped$UADSMetricCommonTags$setSystemVersion$(self, _cmd, systemVersion);
}













static NSString * _logos_method$_ungrouped$AFSDKChecksum$calculateV2ValueWithTimestamp$uid$systemVersion$firstLaunchDate$AFSDKVersion$isSimulator$isDevBuild$isJailBroken$isCounterValid$isDebuggerAttached$(_LOGOS_SELF_TYPE_NORMAL AFSDKChecksum* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * timestamp, NSString * uid, NSString * systemVersion, NSString * firstLaunchDate, NSString * AFSDKVersion, BOOL isSimulator, BOOL isDevBuild, BOOL isJailBroken, BOOL isCounterValid, BOOL isDebuggerAttached) {

    
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

    

    BOOL fakeJailBroken = NO;

    


    return _logos_orig$_ungrouped$AFSDKChecksum$calculateV2ValueWithTimestamp$uid$systemVersion$firstLaunchDate$AFSDKVersion$isSimulator$isDevBuild$isJailBroken$isCounterValid$isDebuggerAttached$(self, _cmd, timestamp, uid, systemVersion, firstLaunchDate, AFSDKVersion, isSimulator, isDevBuild, fakeJailBroken, isCounterValid, isDebuggerAttached);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$ASIdentifierManager = objc_getClass("ASIdentifierManager"); { MSHookMessageEx(_logos_class$_ungrouped$ASIdentifierManager, @selector(advertisingIdentifier), (IMP)&_logos_method$_ungrouped$ASIdentifierManager$advertisingIdentifier, (IMP*)&_logos_orig$_ungrouped$ASIdentifierManager$advertisingIdentifier);}Class _logos_class$_ungrouped$UIDevice = objc_getClass("UIDevice"); { MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(identifierForVendor), (IMP)&_logos_method$_ungrouped$UIDevice$identifierForVendor, (IMP*)&_logos_orig$_ungrouped$UIDevice$identifierForVendor);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(model), (IMP)&_logos_method$_ungrouped$UIDevice$model, (IMP*)&_logos_orig$_ungrouped$UIDevice$model);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(name), (IMP)&_logos_method$_ungrouped$UIDevice$name, (IMP*)&_logos_orig$_ungrouped$UIDevice$name);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(systemName), (IMP)&_logos_method$_ungrouped$UIDevice$systemName, (IMP*)&_logos_orig$_ungrouped$UIDevice$systemName);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(systemVersion), (IMP)&_logos_method$_ungrouped$UIDevice$systemVersion, (IMP*)&_logos_orig$_ungrouped$UIDevice$systemVersion);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(batteryLevel), (IMP)&_logos_method$_ungrouped$UIDevice$batteryLevel, (IMP*)&_logos_orig$_ungrouped$UIDevice$batteryLevel);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(batteryState), (IMP)&_logos_method$_ungrouped$UIDevice$batteryState, (IMP*)&_logos_orig$_ungrouped$UIDevice$batteryState);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(orientation), (IMP)&_logos_method$_ungrouped$UIDevice$orientation, (IMP*)&_logos_orig$_ungrouped$UIDevice$orientation);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(userInterfaceIdiom), (IMP)&_logos_method$_ungrouped$UIDevice$userInterfaceIdiom, (IMP*)&_logos_orig$_ungrouped$UIDevice$userInterfaceIdiom);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(serialNumber), (IMP)&_logos_method$_ungrouped$UIDevice$serialNumber, (IMP*)&_logos_orig$_ungrouped$UIDevice$serialNumber);}Class _logos_class$_ungrouped$NSJSONSerialization = objc_getClass("NSJSONSerialization"); Class _logos_metaclass$_ungrouped$NSJSONSerialization = object_getClass(_logos_class$_ungrouped$NSJSONSerialization); { MSHookMessageEx(_logos_metaclass$_ungrouped$NSJSONSerialization, @selector(dataWithJSONObject11:options:error:), (IMP)&_logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSJSONSerialization, @selector(dataWithJSONObject:options:error:), (IMP)&_logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSJSONSerialization, @selector(JSONObjectWithData:options:error:), (IMP)&_logos_meta_method$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$);}Class _logos_class$_ungrouped$WKWebView = objc_getClass("WKWebView"); { MSHookMessageEx(_logos_class$_ungrouped$WKWebView, @selector(loadRequest:), (IMP)&_logos_method$_ungrouped$WKWebView$loadRequest$, (IMP*)&_logos_orig$_ungrouped$WKWebView$loadRequest$);}{ MSHookMessageEx(_logos_class$_ungrouped$WKWebView, @selector(evaluateJavaScript:completionHandler:), (IMP)&_logos_method$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$, (IMP*)&_logos_orig$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$);}Class _logos_class$_ungrouped$NSBundle = objc_getClass("NSBundle"); { MSHookMessageEx(_logos_class$_ungrouped$NSBundle, @selector(infoDictionary), (IMP)&_logos_method$_ungrouped$NSBundle$infoDictionary, (IMP*)&_logos_orig$_ungrouped$NSBundle$infoDictionary);}Class _logos_class$_ungrouped$BugsnagDevice = objc_getClass("BugsnagDevice"); { MSHookMessageEx(_logos_class$_ungrouped$BugsnagDevice, @selector(jailbroken), (IMP)&_logos_method$_ungrouped$BugsnagDevice$jailbroken, (IMP*)&_logos_orig$_ungrouped$BugsnagDevice$jailbroken);}{ MSHookMessageEx(_logos_class$_ungrouped$BugsnagDevice, @selector(locale), (IMP)&_logos_method$_ungrouped$BugsnagDevice$locale, (IMP*)&_logos_orig$_ungrouped$BugsnagDevice$locale);}{ MSHookMessageEx(_logos_class$_ungrouped$BugsnagDevice, @selector(modelNumber), (IMP)&_logos_method$_ungrouped$BugsnagDevice$modelNumber, (IMP*)&_logos_orig$_ungrouped$BugsnagDevice$modelNumber);}{ MSHookMessageEx(_logos_class$_ungrouped$BugsnagDevice, @selector(setOsVersion:), (IMP)&_logos_method$_ungrouped$BugsnagDevice$setOsVersion$, (IMP*)&_logos_orig$_ungrouped$BugsnagDevice$setOsVersion$);}Class _logos_class$_ungrouped$AppsFlyerUtils = objc_getClass("AppsFlyerUtils"); Class _logos_metaclass$_ungrouped$AppsFlyerUtils = object_getClass(_logos_class$_ungrouped$AppsFlyerUtils); { MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(isJailbrokenWithSkipAdvancedJailbreakValidation:), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(isVPNConnected), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$isVPNConnected, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$isVPNConnected);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(getStoreReceipt), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$getStoreReceipt, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$getStoreReceipt);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(isValidDeeplink:), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$isValidDeeplink$, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$isValidDeeplink$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(isOneLinkValid:), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$isOneLinkValid$, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$isOneLinkValid$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(currentVersionMatchesPattern:version:), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$currentVersionMatchesPattern$version$, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$currentVersionMatchesPattern$version$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(shouldCachePurchaseEventWithStatusCode:), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$);}Class _logos_class$_ungrouped$CTCarrier = objc_getClass("CTCarrier"); { MSHookMessageEx(_logos_class$_ungrouped$CTCarrier, @selector(carrierName), (IMP)&_logos_method$_ungrouped$CTCarrier$carrierName, (IMP*)&_logos_orig$_ungrouped$CTCarrier$carrierName);}Class _logos_class$_ungrouped$NSProcessInfo = objc_getClass("NSProcessInfo"); { MSHookMessageEx(_logos_class$_ungrouped$NSProcessInfo, @selector(physicalMemory), (IMP)&_logos_method$_ungrouped$NSProcessInfo$physicalMemory, (IMP*)&_logos_orig$_ungrouped$NSProcessInfo$physicalMemory);}{ MSHookMessageEx(_logos_class$_ungrouped$NSProcessInfo, @selector(isLowPowerModeEnabled), (IMP)&_logos_method$_ungrouped$NSProcessInfo$isLowPowerModeEnabled, (IMP*)&_logos_orig$_ungrouped$NSProcessInfo$isLowPowerModeEnabled);}{ MSHookMessageEx(_logos_class$_ungrouped$NSProcessInfo, @selector(operatingSystemVersion), (IMP)&_logos_method$_ungrouped$NSProcessInfo$operatingSystemVersion, (IMP*)&_logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersion);}{ MSHookMessageEx(_logos_class$_ungrouped$NSProcessInfo, @selector(operatingSystemVersionString), (IMP)&_logos_method$_ungrouped$NSProcessInfo$operatingSystemVersionString, (IMP*)&_logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersionString);}Class _logos_class$_ungrouped$UIScreen = objc_getClass("UIScreen"); { MSHookMessageEx(_logos_class$_ungrouped$UIScreen, @selector(brightness), (IMP)&_logos_method$_ungrouped$UIScreen$brightness, (IMP*)&_logos_orig$_ungrouped$UIScreen$brightness);}Class _logos_class$_ungrouped$GADOMIDDevice = objc_getClass("GADOMIDDevice"); Class _logos_metaclass$_ungrouped$GADOMIDDevice = object_getClass(_logos_class$_ungrouped$GADOMIDDevice); { MSHookMessageEx(_logos_metaclass$_ungrouped$GADOMIDDevice, @selector(deviceOsVersion), (IMP)&_logos_meta_method$_ungrouped$GADOMIDDevice$deviceOsVersion, (IMP*)&_logos_meta_orig$_ungrouped$GADOMIDDevice$deviceOsVersion);}Class _logos_class$_ungrouped$USRVDevice = objc_getClass("USRVDevice"); Class _logos_metaclass$_ungrouped$USRVDevice = object_getClass(_logos_class$_ungrouped$USRVDevice); { MSHookMessageEx(_logos_metaclass$_ungrouped$USRVDevice, @selector(getOsVersion), (IMP)&_logos_meta_method$_ungrouped$USRVDevice$getOsVersion, (IMP*)&_logos_meta_orig$_ungrouped$USRVDevice$getOsVersion);}Class _logos_class$_ungrouped$GADDevice = objc_getClass("GADDevice"); { MSHookMessageEx(_logos_class$_ungrouped$GADDevice, @selector(systemVersion), (IMP)&_logos_method$_ungrouped$GADDevice$systemVersion, (IMP*)&_logos_orig$_ungrouped$GADDevice$systemVersion);}Class _logos_class$_ungrouped$UADSMetricCommonTags = objc_getClass("UADSMetricCommonTags"); Class _logos_metaclass$_ungrouped$UADSMetricCommonTags = object_getClass(_logos_class$_ungrouped$UADSMetricCommonTags); { MSHookMessageEx(_logos_metaclass$_ungrouped$UADSMetricCommonTags, @selector(systemVersion), (IMP)&_logos_meta_method$_ungrouped$UADSMetricCommonTags$systemVersion, (IMP*)&_logos_meta_orig$_ungrouped$UADSMetricCommonTags$systemVersion);}{ MSHookMessageEx(_logos_class$_ungrouped$UADSMetricCommonTags, @selector(systemVersion), (IMP)&_logos_method$_ungrouped$UADSMetricCommonTags$systemVersion, (IMP*)&_logos_orig$_ungrouped$UADSMetricCommonTags$systemVersion);}{ MSHookMessageEx(_logos_class$_ungrouped$UADSMetricCommonTags, @selector(initWithCountryISO:platform:sdkVersion:systemVersion:testMode:metricTags:), (IMP)&_logos_method$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$, (IMP*)&_logos_orig$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$);}{ MSHookMessageEx(_logos_class$_ungrouped$UADSMetricCommonTags, @selector(setSystemVersion:), (IMP)&_logos_method$_ungrouped$UADSMetricCommonTags$setSystemVersion$, (IMP*)&_logos_orig$_ungrouped$UADSMetricCommonTags$setSystemVersion$);}Class _logos_class$_ungrouped$AFSDKChecksum = objc_getClass("AFSDKChecksum"); { MSHookMessageEx(_logos_class$_ungrouped$AFSDKChecksum, @selector(calculateV2ValueWithTimestamp:uid:systemVersion:firstLaunchDate:AFSDKVersion:isSimulator:isDevBuild:isJailBroken:isCounterValid:isDebuggerAttached:), (IMP)&_logos_method$_ungrouped$AFSDKChecksum$calculateV2ValueWithTimestamp$uid$systemVersion$firstLaunchDate$AFSDKVersion$isSimulator$isDevBuild$isJailBroken$isCounterValid$isDebuggerAttached$, (IMP*)&_logos_orig$_ungrouped$AFSDKChecksum$calculateV2ValueWithTimestamp$uid$systemVersion$firstLaunchDate$AFSDKVersion$isSimulator$isDevBuild$isJailBroken$isCounterValid$isDebuggerAttached$);}} }
#line 1370 "/Users/zb/gitCode/tinder/tinderDylib/Logos/tinderDylib.xm"
