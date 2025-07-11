//
//  FloatingExtendVC.m
//
//  Created by yiche on 2025/3/27.
//

#import "FloatingExtendVC.h"
#import <Masonry/Masonry.h>
#import <Security/Security.h>
#import "Toast.h"
#import "JailbreakDetectionTool.h"
#import "ZBNetwork.h"
#import "AESUtil.h"
#import "Tools.h"

#define kService [[NSBundle mainBundle] bundleIdentifier]

@interface FloatingExtendVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *container1;
@property (nonatomic, strong) UIView *container2;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UILabel *tokenLab;

@property (nonatomic, assign) NSInteger tapCount;

//设备ID
@property (nonatomic, copy) NSString *deviceId;
//激活码
@property (nonatomic, copy) NSString *codeStr;

@end

@implementation FloatingExtendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;

    //获取一个deviceId
    NSString *deviceId = [self loadFromKeychainWithAccount:@"myDeviceID"];
    if (deviceId && deviceId.length > 0) {
        self.deviceId = deviceId;
        NSLog(@"UUID: %@", deviceId);
    } else {
        // 生成新的 UUID
        NSUUID *UUID = [[UIDevice alloc] identifierForVendor];
        NSString *UUIDStr = [UUID UUIDString];
        NSLog(@"UUID: Generated new: %@", UUIDStr);
        self.deviceId = UUIDStr;
        // 保存到钥匙串
        [self saveToKeychainWithAccount:@"myDeviceID" value:UUIDStr];
    }
//    [self requestInfo];
    [self setupTitleLab];
    [self setupScrollView];
    [self getTokenViews];
    [self updatetokenLab];
    
    [self setupBottmViews];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self readAllKeychainItems];
        [self redAllUserDefaults];
        [JailbreakDetectionTool isDeviceJailbroken];
        [JailbreakDetectionTool isInjected];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"end,回到主线程");
        });
    });
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.view];

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    // 设置右上角区域大小，比如 100x100
    if (location.x > screenWidth - 100 && location.y < 100) {
        self.tapCount++;

        if (self.tapCount >= 5) {
            NSLog(@"🎉 featureAEnabled = YES, featureBEnabled = YES");
            // 重置计数
            self.tapCount = 0;
            [self.container2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(120);
            }];
        }
    } else {
        // 如果点击不在右上角区域，重置计数
        self.tapCount = 0;
    }
}

//首先检查是否有效
- (void)requestInfo{
    NSDictionary *dic = @{
        @"device_id" : self.deviceId
    };
    [ZBNetwork POST:@"/api/device/codeinfo" param:dic success:^(NSData * _Nullable data, NSURLResponse * _Nullable response) {
        // 尝试转 JSON
        NSError *jsonError = nil;
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"❌ JSON 解析失败: %@", jsonError.localizedDescription);
            return;
        }
        NSLog(@"✅ JSON 解析成功: %@", dicData);
//        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

//        NSDictionary *dicData = response;
        NSString *dataStr = dicData[@"data"];
        if (!dataStr.length) {
            return;
        }
        NSString *jsonStr = [AESUtil aesDecrypt:dataStr];//解析密文得到json字符串
        NSDictionary *dict = [Tools convert2DictionaryWithJSONString:jsonStr];
//        NSLog(@"codeinfo：%@", dict);
        int isSuccess = [dict[@"isSuccess"] intValue];
        if (isSuccess == 1) {// 1不需要绑定
            [self updatetokenLab];
        }else{//-1需要绑定
            [self presentActivationAlert];
        }
    } failure:^(NSError * _Nullable error) {
        [self presentActivationAlert];
    }];
}

