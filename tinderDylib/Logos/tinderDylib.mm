#line 1 "/Users/zb/GitHub/tinder/tinderDylib/Logos/tinderDylib.xm"


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "fishhook.h"  
#include <sys/sysctl.h>         
#import <WebKit/WebKit.h>

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

@class _TtC4Auth29GatedSMSCaptchaViewController; @class _TtC13TinderAuthSMS30EnterPhoneNumberViewController; @class NSProcessInfo; @class NSBundle; @class _TtC11CaptchaView21ArkoseMessageReceiver; @class NSFileManager; @class NSString; @class NSData; @class BNCDeviceInfo; @class FBSDKAppEventsDeviceInfo; @class OTDeviceInfo; @class ASIdentifierManager; @class USRVApiDeviceInfo; @class NSURLSession; @class AppsFlyerLib; @class GADDevice; @class CTCarrier; @class _TtC10TinderBase10DeviceInfo; @class UIScreen; @class UIDevice; @class UADSMetricCommonTags; @class AppsFlyerUtils; @class NSURL; @class USRVDevice; @class GADOMIDDevice; @class _TtC9TinderKit7TUIView; @class WKWebView; @class BugsnagDevice; @class NSJSONSerialization; 
static NSUUID * (*_logos_orig$_ungrouped$ASIdentifierManager$advertisingIdentifier)(_LOGOS_SELF_TYPE_NORMAL ASIdentifierManager* _LOGOS_SELF_CONST, SEL); static NSUUID * _logos_method$_ungrouped$ASIdentifierManager$advertisingIdentifier(_LOGOS_SELF_TYPE_NORMAL ASIdentifierManager* _LOGOS_SELF_CONST, SEL); static NSUUID * (*_logos_orig$_ungrouped$UIDevice$identifierForVendor)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSUUID * _logos_method$_ungrouped$UIDevice$identifierForVendor(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$model)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$model(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$name)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$name(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$systemName)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$systemName(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$systemVersion)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$systemVersion(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static float (*_logos_orig$_ungrouped$UIDevice$batteryLevel)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static float _logos_method$_ungrouped$UIDevice$batteryLevel(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIDeviceBatteryState (*_logos_orig$_ungrouped$UIDevice$batteryState)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIDeviceBatteryState _logos_method$_ungrouped$UIDevice$batteryState(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIDeviceOrientation (*_logos_orig$_ungrouped$UIDevice$orientation)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIDeviceOrientation _logos_method$_ungrouped$UIDevice$orientation(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIUserInterfaceIdiom (*_logos_orig$_ungrouped$UIDevice$userInterfaceIdiom)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static UIUserInterfaceIdiom _logos_method$_ungrouped$UIDevice$userInterfaceIdiom(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UIDevice$serialNumber)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UIDevice$serialNumber(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSData * (*_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static NSData * _logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static NSData * (*_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static NSData * _logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static id (*_logos_meta_orig$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSData *, NSJSONReadingOptions, NSError **); static id _logos_meta_method$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSData *, NSJSONReadingOptions, NSError **); static NSURL * (*_logos_meta_orig$_ungrouped$NSURL$URLWithString$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *); static NSURL * _logos_meta_method$_ungrouped$NSURL$URLWithString$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *); static NSURL * (*_logos_meta_orig$_ungrouped$NSURL$URLWithString$relativeToURL$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, NSURL *); static NSURL * _logos_meta_method$_ungrouped$NSURL$URLWithString$relativeToURL$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString *, NSURL *); static NSURLSessionDataTask * (*_logos_orig$_ungrouped$NSURLSession$dataTaskWithRequest$completionHandler$)(_LOGOS_SELF_TYPE_NORMAL NSURLSession* _LOGOS_SELF_CONST, SEL, NSURLRequest *, void (^)(NSData *data, NSURLResponse *response, NSError *error)); static NSURLSessionDataTask * _logos_method$_ungrouped$NSURLSession$dataTaskWithRequest$completionHandler$(_LOGOS_SELF_TYPE_NORMAL NSURLSession* _LOGOS_SELF_CONST, SEL, NSURLRequest *, void (^)(NSData *data, NSURLResponse *response, NSError *error)); static void (*_logos_orig$_ungrouped$WKWebView$loadRequest$)(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSURLRequest *); static void _logos_method$_ungrouped$WKWebView$loadRequest$(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSURLRequest *); static void (*_logos_orig$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$)(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSString *, void (^)(id result, NSError *error)); static void _logos_method$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSString *, void (^)(id result, NSError *error)); static NSDictionary * (*_logos_orig$_ungrouped$NSBundle$infoDictionary)(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); static NSDictionary * _logos_method$_ungrouped$NSBundle$infoDictionary(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); static NSURL * (*_logos_orig$_ungrouped$NSFileManager$containerURLForSecurityApplicationGroupIdentifier$)(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *); static NSURL * _logos_method$_ungrouped$NSFileManager$containerURLForSecurityApplicationGroupIdentifier$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST, SEL, NSString *); static BOOL (*_logos_orig$_ungrouped$NSData$writeToURL$atomically$)(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL _logos_method$_ungrouped$NSData$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL); static BOOL (*_logos_orig$_ungrouped$NSString$writeToURL$atomically$encoding$error$)(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL, NSStringEncoding, NSError **); static BOOL _logos_method$_ungrouped$NSString$writeToURL$atomically$encoding$error$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST, SEL, NSURL *, BOOL, NSStringEncoding, NSError **); static NSString * (*_logos_meta_orig$_ungrouped$NSString$stringWithContentsOfURL$encoding$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURL *, NSStringEncoding, NSError **); static NSString * _logos_meta_method$_ungrouped$NSString$stringWithContentsOfURL$encoding$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSURL *, NSStringEncoding, NSError **); static int (*_logos_orig$_ungrouped$BugsnagDevice$jailbroken)(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$BugsnagDevice$jailbroken(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$BugsnagDevice$locale)(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$BugsnagDevice$locale(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$BugsnagDevice$modelNumber)(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$BugsnagDevice$modelNumber(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$BugsnagDevice$setOsVersion$)(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL, NSString *); static void _logos_method$_ungrouped$BugsnagDevice$setOsVersion$(_LOGOS_SELF_TYPE_NORMAL BugsnagDevice* _LOGOS_SELF_CONST, SEL, NSString *); static int (*_logos_orig$_ungrouped$AppsFlyerLib$skipAdvancedJailbreakValidation)(_LOGOS_SELF_TYPE_NORMAL AppsFlyerLib* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$AppsFlyerLib$skipAdvancedJailbreakValidation(_LOGOS_SELF_TYPE_NORMAL AppsFlyerLib* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$AppsFlyerLib$setSkipAdvancedJailbreakValidation$)(_LOGOS_SELF_TYPE_NORMAL AppsFlyerLib* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$AppsFlyerLib$setSkipAdvancedJailbreakValidation$(_LOGOS_SELF_TYPE_NORMAL AppsFlyerLib* _LOGOS_SELF_CONST, SEL, BOOL); static int (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$isVPNConnected)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isVPNConnected(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static int (*_logos_meta_orig$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static NSString * (*_logos_orig$_ungrouped$CTCarrier$carrierName)(_LOGOS_SELF_TYPE_NORMAL CTCarrier* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$CTCarrier$carrierName(_LOGOS_SELF_TYPE_NORMAL CTCarrier* _LOGOS_SELF_CONST, SEL); static unsigned long long (*_logos_orig$_ungrouped$NSProcessInfo$physicalMemory)(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static unsigned long long _logos_method$_ungrouped$NSProcessInfo$physicalMemory(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static BOOL (*_logos_orig$_ungrouped$NSProcessInfo$isLowPowerModeEnabled)(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$NSProcessInfo$isLowPowerModeEnabled(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static NSOperatingSystemVersion (*_logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersion)(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static NSOperatingSystemVersion _logos_method$_ungrouped$NSProcessInfo$operatingSystemVersion(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersionString)(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$NSProcessInfo$operatingSystemVersionString(_LOGOS_SELF_TYPE_NORMAL NSProcessInfo* _LOGOS_SELF_CONST, SEL); static CGFloat (*_logos_orig$_ungrouped$UIScreen$brightness)(_LOGOS_SELF_TYPE_NORMAL UIScreen* _LOGOS_SELF_CONST, SEL); static CGFloat _logos_method$_ungrouped$UIScreen$brightness(_LOGOS_SELF_TYPE_NORMAL UIScreen* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$GADOMIDDevice$deviceOsVersion)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$GADOMIDDevice$deviceOsVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$USRVDevice$getOsVersion)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$USRVDevice$getOsVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$GADDevice$systemVersion)(_LOGOS_SELF_TYPE_NORMAL GADDevice* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$GADDevice$systemVersion(_LOGOS_SELF_TYPE_NORMAL GADDevice* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$UADSMetricCommonTags$systemVersion)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$UADSMetricCommonTags$systemVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$UADSMetricCommonTags$systemVersion)(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$UADSMetricCommonTags$systemVersion(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST, SEL); static UADSMetricCommonTags* (*_logos_orig$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$)(_LOGOS_SELF_TYPE_INIT UADSMetricCommonTags*, SEL, NSString *, NSString *, NSString *, NSString *, BOOL, NSDictionary *) _LOGOS_RETURN_RETAINED; static UADSMetricCommonTags* _logos_method$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$(_LOGOS_SELF_TYPE_INIT UADSMetricCommonTags*, SEL, NSString *, NSString *, NSString *, NSString *, BOOL, NSDictionary *) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$_ungrouped$UADSMetricCommonTags$setSystemVersion$)(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST, SEL, NSString *); static void _logos_method$_ungrouped$UADSMetricCommonTags$setSystemVersion$(_LOGOS_SELF_TYPE_NORMAL UADSMetricCommonTags* _LOGOS_SELF_CONST, SEL, NSString *); static void (*_logos_orig$_ungrouped$_TtC9TinderKit7TUIView$traitCollectionDidChange$)(_LOGOS_SELF_TYPE_NORMAL _TtC9TinderKit7TUIView* _LOGOS_SELF_CONST, SEL, UITraitCollection *); static void _logos_method$_ungrouped$_TtC9TinderKit7TUIView$traitCollectionDidChange$(_LOGOS_SELF_TYPE_NORMAL _TtC9TinderKit7TUIView* _LOGOS_SELF_CONST, SEL, UITraitCollection *); static int (*_logos_orig$_ungrouped$_TtC13TinderAuthSMS30EnterPhoneNumberViewController$overrideChildrenContentSizeCategories)(_LOGOS_SELF_TYPE_NORMAL _TtC13TinderAuthSMS30EnterPhoneNumberViewController* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$_TtC13TinderAuthSMS30EnterPhoneNumberViewController$overrideChildrenContentSizeCategories(_LOGOS_SELF_TYPE_NORMAL _TtC13TinderAuthSMS30EnterPhoneNumberViewController* _LOGOS_SELF_CONST, SEL); static int (*_logos_orig$_ungrouped$_TtC4Auth29GatedSMSCaptchaViewController$viewControllerNavigationKey)(_LOGOS_SELF_TYPE_NORMAL _TtC4Auth29GatedSMSCaptchaViewController* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$_TtC4Auth29GatedSMSCaptchaViewController$viewControllerNavigationKey(_LOGOS_SELF_TYPE_NORMAL _TtC4Auth29GatedSMSCaptchaViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$loadRequest$)(_LOGOS_SELF_TYPE_NORMAL _TtC11CaptchaView21ArkoseMessageReceiver* _LOGOS_SELF_CONST, SEL, NSURLRequest *); static void _logos_method$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$loadRequest$(_LOGOS_SELF_TYPE_NORMAL _TtC11CaptchaView21ArkoseMessageReceiver* _LOGOS_SELF_CONST, SEL, NSURLRequest *); static void (*_logos_orig$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$evaluateJavaScript$completionHandler$)(_LOGOS_SELF_TYPE_NORMAL _TtC11CaptchaView21ArkoseMessageReceiver* _LOGOS_SELF_CONST, SEL, NSString *, void (^)(id result, NSError *error)); static void _logos_method$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$evaluateJavaScript$completionHandler$(_LOGOS_SELF_TYPE_NORMAL _TtC11CaptchaView21ArkoseMessageReceiver* _LOGOS_SELF_CONST, SEL, NSString *, void (^)(id result, NSError *error)); static void (*_logos_orig$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$userContentController$didReceiveScriptMessage$)(_LOGOS_SELF_TYPE_NORMAL _TtC11CaptchaView21ArkoseMessageReceiver* _LOGOS_SELF_CONST, SEL, WKUserContentController *, WKScriptMessage *); static void _logos_method$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$userContentController$didReceiveScriptMessage$(_LOGOS_SELF_TYPE_NORMAL _TtC11CaptchaView21ArkoseMessageReceiver* _LOGOS_SELF_CONST, SEL, WKUserContentController *, WKScriptMessage *); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCurrentUITheme$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCurrentUITheme$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLocaleList$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLocaleList$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemBootTime$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemBootTime$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceName$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceName$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getVendorIdentifier$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getVendorIdentifier$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getElapsedRealtime$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getElapsedRealtime$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUptime$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUptime$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCPUCount$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCPUCount$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_unregisterVolumeChangeListener$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_unregisterVolumeChangeListener$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_registerVolumeChangeListener$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_registerVolumeChangeListener$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceMaxVolume$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceMaxVolume$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getGLVersion$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getGLVersion$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isStatusBarHidden$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isStatusBarHidden$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarHeight$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarHeight$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarWidth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarWidth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getProcessInfo$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getProcessInfo$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSensorList$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSensorList$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientations$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientations$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdNetworkIdsPlist$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdNetworkIdsPlist$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientationsPlist$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientationsPlist$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isSimulator$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isSimulator$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUserInterfaceIdiom$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUserInterfaceIdiom$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUniqueEventId$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUniqueEventId$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isRooted$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isRooted$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalMemory$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalMemory$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeMemory$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeMemory$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryStatus$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryStatus$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryLevel$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryLevel$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalSpace$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalSpace$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeSpace$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeSpace$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenBrightness$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenBrightness$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceVolume$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceVolume$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemLanguage$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemLanguage$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZoneOffset$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZoneOffset$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZone$callback$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZone$callback$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getHeadset$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getHeadset$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkCountryISO$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkCountryISO$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperatorName$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperatorName$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_checkIsMuted$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_checkIsMuted$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperator$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperator$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenHeight$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenHeight$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenWidth$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenWidth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenScale$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenScale$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkType$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkType$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getConnectionType$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getConnectionType$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getModel$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getModel$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getOsVersion$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getOsVersion$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLimitAdTrackingFlag$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLimitAdTrackingFlag$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdvertisingTrackingId$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdvertisingTrackingId$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static int (*_logos_orig$_ungrouped$BNCDeviceInfo$loadDeviceInfo)(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$BNCDeviceInfo$loadDeviceInfo(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$BNCDeviceInfo$setCountry$)(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$BNCDeviceInfo$setCountry$(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST, SEL, id); static NSString * (*_logos_orig$_ungrouped$BNCDeviceInfo$localIPAddress)(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$BNCDeviceInfo$localIPAddress(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_orig$_ungrouped$BNCDeviceInfo$userAgentString)(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$BNCDeviceInfo$userAgentString(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$FBSDKAppEventsDeviceInfo$setSysVersion$)(_LOGOS_SELF_TYPE_NORMAL FBSDKAppEventsDeviceInfo* _LOGOS_SELF_CONST, SEL, int); static void _logos_method$_ungrouped$FBSDKAppEventsDeviceInfo$setSysVersion$(_LOGOS_SELF_TYPE_NORMAL FBSDKAppEventsDeviceInfo* _LOGOS_SELF_CONST, SEL, int); static NSString * (*_logos_orig$_ungrouped$FBSDKAppEventsDeviceInfo$sysVersion)(_LOGOS_SELF_TYPE_NORMAL FBSDKAppEventsDeviceInfo* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$FBSDKAppEventsDeviceInfo$sysVersion(_LOGOS_SELF_TYPE_NORMAL FBSDKAppEventsDeviceInfo* _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$OTDeviceInfo$systemName)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$systemName(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$OTDeviceInfo$systemVersion)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$systemVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$OTDeviceInfo$libOpentokVersion)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$libOpentokVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$OTDeviceInfo$libOpentokSHA1)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$libOpentokSHA1(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$OTDeviceInfo$machineName)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$machineName(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$OTDeviceInfo$deviceUUID)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$deviceUUID(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * (*_logos_meta_orig$_ungrouped$OTDeviceInfo$userAgent)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$userAgent(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static _TtC10TinderBase10DeviceInfo* (*_logos_orig$_ungrouped$_TtC10TinderBase10DeviceInfo$init)(_LOGOS_SELF_TYPE_INIT _TtC10TinderBase10DeviceInfo*, SEL) _LOGOS_RETURN_RETAINED; static _TtC10TinderBase10DeviceInfo* _logos_method$_ungrouped$_TtC10TinderBase10DeviceInfo$init(_LOGOS_SELF_TYPE_INIT _TtC10TinderBase10DeviceInfo*, SEL) _LOGOS_RETURN_RETAINED; 

#line 32 "/Users/zb/GitHub/tinder/tinderDylib/Logos/tinderDylib.xm"
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
    
    NSLog(@"[Hook] NSJSONSerialization +dataWithJSONObject called with obj: %@", obj);
    
    
    NSArray<NSString *> *callStack = [NSThread callStackSymbols];
    NSLog(@"Call Stack:\n%@", [callStack componentsJoinedByString:@"\n"]);
    
    
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
        NSLog(@"[Hook] 修改后的 JSON708000：%@", mutableJSON);
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




#pragma mark - NSURL


static NSURL * _logos_meta_method$_ungrouped$NSURL$URLWithString$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * URLString) {
    NSLog(@"[HOOK] URLWithString (单参数): %@", URLString);
    


    NSURL *result = _logos_meta_orig$_ungrouped$NSURL$URLWithString$(self, _cmd, URLString);
    NSLog(@"[HOOK] 返回 NSURL (单参数): %@", result);
    return result;
}

static NSURL * _logos_meta_method$_ungrouped$NSURL$URLWithString$relativeToURL$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * URLString, NSURL * baseURL) {
    NSLog(@"[HOOK] URLWithString: %@ relativeToURL: %@", URLString, baseURL);

    


    
    NSURL *result = _logos_meta_orig$_ungrouped$NSURL$URLWithString$relativeToURL$(self, _cmd, URLString, baseURL);

    
    NSLog(@"[HOOK] 返回 NSURL: %@", result);
    return result;
}




#pragma mark - NSURLSession




















































static NSURLSessionDataTask * _logos_method$_ungrouped$NSURLSession$dataTaskWithRequest$completionHandler$(_LOGOS_SELF_TYPE_NORMAL NSURLSession* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURLRequest * request, void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error)){
    NSString *url = request.URL.absoluteString;
    NSLog(@"Intercepted Request: %@", url);

    __block NSString *requestBody = nil;
    if (request.HTTPBody) {
        requestBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        NSLog(@"[Legos] Request Body: %@", requestBody);
    }

    void (^customCompletion)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"[Legos] 请求：%@\n入参：%@\n出参：%@", url, requestBody, responseBody);

        NSDictionary *fakeResponse = nil;
        if ([url containsString:@"/v2/device-check/ios"]) {
            fakeResponse = @{
                @"data": @{ @"action": @1, @"result": @{ @"action": @1 } },
                @"meta": @{ @"status": @200 }
            };
        } else if ([url containsString:@"/v2/insendio/templates/active"]) {
            fakeResponse = @{
                @"data": @{ @"templates": @[] },
                @"meta": @{ @"status": @200 }
            };
        }

        if (fakeResponse) {
            NSData *fakeData = [NSJSONSerialization dataWithJSONObject:fakeResponse options:0 error:nil];
            NSHTTPURLResponse *fakeResp = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{@"Content-Type": @"application/json"}];
            NSLog(@"[Legos] 使用自定义响应覆盖 %@", url);
            completionHandler(fakeData, fakeResp, nil);
            return;
        }
        
        completionHandler(data, response, error);
    };
    return _logos_orig$_ungrouped$NSURLSession$dataTaskWithRequest$completionHandler$(self, _cmd, request, customCompletion);
}



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

NSString *fake_NSStringFromClass(Class cls) {
    NSString *className = NSStringFromClass(cls);
    if ([className isEqualToString:@"FloatingExtendVC"]) {
        return @"UIViewController";
    }
    return className;
}



#pragma mark - NSLocale

































#pragma mark - NSTimeZone













































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














































































































































































































static NSURL * _logos_method$_ungrouped$NSFileManager$containerURLForSecurityApplicationGroupIdentifier$(_LOGOS_SELF_TYPE_NORMAL NSFileManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * groupIdentifier) {
    NSURL *url = _logos_orig$_ungrouped$NSFileManager$containerURLForSecurityApplicationGroupIdentifier$(self, _cmd, groupIdentifier);
    NSLog(@"[HOOK] containerURLForSecurityApplicationGroupIdentifier: %@ => %@", groupIdentifier, url);
    return url;
}




static BOOL _logos_method$_ungrouped$NSData$writeToURL$atomically$(_LOGOS_SELF_TYPE_NORMAL NSData* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, BOOL useAuxiliaryFile) {
    if ([url.absoluteString containsString:@"group."]) {
        NSLog(@"[HOOK] NSData writeToURL in AppGroup: %@ (length: %lu)", url, (unsigned long)self.length);
        
    }
    return _logos_orig$_ungrouped$NSData$writeToURL$atomically$(self, _cmd, url, useAuxiliaryFile);
}




static BOOL _logos_method$_ungrouped$NSString$writeToURL$atomically$encoding$error$(_LOGOS_SELF_TYPE_NORMAL NSString* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, BOOL useAuxiliaryFile, NSStringEncoding enc, NSError ** error) {
    if ([url.absoluteString containsString:@"group."]) {
        NSLog(@"[HOOK] NSString writeToURL in AppGroup: %@\n内容: %@", url, self);
    }
    return _logos_orig$_ungrouped$NSString$writeToURL$atomically$encoding$error$(self, _cmd, url, useAuxiliaryFile, enc, error);
}
static NSString * _logos_meta_method$_ungrouped$NSString$stringWithContentsOfURL$encoding$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURL * url, NSStringEncoding enc, NSError ** error) {
    NSString *str = _logos_meta_orig$_ungrouped$NSString$stringWithContentsOfURL$encoding$error$(self, _cmd, url, enc, error);
    if ([url.absoluteString containsString:@"group."]) {
        NSLog(@"[HOOK] Read from AppGroup file: %@\n内容: %@", url, str);
    }
    return str;
}



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










static int _logos_method$_ungrouped$AppsFlyerLib$skipAdvancedJailbreakValidation(_LOGOS_SELF_TYPE_NORMAL AppsFlyerLib* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    int jailbroken = _logos_orig$_ungrouped$AppsFlyerLib$skipAdvancedJailbreakValidation(self, _cmd);
    NSLog(@"[Hook]skipAdvancedJailbreakValidation: %d", jailbroken);
    return 0;
}

static void _logos_method$_ungrouped$AppsFlyerLib$setSkipAdvancedJailbreakValidation$(_LOGOS_SELF_TYPE_NORMAL AppsFlyerLib* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL skip) {
    NSLog(@"[HOOK] AppsFlyerLib setSkipAdvancedJailbreakValidation: %d", skip);

    
    _logos_orig$_ungrouped$AppsFlyerLib$setSkipAdvancedJailbreakValidation$(self, _cmd, YES);
}




static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int skipAdvanced) {
    NSLog(@"[Hook] AppsFlyerUtils isJailbrokenWithSkipAdvancedJailbreakValidation: %d", skipAdvanced);
    return 0; 
}

static int _logos_meta_method$_ungrouped$AppsFlyerUtils$isVPNConnected(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"[Hook] AppsFlyerUtils isVPNConnected %d", _logos_meta_orig$_ungrouped$AppsFlyerUtils$isVPNConnected(self, _cmd));
    return 0; 
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




































































static void _logos_method$_ungrouped$_TtC9TinderKit7TUIView$traitCollectionDidChange$(_LOGOS_SELF_TYPE_NORMAL _TtC9TinderKit7TUIView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITraitCollection * previousTraitCollection) {
    NSLog(@"[TinderKit] TraitCollectionDidChange called! Previous: %@", previousTraitCollection);
    
    _logos_orig$_ungrouped$_TtC9TinderKit7TUIView$traitCollectionDidChange$(self, _cmd, previousTraitCollection);
}






static int _logos_method$_ungrouped$_TtC13TinderAuthSMS30EnterPhoneNumberViewController$overrideChildrenContentSizeCategories(_LOGOS_SELF_TYPE_NORMAL _TtC13TinderAuthSMS30EnterPhoneNumberViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSLog(@"[TinderKit] overrideChildrenContentSizeCategories: %@", _logos_orig$_ungrouped$_TtC13TinderAuthSMS30EnterPhoneNumberViewController$overrideChildrenContentSizeCategories(self, _cmd));
    return _logos_orig$_ungrouped$_TtC13TinderAuthSMS30EnterPhoneNumberViewController$overrideChildrenContentSizeCategories(self, _cmd);
}





static int _logos_method$_ungrouped$_TtC4Auth29GatedSMSCaptchaViewController$viewControllerNavigationKey(_LOGOS_SELF_TYPE_NORMAL _TtC4Auth29GatedSMSCaptchaViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSLog(@"[TinderKit] overrideChildrenContentSizeCategories: %@", _logos_orig$_ungrouped$_TtC4Auth29GatedSMSCaptchaViewController$viewControllerNavigationKey(self, _cmd));
    return _logos_orig$_ungrouped$_TtC4Auth29GatedSMSCaptchaViewController$viewControllerNavigationKey(self, _cmd);
}



static void _logos_method$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$loadRequest$(_LOGOS_SELF_TYPE_NORMAL _TtC11CaptchaView21ArkoseMessageReceiver* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSURLRequest * request) {
    NSLog(@"📦 TtC11Captcha 请求：%@", request.URL.absoluteString);
    return _logos_orig$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$loadRequest$(self, _cmd, request);
}
static void _logos_method$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$evaluateJavaScript$completionHandler$(_LOGOS_SELF_TYPE_NORMAL _TtC11CaptchaView21ArkoseMessageReceiver* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * javaScriptString, void (^completionHandler)(id result, NSError *error)) {
    NSLog(@"📡 [TtC11Captcha] evaluateJavaScript called:\n%@", javaScriptString);

    
    
    if ([javaScriptString containsString:@"submit"]) {
        NSLog(@"🚨 TtC11Captcha可能是提交表单相关 JS");
    }
    
    _logos_orig$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$evaluateJavaScript$completionHandler$(self, _cmd, javaScriptString, completionHandler);
}
static void _logos_method$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$userContentController$didReceiveScriptMessage$(_LOGOS_SELF_TYPE_NORMAL _TtC11CaptchaView21ArkoseMessageReceiver* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, WKUserContentController * userContentController, WKScriptMessage * message) {
    NSLog(@"💡 Hook 成功: JS 发送消息 = %@", message.body);
    
    if ([message.body isKindOfClass:[NSString class]] && [message.body isEqualToString:@"verifySuccess"]) {
        NSLog(@"✅ Arkose 验证通过");
        
    }
    _logos_orig$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$userContentController$didReceiveScriptMessage$(self, _cmd, userContentController, message); 
}













































































static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCurrentUITheme$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getCurrentUITheme called with arg: %d", arg2);
    
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCurrentUITheme$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
    
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLocaleList$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getLocaleList called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLocaleList$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemBootTime$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSystemBootTime called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemBootTime$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceName$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getDeviceName called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceName$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getVendorIdentifier$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getVendorIdentifier called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getVendorIdentifier$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getElapsedRealtime$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getElapsedRealtime called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getElapsedRealtime$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUptime$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getUptime called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUptime$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCPUCount$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getCPUCount called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCPUCount$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_unregisterVolumeChangeListener$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_unregisterVolumeChangeListener called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_unregisterVolumeChangeListener$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_registerVolumeChangeListener$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_registerVolumeChangeListener called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_registerVolumeChangeListener$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceMaxVolume$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getDeviceMaxVolume called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceMaxVolume$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getGLVersion$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getGLVersion called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getGLVersion$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isStatusBarHidden$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_isStatusBarHidden called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isStatusBarHidden$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarHeight$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getStatusBarHeight called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarHeight$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarWidth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getStatusBarWidth called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarWidth$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getProcessInfo$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getProcessInfo called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getProcessInfo$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSensorList$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSensorList called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSensorList$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientations$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSupportedOrientations called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientations$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdNetworkIdsPlist$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getAdNetworkIdsPlist called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdNetworkIdsPlist$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientationsPlist$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSupportedOrientationsPlist called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientationsPlist$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isSimulator$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_isSimulator called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isSimulator$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUserInterfaceIdiom$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getUserInterfaceIdiom called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUserInterfaceIdiom$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUniqueEventId$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getUniqueEventId called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUniqueEventId$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isRooted$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_isRooted called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isRooted$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalMemory$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getTotalMemory called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalMemory$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeMemory$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getFreeMemory called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeMemory$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryStatus$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getBatteryStatus called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryStatus$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryLevel$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getBatteryLevel called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryLevel$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalSpace$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getTotalSpace called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalSpace$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeSpace$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getFreeSpace called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeSpace$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenBrightness$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getScreenBrightness called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenBrightness$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceVolume$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getDeviceVolume called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceVolume$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemLanguage$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getSystemLanguage called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemLanguage$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZoneOffset$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getTimeZoneOffset called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZoneOffset$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZone$callback$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2, int arg3) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getTimeZone called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZone$callback$(self, _cmd, arg2, arg3);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getHeadset$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getHeadset called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getHeadset$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkCountryISO$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getNetworkCountryISO called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkCountryISO$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperatorName$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getNetworkOperatorName called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperatorName$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_checkIsMuted$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_checkIsMuted called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_checkIsMuted$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperator$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getNetworkOperator called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperator$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenHeight$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getScreenHeight called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenHeight$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenWidth$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getScreenWidth called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenWidth$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenScale$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getScreenScale called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenScale$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkType$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getNetworkType called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkType$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getConnectionType$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getConnectionType called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getConnectionType$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getModel$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getModel called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getModel$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getOsVersion$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getOsVersion called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getOsVersion$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLimitAdTrackingFlag$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getLimitAdTrackingFlag called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLimitAdTrackingFlag$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}
static int _logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdvertisingTrackingId$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int arg2) {
    NSLog(@"[HOOK] USRVApiDeviceInfo WebViewExposed_getAdvertisingTrackingId called with arg: %d", arg2);
    int original = _logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdvertisingTrackingId$(self, _cmd, arg2);
    NSLog(@"[HOOK] Original UITheme: %d", original);
    return original;
}







static int _logos_method$_ungrouped$BNCDeviceInfo$loadDeviceInfo(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"[HOOK] BNCDeviceInfo -loadDeviceInfo called");

    
    

    int result = _logos_orig$_ungrouped$BNCDeviceInfo$loadDeviceInfo(self, _cmd);

    
    NSLog(@"[HOOK] BNCDeviceInfo -loadDeviceInfo returned %d", result);
    return result;
}

static void _logos_method$_ungrouped$BNCDeviceInfo$setCountry$(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id value){
    NSLog(@"[Hook] setCountry called with value: %@", value);
    _logos_orig$_ungrouped$BNCDeviceInfo$setCountry$(self, _cmd, value);
}

static NSString * _logos_method$_ungrouped$BNCDeviceInfo$localIPAddress(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *realIP = _logos_orig$_ungrouped$BNCDeviceInfo$localIPAddress(self, _cmd);
    NSLog(@"[BNCDeviceInfo] 当前本地 IP 地址: %@", realIP);
    return realIP;
}





static NSString * _logos_method$_ungrouped$BNCDeviceInfo$userAgentString(_LOGOS_SELF_TYPE_NORMAL BNCDeviceInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *ua = _logos_orig$_ungrouped$BNCDeviceInfo$userAgentString(self, _cmd);
    NSLog(@"[BNCDeviceInfo] Original User-Agent: %@", ua);

    NSDictionary *config = loadConfigJson(); 
    NSString *customOSV = config[@"osv"]; 

    if (customOSV && [customOSV isKindOfClass:[NSString class]] && customOSV.length > 0) {
        NSString *convertedOSV = [customOSV stringByReplacingOccurrencesOfString:@"." withString:@"_"]; 

        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"iPhone OS \\d+_\\d+(?:_\\d+)?" options:0 error:nil];
        ua = [regex stringByReplacingMatchesInString:ua options:0 range:NSMakeRange(0, ua.length) withTemplate:[NSString stringWithFormat:@"iPhone OS %@", convertedOSV]];
        NSLog(@"[BNCDeviceInfo] Patched User-Agent: %@", ua);
    }
    return ua;
}





static void _logos_method$_ungrouped$FBSDKAppEventsDeviceInfo$setSysVersion$(_LOGOS_SELF_TYPE_NORMAL FBSDKAppEventsDeviceInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int value) {
    NSLog(@"[Hook] setSysVersion called with value: %d", value);
    _logos_orig$_ungrouped$FBSDKAppEventsDeviceInfo$setSysVersion$(self, _cmd, value); 
}
static NSString * _logos_method$_ungrouped$FBSDKAppEventsDeviceInfo$sysVersion(_LOGOS_SELF_TYPE_NORMAL FBSDKAppEventsDeviceInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *orig = _logos_orig$_ungrouped$FBSDKAppEventsDeviceInfo$sysVersion(self, _cmd);
    NSLog(@"[Hook] sysVersion: %@", orig);
    return orig; 
}











static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$systemName(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *orig = _logos_meta_orig$_ungrouped$OTDeviceInfo$systemName(self, _cmd);
    NSLog(@"[Hook] +[OTDeviceInfo systemName] original: %@", orig);
    return orig; 
}
static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$systemVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *orig = _logos_meta_orig$_ungrouped$OTDeviceInfo$systemVersion(self, _cmd);
    NSLog(@"[Hook] +[OTDeviceInfo systemVersion] original: %@", orig);
    return orig; 
}
static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$libOpentokVersion(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSString *orig = _logos_meta_orig$_ungrouped$OTDeviceInfo$libOpentokVersion(self, _cmd);
    NSLog(@"[Hook] libOpentokVersion original: %@", orig);
    return orig;
}
static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$libOpentokSHA1(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *orig = _logos_meta_orig$_ungrouped$OTDeviceInfo$libOpentokSHA1(self, _cmd);
    NSLog(@"[Hook] libOpentokSHA1 original: %@", orig);
    return orig; 
}
static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$machineName(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *orig = _logos_meta_orig$_ungrouped$OTDeviceInfo$machineName(self, _cmd);
    NSLog(@"[Hook] machineName original: %@", orig);
    return orig;
}
static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$deviceUUID(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *orig = _logos_meta_orig$_ungrouped$OTDeviceInfo$deviceUUID(self, _cmd);
    NSLog(@"[Hook] deviceUUID original: %@", orig);
    return orig;
}
static NSString * _logos_meta_method$_ungrouped$OTDeviceInfo$userAgent(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *orig = _logos_meta_orig$_ungrouped$OTDeviceInfo$userAgent(self, _cmd);
    NSLog(@"[Hook] userAgent original: %@", orig);
    return orig;
}





static _TtC10TinderBase10DeviceInfo* _logos_method$_ungrouped$_TtC10TinderBase10DeviceInfo$init(_LOGOS_SELF_TYPE_INIT _TtC10TinderBase10DeviceInfo* __unused self, SEL __unused _cmd) _LOGOS_RETURN_RETAINED {
    NSLog(@"-[<_TtC10TinderBase10DeviceInfo: %p> init]", self);  
    NSLog(@"[HOOK] DeviceInfo init called");

    
    id orig = _logos_orig$_ungrouped$_TtC10TinderBase10DeviceInfo$init(self, _cmd);

    
    

    return orig;
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$ASIdentifierManager = objc_getClass("ASIdentifierManager"); { MSHookMessageEx(_logos_class$_ungrouped$ASIdentifierManager, @selector(advertisingIdentifier), (IMP)&_logos_method$_ungrouped$ASIdentifierManager$advertisingIdentifier, (IMP*)&_logos_orig$_ungrouped$ASIdentifierManager$advertisingIdentifier);}Class _logos_class$_ungrouped$UIDevice = objc_getClass("UIDevice"); { MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(identifierForVendor), (IMP)&_logos_method$_ungrouped$UIDevice$identifierForVendor, (IMP*)&_logos_orig$_ungrouped$UIDevice$identifierForVendor);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(model), (IMP)&_logos_method$_ungrouped$UIDevice$model, (IMP*)&_logos_orig$_ungrouped$UIDevice$model);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(name), (IMP)&_logos_method$_ungrouped$UIDevice$name, (IMP*)&_logos_orig$_ungrouped$UIDevice$name);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(systemName), (IMP)&_logos_method$_ungrouped$UIDevice$systemName, (IMP*)&_logos_orig$_ungrouped$UIDevice$systemName);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(systemVersion), (IMP)&_logos_method$_ungrouped$UIDevice$systemVersion, (IMP*)&_logos_orig$_ungrouped$UIDevice$systemVersion);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(batteryLevel), (IMP)&_logos_method$_ungrouped$UIDevice$batteryLevel, (IMP*)&_logos_orig$_ungrouped$UIDevice$batteryLevel);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(batteryState), (IMP)&_logos_method$_ungrouped$UIDevice$batteryState, (IMP*)&_logos_orig$_ungrouped$UIDevice$batteryState);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(orientation), (IMP)&_logos_method$_ungrouped$UIDevice$orientation, (IMP*)&_logos_orig$_ungrouped$UIDevice$orientation);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(userInterfaceIdiom), (IMP)&_logos_method$_ungrouped$UIDevice$userInterfaceIdiom, (IMP*)&_logos_orig$_ungrouped$UIDevice$userInterfaceIdiom);}{ MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(serialNumber), (IMP)&_logos_method$_ungrouped$UIDevice$serialNumber, (IMP*)&_logos_orig$_ungrouped$UIDevice$serialNumber);}Class _logos_class$_ungrouped$NSJSONSerialization = objc_getClass("NSJSONSerialization"); Class _logos_metaclass$_ungrouped$NSJSONSerialization = object_getClass(_logos_class$_ungrouped$NSJSONSerialization); { MSHookMessageEx(_logos_metaclass$_ungrouped$NSJSONSerialization, @selector(dataWithJSONObject11:options:error:), (IMP)&_logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject11$options$error$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSJSONSerialization, @selector(dataWithJSONObject:options:error:), (IMP)&_logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSJSONSerialization, @selector(JSONObjectWithData:options:error:), (IMP)&_logos_meta_method$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$);}Class _logos_class$_ungrouped$NSURL = objc_getClass("NSURL"); Class _logos_metaclass$_ungrouped$NSURL = object_getClass(_logos_class$_ungrouped$NSURL); { MSHookMessageEx(_logos_metaclass$_ungrouped$NSURL, @selector(URLWithString:), (IMP)&_logos_meta_method$_ungrouped$NSURL$URLWithString$, (IMP*)&_logos_meta_orig$_ungrouped$NSURL$URLWithString$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSURL, @selector(URLWithString:relativeToURL:), (IMP)&_logos_meta_method$_ungrouped$NSURL$URLWithString$relativeToURL$, (IMP*)&_logos_meta_orig$_ungrouped$NSURL$URLWithString$relativeToURL$);}Class _logos_class$_ungrouped$NSURLSession = objc_getClass("NSURLSession"); { MSHookMessageEx(_logos_class$_ungrouped$NSURLSession, @selector(dataTaskWithRequest:completionHandler:), (IMP)&_logos_method$_ungrouped$NSURLSession$dataTaskWithRequest$completionHandler$, (IMP*)&_logos_orig$_ungrouped$NSURLSession$dataTaskWithRequest$completionHandler$);}Class _logos_class$_ungrouped$WKWebView = objc_getClass("WKWebView"); { MSHookMessageEx(_logos_class$_ungrouped$WKWebView, @selector(loadRequest:), (IMP)&_logos_method$_ungrouped$WKWebView$loadRequest$, (IMP*)&_logos_orig$_ungrouped$WKWebView$loadRequest$);}{ MSHookMessageEx(_logos_class$_ungrouped$WKWebView, @selector(evaluateJavaScript:completionHandler:), (IMP)&_logos_method$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$, (IMP*)&_logos_orig$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$);}Class _logos_class$_ungrouped$NSBundle = objc_getClass("NSBundle"); { MSHookMessageEx(_logos_class$_ungrouped$NSBundle, @selector(infoDictionary), (IMP)&_logos_method$_ungrouped$NSBundle$infoDictionary, (IMP*)&_logos_orig$_ungrouped$NSBundle$infoDictionary);}Class _logos_class$_ungrouped$NSFileManager = objc_getClass("NSFileManager"); { MSHookMessageEx(_logos_class$_ungrouped$NSFileManager, @selector(containerURLForSecurityApplicationGroupIdentifier:), (IMP)&_logos_method$_ungrouped$NSFileManager$containerURLForSecurityApplicationGroupIdentifier$, (IMP*)&_logos_orig$_ungrouped$NSFileManager$containerURLForSecurityApplicationGroupIdentifier$);}Class _logos_class$_ungrouped$NSData = objc_getClass("NSData"); { MSHookMessageEx(_logos_class$_ungrouped$NSData, @selector(writeToURL:atomically:), (IMP)&_logos_method$_ungrouped$NSData$writeToURL$atomically$, (IMP*)&_logos_orig$_ungrouped$NSData$writeToURL$atomically$);}Class _logos_class$_ungrouped$NSString = objc_getClass("NSString"); Class _logos_metaclass$_ungrouped$NSString = object_getClass(_logos_class$_ungrouped$NSString); { MSHookMessageEx(_logos_class$_ungrouped$NSString, @selector(writeToURL:atomically:encoding:error:), (IMP)&_logos_method$_ungrouped$NSString$writeToURL$atomically$encoding$error$, (IMP*)&_logos_orig$_ungrouped$NSString$writeToURL$atomically$encoding$error$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSString, @selector(stringWithContentsOfURL:encoding:error:), (IMP)&_logos_meta_method$_ungrouped$NSString$stringWithContentsOfURL$encoding$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSString$stringWithContentsOfURL$encoding$error$);}Class _logos_class$_ungrouped$BugsnagDevice = objc_getClass("BugsnagDevice"); { MSHookMessageEx(_logos_class$_ungrouped$BugsnagDevice, @selector(jailbroken), (IMP)&_logos_method$_ungrouped$BugsnagDevice$jailbroken, (IMP*)&_logos_orig$_ungrouped$BugsnagDevice$jailbroken);}{ MSHookMessageEx(_logos_class$_ungrouped$BugsnagDevice, @selector(locale), (IMP)&_logos_method$_ungrouped$BugsnagDevice$locale, (IMP*)&_logos_orig$_ungrouped$BugsnagDevice$locale);}{ MSHookMessageEx(_logos_class$_ungrouped$BugsnagDevice, @selector(modelNumber), (IMP)&_logos_method$_ungrouped$BugsnagDevice$modelNumber, (IMP*)&_logos_orig$_ungrouped$BugsnagDevice$modelNumber);}{ MSHookMessageEx(_logos_class$_ungrouped$BugsnagDevice, @selector(setOsVersion:), (IMP)&_logos_method$_ungrouped$BugsnagDevice$setOsVersion$, (IMP*)&_logos_orig$_ungrouped$BugsnagDevice$setOsVersion$);}Class _logos_class$_ungrouped$AppsFlyerLib = objc_getClass("AppsFlyerLib"); { MSHookMessageEx(_logos_class$_ungrouped$AppsFlyerLib, @selector(skipAdvancedJailbreakValidation), (IMP)&_logos_method$_ungrouped$AppsFlyerLib$skipAdvancedJailbreakValidation, (IMP*)&_logos_orig$_ungrouped$AppsFlyerLib$skipAdvancedJailbreakValidation);}{ MSHookMessageEx(_logos_class$_ungrouped$AppsFlyerLib, @selector(setSkipAdvancedJailbreakValidation:), (IMP)&_logos_method$_ungrouped$AppsFlyerLib$setSkipAdvancedJailbreakValidation$, (IMP*)&_logos_orig$_ungrouped$AppsFlyerLib$setSkipAdvancedJailbreakValidation$);}Class _logos_class$_ungrouped$AppsFlyerUtils = objc_getClass("AppsFlyerUtils"); Class _logos_metaclass$_ungrouped$AppsFlyerUtils = object_getClass(_logos_class$_ungrouped$AppsFlyerUtils); { MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(isJailbrokenWithSkipAdvancedJailbreakValidation:), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$isJailbrokenWithSkipAdvancedJailbreakValidation$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(isVPNConnected), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$isVPNConnected, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$isVPNConnected);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$AppsFlyerUtils, @selector(shouldCachePurchaseEventWithStatusCode:), (IMP)&_logos_meta_method$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$, (IMP*)&_logos_meta_orig$_ungrouped$AppsFlyerUtils$shouldCachePurchaseEventWithStatusCode$);}Class _logos_class$_ungrouped$CTCarrier = objc_getClass("CTCarrier"); { MSHookMessageEx(_logos_class$_ungrouped$CTCarrier, @selector(carrierName), (IMP)&_logos_method$_ungrouped$CTCarrier$carrierName, (IMP*)&_logos_orig$_ungrouped$CTCarrier$carrierName);}Class _logos_class$_ungrouped$NSProcessInfo = objc_getClass("NSProcessInfo"); { MSHookMessageEx(_logos_class$_ungrouped$NSProcessInfo, @selector(physicalMemory), (IMP)&_logos_method$_ungrouped$NSProcessInfo$physicalMemory, (IMP*)&_logos_orig$_ungrouped$NSProcessInfo$physicalMemory);}{ MSHookMessageEx(_logos_class$_ungrouped$NSProcessInfo, @selector(isLowPowerModeEnabled), (IMP)&_logos_method$_ungrouped$NSProcessInfo$isLowPowerModeEnabled, (IMP*)&_logos_orig$_ungrouped$NSProcessInfo$isLowPowerModeEnabled);}{ MSHookMessageEx(_logos_class$_ungrouped$NSProcessInfo, @selector(operatingSystemVersion), (IMP)&_logos_method$_ungrouped$NSProcessInfo$operatingSystemVersion, (IMP*)&_logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersion);}{ MSHookMessageEx(_logos_class$_ungrouped$NSProcessInfo, @selector(operatingSystemVersionString), (IMP)&_logos_method$_ungrouped$NSProcessInfo$operatingSystemVersionString, (IMP*)&_logos_orig$_ungrouped$NSProcessInfo$operatingSystemVersionString);}Class _logos_class$_ungrouped$UIScreen = objc_getClass("UIScreen"); { MSHookMessageEx(_logos_class$_ungrouped$UIScreen, @selector(brightness), (IMP)&_logos_method$_ungrouped$UIScreen$brightness, (IMP*)&_logos_orig$_ungrouped$UIScreen$brightness);}Class _logos_class$_ungrouped$GADOMIDDevice = objc_getClass("GADOMIDDevice"); Class _logos_metaclass$_ungrouped$GADOMIDDevice = object_getClass(_logos_class$_ungrouped$GADOMIDDevice); { MSHookMessageEx(_logos_metaclass$_ungrouped$GADOMIDDevice, @selector(deviceOsVersion), (IMP)&_logos_meta_method$_ungrouped$GADOMIDDevice$deviceOsVersion, (IMP*)&_logos_meta_orig$_ungrouped$GADOMIDDevice$deviceOsVersion);}Class _logos_class$_ungrouped$USRVDevice = objc_getClass("USRVDevice"); Class _logos_metaclass$_ungrouped$USRVDevice = object_getClass(_logos_class$_ungrouped$USRVDevice); { MSHookMessageEx(_logos_metaclass$_ungrouped$USRVDevice, @selector(getOsVersion), (IMP)&_logos_meta_method$_ungrouped$USRVDevice$getOsVersion, (IMP*)&_logos_meta_orig$_ungrouped$USRVDevice$getOsVersion);}Class _logos_class$_ungrouped$GADDevice = objc_getClass("GADDevice"); { MSHookMessageEx(_logos_class$_ungrouped$GADDevice, @selector(systemVersion), (IMP)&_logos_method$_ungrouped$GADDevice$systemVersion, (IMP*)&_logos_orig$_ungrouped$GADDevice$systemVersion);}Class _logos_class$_ungrouped$UADSMetricCommonTags = objc_getClass("UADSMetricCommonTags"); Class _logos_metaclass$_ungrouped$UADSMetricCommonTags = object_getClass(_logos_class$_ungrouped$UADSMetricCommonTags); { MSHookMessageEx(_logos_metaclass$_ungrouped$UADSMetricCommonTags, @selector(systemVersion), (IMP)&_logos_meta_method$_ungrouped$UADSMetricCommonTags$systemVersion, (IMP*)&_logos_meta_orig$_ungrouped$UADSMetricCommonTags$systemVersion);}{ MSHookMessageEx(_logos_class$_ungrouped$UADSMetricCommonTags, @selector(systemVersion), (IMP)&_logos_method$_ungrouped$UADSMetricCommonTags$systemVersion, (IMP*)&_logos_orig$_ungrouped$UADSMetricCommonTags$systemVersion);}{ MSHookMessageEx(_logos_class$_ungrouped$UADSMetricCommonTags, @selector(initWithCountryISO:platform:sdkVersion:systemVersion:testMode:metricTags:), (IMP)&_logos_method$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$, (IMP*)&_logos_orig$_ungrouped$UADSMetricCommonTags$initWithCountryISO$platform$sdkVersion$systemVersion$testMode$metricTags$);}{ MSHookMessageEx(_logos_class$_ungrouped$UADSMetricCommonTags, @selector(setSystemVersion:), (IMP)&_logos_method$_ungrouped$UADSMetricCommonTags$setSystemVersion$, (IMP*)&_logos_orig$_ungrouped$UADSMetricCommonTags$setSystemVersion$);}Class _logos_class$_ungrouped$_TtC9TinderKit7TUIView = objc_getClass("_TtC9TinderKit7TUIView"); { MSHookMessageEx(_logos_class$_ungrouped$_TtC9TinderKit7TUIView, @selector(traitCollectionDidChange:), (IMP)&_logos_method$_ungrouped$_TtC9TinderKit7TUIView$traitCollectionDidChange$, (IMP*)&_logos_orig$_ungrouped$_TtC9TinderKit7TUIView$traitCollectionDidChange$);}Class _logos_class$_ungrouped$_TtC13TinderAuthSMS30EnterPhoneNumberViewController = objc_getClass("_TtC13TinderAuthSMS30EnterPhoneNumberViewController"); { MSHookMessageEx(_logos_class$_ungrouped$_TtC13TinderAuthSMS30EnterPhoneNumberViewController, @selector(overrideChildrenContentSizeCategories), (IMP)&_logos_method$_ungrouped$_TtC13TinderAuthSMS30EnterPhoneNumberViewController$overrideChildrenContentSizeCategories, (IMP*)&_logos_orig$_ungrouped$_TtC13TinderAuthSMS30EnterPhoneNumberViewController$overrideChildrenContentSizeCategories);}Class _logos_class$_ungrouped$_TtC4Auth29GatedSMSCaptchaViewController = objc_getClass("_TtC4Auth29GatedSMSCaptchaViewController"); { MSHookMessageEx(_logos_class$_ungrouped$_TtC4Auth29GatedSMSCaptchaViewController, @selector(viewControllerNavigationKey), (IMP)&_logos_method$_ungrouped$_TtC4Auth29GatedSMSCaptchaViewController$viewControllerNavigationKey, (IMP*)&_logos_orig$_ungrouped$_TtC4Auth29GatedSMSCaptchaViewController$viewControllerNavigationKey);}Class _logos_class$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver = objc_getClass("_TtC11CaptchaView21ArkoseMessageReceiver"); { MSHookMessageEx(_logos_class$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver, @selector(loadRequest:), (IMP)&_logos_method$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$loadRequest$, (IMP*)&_logos_orig$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$loadRequest$);}{ MSHookMessageEx(_logos_class$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver, @selector(evaluateJavaScript:completionHandler:), (IMP)&_logos_method$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$evaluateJavaScript$completionHandler$, (IMP*)&_logos_orig$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$evaluateJavaScript$completionHandler$);}{ MSHookMessageEx(_logos_class$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver, @selector(userContentController:didReceiveScriptMessage:), (IMP)&_logos_method$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$userContentController$didReceiveScriptMessage$, (IMP*)&_logos_orig$_ungrouped$_TtC11CaptchaView21ArkoseMessageReceiver$userContentController$didReceiveScriptMessage$);}Class _logos_class$_ungrouped$USRVApiDeviceInfo = objc_getClass("USRVApiDeviceInfo"); Class _logos_metaclass$_ungrouped$USRVApiDeviceInfo = object_getClass(_logos_class$_ungrouped$USRVApiDeviceInfo); { MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getCurrentUITheme:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCurrentUITheme$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCurrentUITheme$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getLocaleList:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLocaleList$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLocaleList$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getSystemBootTime:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemBootTime$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemBootTime$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getDeviceName:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceName$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceName$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getVendorIdentifier:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getVendorIdentifier$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getVendorIdentifier$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getElapsedRealtime:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getElapsedRealtime$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getElapsedRealtime$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getUptime:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUptime$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUptime$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getCPUCount:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCPUCount$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getCPUCount$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_unregisterVolumeChangeListener:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_unregisterVolumeChangeListener$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_unregisterVolumeChangeListener$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_registerVolumeChangeListener:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_registerVolumeChangeListener$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_registerVolumeChangeListener$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getDeviceMaxVolume:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceMaxVolume$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceMaxVolume$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getGLVersion:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getGLVersion$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getGLVersion$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_isStatusBarHidden:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isStatusBarHidden$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isStatusBarHidden$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getStatusBarHeight:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarHeight$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarHeight$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getStatusBarWidth:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarWidth$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getStatusBarWidth$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getProcessInfo:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getProcessInfo$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getProcessInfo$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getSensorList:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSensorList$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSensorList$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getSupportedOrientations:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientations$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientations$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getAdNetworkIdsPlist:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdNetworkIdsPlist$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdNetworkIdsPlist$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getSupportedOrientationsPlist:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientationsPlist$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSupportedOrientationsPlist$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_isSimulator:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isSimulator$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isSimulator$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getUserInterfaceIdiom:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUserInterfaceIdiom$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUserInterfaceIdiom$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getUniqueEventId:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUniqueEventId$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getUniqueEventId$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_isRooted:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isRooted$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_isRooted$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getTotalMemory:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalMemory$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalMemory$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getFreeMemory:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeMemory$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeMemory$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getBatteryStatus:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryStatus$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryStatus$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getBatteryLevel:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryLevel$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getBatteryLevel$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getTotalSpace:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalSpace$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTotalSpace$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getFreeSpace:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeSpace$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getFreeSpace$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getScreenBrightness:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenBrightness$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenBrightness$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getDeviceVolume:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceVolume$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getDeviceVolume$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getSystemLanguage:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemLanguage$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getSystemLanguage$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getTimeZoneOffset:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZoneOffset$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZoneOffset$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getTimeZone:callback:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZone$callback$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getTimeZone$callback$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getHeadset:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getHeadset$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getHeadset$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getNetworkCountryISO:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkCountryISO$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkCountryISO$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getNetworkOperatorName:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperatorName$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperatorName$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_checkIsMuted:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_checkIsMuted$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_checkIsMuted$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getNetworkOperator:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperator$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkOperator$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getScreenHeight:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenHeight$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenHeight$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getScreenWidth:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenWidth$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenWidth$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getScreenScale:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenScale$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getScreenScale$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getNetworkType:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkType$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getNetworkType$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getConnectionType:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getConnectionType$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getConnectionType$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getModel:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getModel$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getModel$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getOsVersion:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getOsVersion$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getOsVersion$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getLimitAdTrackingFlag:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLimitAdTrackingFlag$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getLimitAdTrackingFlag$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$USRVApiDeviceInfo, @selector(WebViewExposed_getAdvertisingTrackingId:), (IMP)&_logos_meta_method$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdvertisingTrackingId$, (IMP*)&_logos_meta_orig$_ungrouped$USRVApiDeviceInfo$WebViewExposed_getAdvertisingTrackingId$);}Class _logos_class$_ungrouped$BNCDeviceInfo = objc_getClass("BNCDeviceInfo"); { MSHookMessageEx(_logos_class$_ungrouped$BNCDeviceInfo, @selector(loadDeviceInfo), (IMP)&_logos_method$_ungrouped$BNCDeviceInfo$loadDeviceInfo, (IMP*)&_logos_orig$_ungrouped$BNCDeviceInfo$loadDeviceInfo);}{ MSHookMessageEx(_logos_class$_ungrouped$BNCDeviceInfo, @selector(setCountry:), (IMP)&_logos_method$_ungrouped$BNCDeviceInfo$setCountry$, (IMP*)&_logos_orig$_ungrouped$BNCDeviceInfo$setCountry$);}{ MSHookMessageEx(_logos_class$_ungrouped$BNCDeviceInfo, @selector(localIPAddress), (IMP)&_logos_method$_ungrouped$BNCDeviceInfo$localIPAddress, (IMP*)&_logos_orig$_ungrouped$BNCDeviceInfo$localIPAddress);}{ MSHookMessageEx(_logos_class$_ungrouped$BNCDeviceInfo, @selector(userAgentString), (IMP)&_logos_method$_ungrouped$BNCDeviceInfo$userAgentString, (IMP*)&_logos_orig$_ungrouped$BNCDeviceInfo$userAgentString);}Class _logos_class$_ungrouped$FBSDKAppEventsDeviceInfo = objc_getClass("FBSDKAppEventsDeviceInfo"); { MSHookMessageEx(_logos_class$_ungrouped$FBSDKAppEventsDeviceInfo, @selector(setSysVersion:), (IMP)&_logos_method$_ungrouped$FBSDKAppEventsDeviceInfo$setSysVersion$, (IMP*)&_logos_orig$_ungrouped$FBSDKAppEventsDeviceInfo$setSysVersion$);}{ MSHookMessageEx(_logos_class$_ungrouped$FBSDKAppEventsDeviceInfo, @selector(sysVersion), (IMP)&_logos_method$_ungrouped$FBSDKAppEventsDeviceInfo$sysVersion, (IMP*)&_logos_orig$_ungrouped$FBSDKAppEventsDeviceInfo$sysVersion);}Class _logos_class$_ungrouped$OTDeviceInfo = objc_getClass("OTDeviceInfo"); Class _logos_metaclass$_ungrouped$OTDeviceInfo = object_getClass(_logos_class$_ungrouped$OTDeviceInfo); { MSHookMessageEx(_logos_metaclass$_ungrouped$OTDeviceInfo, @selector(systemName), (IMP)&_logos_meta_method$_ungrouped$OTDeviceInfo$systemName, (IMP*)&_logos_meta_orig$_ungrouped$OTDeviceInfo$systemName);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$OTDeviceInfo, @selector(systemVersion), (IMP)&_logos_meta_method$_ungrouped$OTDeviceInfo$systemVersion, (IMP*)&_logos_meta_orig$_ungrouped$OTDeviceInfo$systemVersion);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$OTDeviceInfo, @selector(libOpentokVersion), (IMP)&_logos_meta_method$_ungrouped$OTDeviceInfo$libOpentokVersion, (IMP*)&_logos_meta_orig$_ungrouped$OTDeviceInfo$libOpentokVersion);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$OTDeviceInfo, @selector(libOpentokSHA1), (IMP)&_logos_meta_method$_ungrouped$OTDeviceInfo$libOpentokSHA1, (IMP*)&_logos_meta_orig$_ungrouped$OTDeviceInfo$libOpentokSHA1);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$OTDeviceInfo, @selector(machineName), (IMP)&_logos_meta_method$_ungrouped$OTDeviceInfo$machineName, (IMP*)&_logos_meta_orig$_ungrouped$OTDeviceInfo$machineName);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$OTDeviceInfo, @selector(deviceUUID), (IMP)&_logos_meta_method$_ungrouped$OTDeviceInfo$deviceUUID, (IMP*)&_logos_meta_orig$_ungrouped$OTDeviceInfo$deviceUUID);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$OTDeviceInfo, @selector(userAgent), (IMP)&_logos_meta_method$_ungrouped$OTDeviceInfo$userAgent, (IMP*)&_logos_meta_orig$_ungrouped$OTDeviceInfo$userAgent);}Class _logos_class$_ungrouped$_TtC10TinderBase10DeviceInfo = objc_getClass("_TtC10TinderBase10DeviceInfo"); { MSHookMessageEx(_logos_class$_ungrouped$_TtC10TinderBase10DeviceInfo, @selector(init), (IMP)&_logos_method$_ungrouped$_TtC10TinderBase10DeviceInfo$init, (IMP*)&_logos_orig$_ungrouped$_TtC10TinderBase10DeviceInfo$init);}} }
#line 2003 "/Users/zb/GitHub/tinder/tinderDylib/Logos/tinderDylib.xm"
