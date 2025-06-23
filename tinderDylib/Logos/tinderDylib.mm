#line 1 "/Users/wuxiaoping/gitCode/tinder/tinderDylib/Logos/tinderDylib.xm"


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CustomViewController

@property (nonatomic, copy) NSString* newProperty;

+ (void)classMethod;

- (NSString*)getMyName;

- (void)newMethod:(NSString*) output;

@end


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

@class WKWebView; @class ASIdentifierManager; @class CustomViewController; @class NSJSONSerialization; @class UIDevice; 
static void (*_logos_meta_orig$_ungrouped$CustomViewController$classMethod)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static void _logos_meta_method$_ungrouped$CustomViewController$classMethod(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$CustomViewController$newMethod$(_LOGOS_SELF_TYPE_NORMAL CustomViewController* _LOGOS_SELF_CONST, SEL, NSString*); static id _logos_method$_ungrouped$CustomViewController$newProperty(_LOGOS_SELF_TYPE_NORMAL CustomViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$CustomViewController$setNewProperty$(_LOGOS_SELF_TYPE_NORMAL CustomViewController* _LOGOS_SELF_CONST, SEL, id); static NSString* (*_logos_orig$_ungrouped$CustomViewController$getMyName)(_LOGOS_SELF_TYPE_NORMAL CustomViewController* _LOGOS_SELF_CONST, SEL); static NSString* _logos_method$_ungrouped$CustomViewController$getMyName(_LOGOS_SELF_TYPE_NORMAL CustomViewController* _LOGOS_SELF_CONST, SEL); static NSUUID * (*_logos_orig$_ungrouped$ASIdentifierManager$advertisingIdentifier)(_LOGOS_SELF_TYPE_NORMAL ASIdentifierManager* _LOGOS_SELF_CONST, SEL); static NSUUID * _logos_method$_ungrouped$ASIdentifierManager$advertisingIdentifier(_LOGOS_SELF_TYPE_NORMAL ASIdentifierManager* _LOGOS_SELF_CONST, SEL); static NSUUID * (*_logos_orig$_ungrouped$UIDevice$identifierForVendor)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSUUID * _logos_method$_ungrouped$UIDevice$identifierForVendor(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static NSData * (*_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static NSData * _logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, id, NSJSONWritingOptions, NSError **); static id (*_logos_meta_orig$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSData *, NSJSONReadingOptions, NSError **); static id _logos_meta_method$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSData *, NSJSONReadingOptions, NSError **); static void (*_logos_orig$_ungrouped$WKWebView$loadRequest$)(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSURLRequest *); static void _logos_method$_ungrouped$WKWebView$loadRequest$(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSURLRequest *); static void (*_logos_orig$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$)(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSString *, void (^)(id result, NSError *error)); static void _logos_method$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL, NSString *, void (^)(id result, NSError *error)); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$CustomViewController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("CustomViewController"); } return _klass; }
#line 18 "/Users/wuxiaoping/gitCode/tinder/tinderDylib/Logos/tinderDylib.xm"



static void _logos_meta_method$_ungrouped$CustomViewController$classMethod(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSLog(@"+[<CustomViewController: %p> classMethod]", self);

	_logos_meta_orig$_ungrouped$CustomViewController$classMethod(self, _cmd);
}


static void _logos_method$_ungrouped$CustomViewController$newMethod$(_LOGOS_SELF_TYPE_NORMAL CustomViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* output){
    NSLog(@"This is a new method : %@", output);
}


static id _logos_method$_ungrouped$CustomViewController$newProperty(_LOGOS_SELF_TYPE_NORMAL CustomViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return objc_getAssociatedObject(self, @selector(newProperty));
}


