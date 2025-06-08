//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  LLDBTools.h
//  MonkeyDev
//
//  Created by AloneMonkey on 2018/3/8.
//  Copyright © 2018年 AloneMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mach/vm_types.h>

//(lldb) po pviews()

/// 打印当前界面（keyWindow 的 rootViewController）的控制器层级结构（私有 API _printHierarchy）
/// 通常用于 LLDB 调试时查看当前控制器堆栈情况
NSString* pvc(void);

/// 打印整个 UIWindow 的视图结构（recursiveDescription 是私有 API）
/// 可用于在 LLDB 中查看 view 的嵌套层级
NSString* pviews(void);

/// 打印某个 UIControl 对象上的所有事件绑定
/// 传入该控件的内存地址，返回每个 target 对象及其绑定的 selector 名称
NSString* pactions(vm_address_t address);

/// 打印一个 block 对象的 invoke 地址和签名（若有）
/// 传入 block 内存地址，返回 block 的函数签名及其实现地址
NSString* pblock(vm_address_t address);

/// 使用私有 API _shortMethodDescription 打印某个类的简短方法描述信息
/// 类似于打印类的实例方法列表（适用于 LLDB 调试）
NSString* methods(const char * classname);

/// 使用私有 API _ivarDescription 打印某个对象的成员变量（ivars）信息
/// 传入对象的内存地址，返回描述信息字符串
NSString* ivars(vm_address_t address);

/// 在内存中查找某个类（或其子类）的实例对象并打印其地址
/// 类似于 Cycript 的 choose() 函数，便于动态查找某类实例
NSString* choose(const char* classname);

/// 打印当前进程的虚拟内存映射（vmmap），包括每个 region 的起止地址、权限、属性等
/// 主要用于分析进程的内存布局
NSString* vmmap();