//绑定设备
- (void)requestBindingDevice{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"deviceId"] = self.deviceId;
    dic[@"code"] = self.codeStr;
    
    NSString *jsonStr = [Tools convert2JSONWithDictionary:dic];//字典转成json
    NSString *encStr = [AESUtil aesEncrypt:jsonStr];
    NSLog(@"encStr:%@", encStr);
    
    [ZBNetwork POST:@"/api/device/bindCode" param:@{@"device_str" : encStr} success:^(NSData * _Nullable data, NSURLResponse * _Nullable response) {
//        NSLog(@"%@", response);
        NSError *jsonError = nil;
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"❌ JSON 解析失败: %@", jsonError.localizedDescription);
            return;
        }
        NSString *dataStr = dicData[@"data"];
        if (dataStr.length) {
            NSString *jsonStr = [AESUtil aesDecrypt:dataStr];//解析密文得到json字符串
            NSDictionary *dict = [Tools convert2DictionaryWithJSONString:jsonStr];
            int isSuccess = [dict[@"isSuccess"] intValue];
            if (isSuccess == 1) {//1
                [Toast showToast:@"🎉授权成功🎉"];
                [self updatetokenLab];
            }else{//0
                [self presentActivationAlert];
            }
        }else{
            [Toast showToast:dicData[@"msg"]];
            [self presentActivationAlert];
        }
    } failure:^(NSError * _Nullable error) {
        [Toast showToast:error.userInfo[@"msg"]];
        [self presentActivationAlert];
    }];
}

#pragma mark - 激活
- (void)presentActivationAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入激活码" message:nil preferredStyle:UIAlertControllerStyleAlert];

    __block UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        NSString *code = textField.text;
        if (code.length != 12 || ![self isValidActivationCode:code]) {
            [Toast showToast:@"无效激活码"];
            // 手动重新激活输入框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentActivationAlert]; // 重新弹出整个弹窗
            });
            return;
        }

        self.codeStr = code;
        [self requestBindingDevice];
    }];

    confirm.enabled = NO; // 初始禁用
    [alert addAction:confirm];

    // 添加输入框并实时监听内容变化
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入激活码";
        textField.font = [UIFont systemFontOfSize:18];
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;

        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            NSString *text = textField.text;
            confirm.enabled = (text.length == 12 && [self isValidActivationCode:text]);
        }];
    }];

    [self presentViewController:alert animated:YES completion:^{
        [alert.textFields.firstObject becomeFirstResponder];
    }];
}

- (BOOL)isValidActivationCode:(NSString *)code {
    NSCharacterSet *validSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];
    return [[code stringByTrimmingCharactersInSet:validSet.invertedSet] isEqualToString:code];
}

#pragma mark - 界面布局
- (void)setupTitleLab {
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = @"客服Tg:abb0226";
    self.titleLab.font = [UIFont boldSystemFontOfSize:24];
    self.titleLab.textColor = UIColor.labelColor;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
        make.centerX.equalTo(self.view);
        make.left.greaterThanOrEqualTo(self.view).offset(40);
        make.right.lessThanOrEqualTo(self.view).offset(-40);
    }];
}

- (void)setupScrollView {
    // 创建 scrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = YES;
    self.scrollView.delegate = self;
//    self.scrollView.showsVerticalScrollIndicator = NO;
//    self.scrollView.backgroundColor = UIColor.greenColor;
    [self.view addSubview:self.scrollView];
    
    // 创建 contentView
    self.contentView = [[UIView alloc] init];
//    self.contentView.backgroundColor = UIColor.redColor;
    [self.scrollView addSubview:self.contentView];
    
    // 设置 scrollView 的约束
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(10); // 距离 titleLab 底部40
        make.left.right.bottom.equalTo(self.view); // 左右和底部与父视图相等
    }];
    
    // 设置 contentView 的约束
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView); // contentView 的四个边与 scrollView 对齐
        make.width.equalTo(self.scrollView); // contentView 宽度与 scrollView 相同
        make.bottom.equalTo(self.view.mas_bottom).offset(20); // 动态设置 contentView 底部高度，确保可以滚动
    }];
    
    // 设置 tap 手势，点击 scrollView 时执行 popVC 方法
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popVC)];
    [self.scrollView addGestureRecognizer:tap];
}