static void _logos_method$_ungrouped$CustomViewController$setNewProperty$(_LOGOS_SELF_TYPE_NORMAL CustomViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id value) {
    objc_setAssociatedObject(self, @selector(newProperty), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static NSString* _logos_method$_ungrouped$CustomViewController$getMyName(_LOGOS_SELF_TYPE_NORMAL CustomViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
	NSLog(@"-[<CustomViewController: %p> getMyName]", self);
    NSString* password = MSHookIvar<NSString*>(self,"_password");
    NSLog(@"password:%@", password);
    
    [_logos_static_class_lookup$CustomViewController() classMethod];
    [self newMethod:@"output"];
    self.newProperty = @"newProperty";
    NSLog(@"newProperty : %@", self.newProperty);
    
	return _logos_orig$_ungrouped$CustomViewController$getMyName(self, _cmd);
}



#pragma mark - IDFA


static NSUUID * _logos_method$_ungrouped$ASIdentifierManager$advertisingIdentifier(_LOGOS_SELF_TYPE_NORMAL ASIdentifierManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"[Hooked] 原来的IDFA: %@", _logos_orig$_ungrouped$ASIdentifierManager$advertisingIdentifier(self, _cmd));
    NSString *key = @"my_hooked_advertisingIdentifier_key";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedUUID = [defaults stringForKey:key];

    if (savedUUID && savedUUID.length > 0) {
        NSLog(@"[Hooked] Returning saved IDFA: %@", savedUUID);
        return [[NSUUID alloc] initWithUUIDString:savedUUID];
    } else {
        NSUUID *newUUID = [NSUUID UUID];
        NSString *newUUIDStr = [newUUID UUIDString];
        NSLog(@"[Hooked] No saved IDFA. Generated new: %@", newUUIDStr);

        [defaults setObject:newUUIDStr forKey:key];
        [defaults synchronize];

        return newUUID;
    }
    return _logos_orig$_ungrouped$ASIdentifierManager$advertisingIdentifier(self, _cmd);
}



#pragma mark - UIDevice（IDFV）


static NSUUID * _logos_method$_ungrouped$UIDevice$identifierForVendor(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSLog(@"[Hooked] 原来的IDFV: %@", _logos_orig$_ungrouped$UIDevice$identifierForVendor(self, _cmd));
    NSString *key = @"my_hooked_identifierForVendor_key";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedUUID = [defaults stringForKey:key];

    if (savedUUID && savedUUID.length > 0) {
        NSLog(@"[Hooked] 保存原来的IDFV（UUID）: %@", savedUUID);
        return [[NSUUID alloc] initWithUUIDString:savedUUID];
    } else {
        
        NSUUID *newUUID = [NSUUID UUID];
        NSString *newUUIDStr = [newUUID UUIDString];
        NSLog(@"[Hooked] 生成新的IDFV（UUID）: %@", newUUIDStr);

        
        [defaults setObject:newUUIDStr forKey:key];
        [defaults synchronize];

        return newUUID;
    }
    return _logos_orig$_ungrouped$UIDevice$identifierForVendor(self, _cmd);
}



#pragma mark - CLLocation











































































#pragma mark - NSJSONSerialization




static NSData * _logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id obj, NSJSONWritingOptions opt, NSError ** error) {
    
    NSData *result = _logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$(self, _cmd, obj, opt, error);
    
    if (result) {

        NSError *err = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:&err];
        NSLog(@"[Hook] JSON -> NSData: %@", jsonDict);
    } else {
        NSLog(@"[Hook] JSON -> NSData Error: %@", *error);
    }
    return result;
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


#pragma mark - Auth.RefreshTokenInteractor













































































































































































































#pragma mark - BSGPersistentDeviceID


































static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$CustomViewController = objc_getClass("CustomViewController"); Class _logos_metaclass$_ungrouped$CustomViewController = object_getClass(_logos_class$_ungrouped$CustomViewController); { MSHookMessageEx(_logos_metaclass$_ungrouped$CustomViewController, @selector(classMethod), (IMP)&_logos_meta_method$_ungrouped$CustomViewController$classMethod, (IMP*)&_logos_meta_orig$_ungrouped$CustomViewController$classMethod);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CustomViewController, @selector(newMethod:), (IMP)&_logos_method$_ungrouped$CustomViewController$newMethod$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CustomViewController, @selector(newProperty), (IMP)&_logos_method$_ungrouped$CustomViewController$newProperty, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CustomViewController, @selector(setNewProperty:), (IMP)&_logos_method$_ungrouped$CustomViewController$setNewProperty$, _typeEncoding); }{ MSHookMessageEx(_logos_class$_ungrouped$CustomViewController, @selector(getMyName), (IMP)&_logos_method$_ungrouped$CustomViewController$getMyName, (IMP*)&_logos_orig$_ungrouped$CustomViewController$getMyName);}Class _logos_class$_ungrouped$ASIdentifierManager = objc_getClass("ASIdentifierManager"); { MSHookMessageEx(_logos_class$_ungrouped$ASIdentifierManager, @selector(advertisingIdentifier), (IMP)&_logos_method$_ungrouped$ASIdentifierManager$advertisingIdentifier, (IMP*)&_logos_orig$_ungrouped$ASIdentifierManager$advertisingIdentifier);}Class _logos_class$_ungrouped$UIDevice = objc_getClass("UIDevice"); { MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(identifierForVendor), (IMP)&_logos_method$_ungrouped$UIDevice$identifierForVendor, (IMP*)&_logos_orig$_ungrouped$UIDevice$identifierForVendor);}Class _logos_class$_ungrouped$NSJSONSerialization = objc_getClass("NSJSONSerialization"); Class _logos_metaclass$_ungrouped$NSJSONSerialization = object_getClass(_logos_class$_ungrouped$NSJSONSerialization); { MSHookMessageEx(_logos_metaclass$_ungrouped$NSJSONSerialization, @selector(dataWithJSONObject:options:error:), (IMP)&_logos_meta_method$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSJSONSerialization$dataWithJSONObject$options$error$);}{ MSHookMessageEx(_logos_metaclass$_ungrouped$NSJSONSerialization, @selector(JSONObjectWithData:options:error:), (IMP)&_logos_meta_method$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$, (IMP*)&_logos_meta_orig$_ungrouped$NSJSONSerialization$JSONObjectWithData$options$error$);}Class _logos_class$_ungrouped$WKWebView = objc_getClass("WKWebView"); { MSHookMessageEx(_logos_class$_ungrouped$WKWebView, @selector(loadRequest:), (IMP)&_logos_method$_ungrouped$WKWebView$loadRequest$, (IMP*)&_logos_orig$_ungrouped$WKWebView$loadRequest$);}{ MSHookMessageEx(_logos_class$_ungrouped$WKWebView, @selector(evaluateJavaScript:completionHandler:), (IMP)&_logos_method$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$, (IMP*)&_logos_orig$_ungrouped$WKWebView$evaluateJavaScript$completionHandler$);}} }
#line 612 "/Users/wuxiaoping/gitCode/tinder/tinderDylib/Logos/tinderDylib.xm"