// 提取token
- (void)getTokenViews{
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = UIColor.systemGroupedBackgroundColor;// [UIColor colorWithWhite:0.98 alpha:1.0];
    container.layer.cornerRadius = 6;
    container.layer.borderColor = [UIColor colorWithWhite:0.96 alpha:1.0].CGColor;
    container.layer.borderWidth = 1;
    container.clipsToBounds = YES;
    self.container1 = container;
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.backgroundColor = UIColor.systemGroupedBackgroundColor;//[UIColor colorWithWhite:0.98 alpha:1.0];
    contentLab.font = [UIFont systemFontOfSize:16];
    contentLab.textColor = UIColor.labelColor;
    contentLab.numberOfLines = 0;
    contentLab.adjustsFontSizeToFitWidth = YES;
    contentLab.minimumScaleFactor = 0.8;
    self.tokenLab = contentLab;
    [container addSubview:contentLab];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [copyBtn setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:container];
    [container addSubview:copyBtn];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(50);
        make.left.right.equalTo(self.contentView).inset(15);
        make.height.mas_equalTo(120);
    }];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(container).inset(12);
        make.right.equalTo(copyBtn.mas_left);
        make.bottom.equalTo(container).offset(-12);
    }];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(container);
        make.width.mas_equalTo(50);
    }];

    
    //设置
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = UIColor.systemGroupedBackgroundColor;//[UIColor colorWithWhite:0.98 alpha:1.0];
    view2.layer.cornerRadius = 6;
    view2.layer.borderColor = [UIColor colorWithWhite:0.96 alpha:1.0].CGColor;
    view2.layer.borderWidth = 1;
    view2.clipsToBounds = YES;
    self.container2 = view2;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveBtn setTitle:@"登录" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [saveBtn setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:view2];
    [view2 addSubview:self.textView];
    [view2 addSubview:saveBtn];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(15);
        make.height.mas_equalTo(0);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(view2).inset(12);
        make.right.equalTo(saveBtn.mas_left);
        make.bottom.equalTo(view2).offset(-12);
    }];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(view2);
        make.width.mas_equalTo(50);
    }];
    
    /*
    //经纬度
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    view3.layer.cornerRadius = 6;
    view3.layer.borderColor = [UIColor colorWithWhite:0.96 alpha:1.0].CGColor;
    view3.layer.borderWidth = 1;
    [self.contentView addSubview:view3];
    [self.contentView addSubview:self.textField1];
    [self.contentView addSubview:self.textField2];

    UIButton *saveBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveBtn3 setTitle:@"保存\n经纬度" forState:UIControlStateNormal]; // 使用 \n 进行换行
    saveBtn3.titleLabel.numberOfLines = 0; // 允许多行显示
    saveBtn3.titleLabel.textAlignment = NSTextAlignmentCenter; // 文字居中
    saveBtn3.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [saveBtn3 setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    [saveBtn3 addTarget:self action:@selector(saveLonLatAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:saveBtn3];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(15);
//        make.height.mas_equalTo(120);
    }];
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(view3).inset(10);
        make.right.equalTo(saveBtn3.mas_left);
        make.height.mas_equalTo(44);
    }];
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField1.mas_bottom);
        make.left.equalTo(view3).inset(12);
        make.right.equalTo(saveBtn3.mas_left);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(view3).inset(10);
    }];
    [saveBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(view3);
        make.width.mas_equalTo(50);
    }];*/
}

- (void)setupBottmViews {
    // 清除缓存按钮
//    UIButton *clearCacheBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    clearCacheBtn.backgroundColor = [UIColor colorWithRed:0.27 green:0.56 blue:0.89 alpha:1.0]; // 设置不同颜色
//    clearCacheBtn.layer.cornerRadius = 25;
//    clearCacheBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
//    [clearCacheBtn setTitle:@"清除缓存" forState:UIControlStateNormal];
//    [clearCacheBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    [clearCacheBtn addTarget:self action:@selector(clearCacheAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:clearCacheBtn];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    clearBtn.backgroundColor = [UIColor colorWithRed:0.89 green:0.27 blue:0.27 alpha:1.0];
    clearBtn.layer.cornerRadius = 25;
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    [clearBtn setTitle:@"一键清除" forState:UIControlStateNormal];
    [clearBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    
//    [clearCacheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view).inset(40);
//        make.height.mas_equalTo(50);
//        make.bottom.equalTo(clearBtn.mas_top).offset(-20); // 将清除缓存按钮放在清除钥匙串按钮上方
//    }];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(40);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
    }];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = @"点击空白区域关闭页面";
    lbl.textColor = [UIColor colorWithRed:0.89 green:0.27 blue:0.27 alpha:0.5];
    [self.view addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(clearBtn);
        make.top.mas_equalTo(clearBtn.mas_bottom).mas_offset(10);
    }];
}

- (void)updatetokenLab {
    NSString *authToken = [self loadFromKeychainWithAccount:@"TNDRAPITokenKey"];
    NSString *deviceId = [self loadFromKeychainWithAccount:@"persistentDeviceID"];
    NSString *refreshToken = [self loadFromKeychainWithAccount:@"refreshToken"];
    
    // token过期时间：2025-04-03T11:02:36.351Z
    NSString *tokenExpiration = [self loadFromKeychainWithAccount:@"Auth.authTokenExpiration"];
    NSString *hasDeviceEverSignedIn = [self loadFromKeychainWithAccount:@"has_device_ever_signed_in"];
    NSLog(@"%@, %@",tokenExpiration, hasDeviceEverSignedIn);
    
    double lon = [[NSUserDefaults standardUserDefaults] doubleForKey:@"c.longitude"];
    double lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"c.latitude"];
    
    self.tokenLab.text = [NSString stringWithFormat:@"%@!%@!%@", authToken, deviceId, refreshToken];
    self.textField1.text = @(lon).stringValue;
    self.textField2.text = @(lat).stringValue;
}

#pragma mark - action
- (void)copyAction:(UIButton *)sender {
    UIPasteboard.generalPasteboard.string = self.tokenLab.text;
    [Toast showToast:@"复制成功"];
}

- (void)saveAction:(UIButton *)sender {
    // 拆分 self.tokenLab.text，假设格式为 "authToken!deviceId!refreshToken"
    NSArray *components = [self.textView.text componentsSeparatedByString:@"!"];
    
    if (components.count == 3) {
        self.tokenLab.text = self.textView.text;
        [self.view endEditing:YES];

        NSString *authToken = components[0];
        NSString *deviceId = components[1];
        NSString *refreshToken = components[2];
        
        [self saveToKeychainWithAccount:@"TNDRAPITokenKey" value:authToken];
        [self saveToKeychainWithAccount:@"persistentDeviceID" value:deviceId];
        [self saveToKeychainWithAccount:@"refreshToken" value:refreshToken];
        [self saveToKeychainWithAccount:@"has_device_ever_signed_in" value:@"YES"];
        
        NSString *expirationString = [self threeDaysLaterISO8601String];
        NSLog(@"🔐 过期时间: %@", expirationString);
        [self saveToKeychainWithAccount:@"Auth.authTokenExpiration" value:expirationString];
        
        NSLog(@"AuthToken: %@, DeviceId: %@, RefreshToken: %@", authToken, deviceId, refreshToken);

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功，重启生效" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定重启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self exitApplication];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [Toast showToast:@"请输入正确格式的token"];
        NSLog(@"Error: Token label format is incorrect.");
    }
}

//保存经纬度
- (void)saveLonLatAction:(UIButton *)sender {
    if (self.textField1.text.length) {
        [[NSUserDefaults standardUserDefaults] setDouble:self.textField1.text.doubleValue forKey:@"c.longitude"];
    }else{
        [Toast showToast:@"请输入经度"];
        return;
    }
    
    if (self.textField2.text.length) {
        [[NSUserDefaults standardUserDefaults] setDouble:self.textField2.text.doubleValue forKey:@"c.latitude"];
        [[NSUserDefaults standardUserDefaults] doubleForKey:@""];
    }else{
        [Toast showToast:@"请输入纬度"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

// 清除缓存的实现
- (void)clearAction {
    // 1. 清除 URL 缓存
    NSURLCache *cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    NSLog(@"网络请求缓存已清除");
    
    // 2. 清除沙盒缓存文件夹中的所有内容
    [self clearSandboxFiles];
    
    // 3. 清除用户默认设置缓存（可选）
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    NSLog(@"用户默认设置缓存已清除");
    
    // 4. 清空钥匙串
    [self clearKeychainExceptForAccounts:@[@"myDeviceID"]];
    
    // 5. 退出程序
    [self exitApplication];
    NSLog(@"缓存已清除");
}

- (void)exitApplication {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.8 animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(window.bounds.size.width/2, window.bounds.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
        exit(0); // 实际退出（慎用）
    }];
}

#pragma mark - 清除缓存和沙盒文件
// 清理指定app的沙盒，传入要清理的 App 的 bundleId
- (void)clearSandboxFiles:(NSString *)bundleId {
    // 获取所有沙盒目录路径
    NSString *appsPath = @"/private/var/mobile/Containers/Data/Application";
    NSArray *uuidDirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appsPath error:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (NSString *uuid in uuidDirs) {
        NSString *fullPath = [appsPath stringByAppendingPathComponent:uuid];
        NSString *prefsPath = [fullPath stringByAppendingPathComponent:@"Library/Preferences"];
        NSArray *prefsFiles = [fileManager contentsOfDirectoryAtPath:prefsPath error:nil];
        
        // 判断是否包含指定 bundleId 的 plist
        for (NSString *prefsFile in prefsFiles) {
            if ([prefsFile containsString:bundleId]) {
                // 找到目标 app 的沙盒，开始清理
                NSArray *paths = @[
                    [fullPath stringByAppendingPathComponent:@"Library/Caches"],
                    [fullPath stringByAppendingPathComponent:@"Documents"],
                    [fullPath stringByAppendingPathComponent:@"Library/Preferences"],
                    [fullPath stringByAppendingPathComponent:@"tmp"]
                ];
                
                for (NSString *path in paths) {
                    NSArray *files = [fileManager contentsOfDirectoryAtPath:path error:nil];
                    for (NSString *file in files) {
                        NSString *filePath = [path stringByAppendingPathComponent:file];
                        [fileManager removeItemAtPath:filePath error:nil];
                    }
                }
                NSLog(@"✅ 已清理 App (%@) 的沙盒文件", bundleId);
                break;
            }
        }
    }
}

//清理当前app的沙盒
- (void)clearSandboxFiles {
    NSArray *paths = @[
        NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject,  // ~/Library/Caches
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject, // ~/Documents
        [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"], // NSUserDefaults 等
        NSTemporaryDirectory() // ~/tmp
    ];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *path in paths) {
        NSArray *files = [fileManager contentsOfDirectoryAtPath:path error:nil];
        for (NSString *file in files) {
            NSString *filePath = [path stringByAppendingPathComponent:file];
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    NSLog(@"✅ 清除沙盒文件完成");
}

#pragma mark - NSUserDefaults
//读取所有的NSUserDefaults值
- (void)redAllUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *allDefaults = [defaults dictionaryRepresentation];

    // 打印所有键值对
    NSLog(@"-------👇👇👇NSUserDefaults👇👇👇-------");
    [allDefaults enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSLog(@"🏷️%@ : %@", key, value);
    }];
    NSLog(@"-------👆👆👆NSUserDefaults👆👆👆-------");
}

#pragma mark - 钥匙串操作
//封装钥匙串 Class 列表
- (NSArray<id> *)keychainItemClasses {
    return @[
        (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecClassInternetPassword,
        (__bridge id)kSecClassCertificate,
        (__bridge id)kSecClassKey,
        (__bridge id)kSecClassIdentity
    ];
}

//统一遍历 Keychain 条目并回调
- (void)enumerateKeychainItemsWithHandler:(void (^)(NSDictionary *item, id secClass))handler {
    for (id secClass in [self keychainItemClasses]) {
        NSDictionary *query = @{
            (__bridge id)kSecClass: secClass,
            (__bridge id)kSecReturnAttributes: @YES,
            (__bridge id)kSecReturnData: @YES,
            (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitAll
        };
        
        CFTypeRef result = NULL;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
        
        if (status == errSecSuccess) {
            NSArray *items = (__bridge_transfer NSArray *)result;
            for (NSDictionary *item in items) {
                handler(item, secClass);
            }
        }
    }
}

//清空（可保留指定 account）
- (void)clearKeychainExceptForAccounts:(NSArray<NSString *> *)preservedAccounts {
    [self enumerateKeychainItemsWithHandler:^(NSDictionary *item, id secClass) {
        NSString *account = item[(__bridge id)kSecAttrAccount];
        if ([preservedAccounts containsObject:account]) {
            NSLog(@"⏸️ 保留账号：%@", account);
        }else{
            NSMutableDictionary *deleteQuery = [item mutableCopy];
            deleteQuery[(__bridge id)kSecClass] = secClass;
            deleteQuery[(__bridge id)kSecReturnAttributes] = nil;
            deleteQuery[(__bridge id)kSecReturnData] = nil;
            OSStatus status = SecItemDelete((__bridge CFDictionaryRef)deleteQuery);
            if (status == errSecSuccess) {
                NSLog(@"✅ 删除项：%@", account ?: @"<无账号>");
            } else {
                NSLog(@"❌ 删除失败：%@", @(status));
            }
        }
    }];
}

// 读取所有钥匙串的值
- (void)readAllKeychainItems {
    [self enumerateKeychainItemsWithHandler:^(NSDictionary *item, id secClass) {
        NSString *service = item[(__bridge id)kSecAttrService];
        NSString *account = item[(__bridge id)kSecAttrAccount];
        NSData *passwordData = item[(__bridge id)kSecValueData];
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        NSLog(@"🔐 [%@] Service: %@ | Account: %@ | Value: %@", secClass, service, account, password);
    }];
}

// 查询 指定account
- (NSString *)loadFromKeychainWithAccount:(NSString *)account {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kService,
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecReturnData: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne
    };

    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);

    if (status == errSecSuccess) {
        NSData *data = (__bridge_transfer NSData *)result;
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"Keychain 查询失败: %@", @(status));
        return nil;
    }
}

// 存储
- (void)saveToKeychainWithAccount:(NSString *)account value:(NSString *)value {
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kService,
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecValueData: valueData,
        (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAfterFirstUnlock,
    };

    // 先尝试更新
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)@{ (__bridge id)kSecValueData: valueData });
    
    // 如果更新失败，说明 Keychain 里没有这个数据，则插入
    if (status == errSecItemNotFound) {
        SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }else{
        NSLog(@"Keychain 存储失败: %@", @(status));
    }
}

//清理所有钥匙串值
- (void)clearKeychain {
    NSDictionary *secItemClasses[] = {
        @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword},
        @{(__bridge id)kSecClass: (__bridge id)kSecClassInternetPassword},
        @{(__bridge id)kSecClass: (__bridge id)kSecClassCertificate},
        @{(__bridge id)kSecClass: (__bridge id)kSecClassKey},
        @{(__bridge id)kSecClass: (__bridge id)kSecClassIdentity}
    };
    for (int i = 0; i < sizeof(secItemClasses) / sizeof(secItemClasses[0]); i++) {
        SecItemDelete((__bridge CFDictionaryRef)secItemClasses[i]);
    }
}

#pragma mark - 辅助方法
- (NSString *)threeDaysLaterISO8601String {
    // 当前本地时间
    NSDate *now = [NSDate date];
    
    // 加 3 天
    NSDate *threeDaysLater = [now dateByAddingTimeInterval:60 * 60 * 24 * 3];
    
    // 设置日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]; // 保证格式稳定
    formatter.timeZone = [NSTimeZone localTimeZone]; // 本地时区
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

    // 格式化为字符串
    NSString *isoString = [formatter stringFromDate:threeDaysLater];
    return isoString;
}

- (void)popVC {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy
- (UITextView *)textView{
    if (!_textView) {
        UITextView *tView = [[UITextView alloc]init];
        tView.backgroundColor = UIColor.systemGroupedBackgroundColor;//[UIColor colorWithWhite:0.98 alpha:1.0];
        tView.font = [UIFont systemFontOfSize:16];
        tView.textColor = UIColor.labelColor;
        _textView = tView;
    }
    return _textView;
}

- (UITextField *)textField1{
    if (!_textField1) {
        UITextField *tf = [[UITextField alloc]init];
        tf.keyboardType = UIKeyboardTypeDecimalPad;
        tf.textColor = UIColor.labelColor;
        NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.86 alpha:1]}; // 设置占位符颜色
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入经度" attributes:attributes];
        _textField1 = tf;
    }
    return _textField1;
}

- (UITextField *)textField2{
    if (!_textField2) {
        UITextField *tf = [[UITextField alloc]init];
        tf.keyboardType = UIKeyboardTypeDecimalPad;
        tf.textColor = UIColor.labelColor;
        NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.86 alpha:1]}; // 设置占位符颜色
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入纬度" attributes:attributes];
    //    tf.font = [UIFont systemFontOfSize:16];    return %orig(31.230400, 121.473700);

        _textField2 = tf;
    }
    return _textField2;
}

@end
