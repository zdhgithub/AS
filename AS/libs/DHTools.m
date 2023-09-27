//
//  DHTools.m
//  mx2app
//
//  Created by dh on 10/12/22.
//

#import "DHTools.h"
#import <ContactsUI/ContactsUI.h>
#import <objc/runtime.h>
//#import <GBDeviceInfo/GBDeviceInfo.h>
#include <mach/mach.h>
#include <mach/mach_time.h>

@implementation DHTools

void dh_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

//+(void)showupdateViewShouldToast:(BOOL)showToast {
//    DHConfigModel *config = [DHNetworkTool getConfig];
//
//    NSUInteger updateType = config.app_update_type_ios.integerValue;
//
//    NSUInteger version = [config.app_version_ios stringByReplacingOccurrencesOfString:@"\\." withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, config.app_version_ios.length)].integerValue;
//    NSUInteger version_old = [UIDevice.sm_appVersion stringByReplacingOccurrencesOfString:@"\\." withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, UIDevice.sm_appVersion.length)].integerValue;
//
//    if(showToast){
//        if(version > version_old){
//            DHUpdateAppView *view = [DHUpdateAppView new];
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            view.frame = window.bounds;
//            [window addSubview:view];
//        }else{
//            [ZWTProgressHUD zwt_showMessage:@"Astual es la última versión"];//已经是最新版本
//        }
//    }else{
//        if((updateType == 1 || updateType == 2) && version > version_old){
//            DHUpdateAppView *view = [DHUpdateAppView new];
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            view.frame = window.bounds;
//            [window addSubview:view];
//        }
//    }
//}

//+(void)upContacts {
//
//    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
//    if (status == CNAuthorizationStatusAuthorized) {
//        //有权限时
//        // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
//        NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
//        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
//        CNContactStore *contactStore = [[CNContactStore alloc] init];
//
//        NSMutableArray *arrm = [NSMutableArray array];
////        NSTimeInterval timeInterval = [NSDate.date timeIntervalSince1970] * 1000;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
//                NSLog(@"-------------------------------------------------------");
//                NSString *givenName = contact.givenName;
//                NSString *familyName = contact.familyName;
//    //            NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
//                NSString *name = [NSString stringWithFormat:@"%@%@", familyName, givenName];
//
//
//                NSArray *phoneNumbers = contact.phoneNumbers;
//                for (CNLabeledValue *labelValue in phoneNumbers) {
//    //                NSString *label = labelValue.label;
//                    CNPhoneNumber *phoneNumber = labelValue.value;
//                    NSString *phone = phoneNumber.stringValue;
//    //                NSLog(@"label=%@, phone=%@", label, phoneNumber.stringValue);
//                    [arrm addObject:@{@"name":name, @"phone":phone, @"uptime":@0, @"ctime":@0, @"times_contacted":@(0),@"last_time_contacted":@0,@"source":@"40"}];
//                }
//                //  *stop = YES; // 停止循环，相当于break；
//            }];
//            NSData *data = [NSJSONSerialization dataWithJSONObject:arrm.copy options:NSJSONWritingFragmentsAllowed error:nil];
//            NSString *jsonStr = [[NSString alloc] initWithData:data encoding:4];
//            NSDictionary *dict = @{
//                @"fileType": @"contact", //文件类型,contact:通讯录,calendar:日历,app:软件,sms:短信
//                @"saveType": @"current", //存储类型,current:最新的,original:最原始的
//                @"grantContent": jsonStr //内容，json字符串
//            };
////            [DHNetworkTool saveGrantInfoWithParams:dict callback:^(BOOL ret, NSString * _Nonnull msg) {
////
////            }];
//        });
//    }
//
//}
//
+(void)upMobileInfo {
//    /// 重置手机系统的时区
//    [NSTimeZone resetSystemTimeZone];
//    ///获取距离0时区偏差的时间
//    NSInteger offset = [NSTimeZone localTimeZone].secondsFromGMT;
//    offset = offset/3600;  //+8 东八区, -8 西八区
//    NSString *tzStr = [NSString stringWithFormat:@"%ld", (long)offset];
//    NSString *timeZoneName = [NSTimeZone localTimeZone].name;
//
//    NSString *networkType = @"unKnown";
//    ReachabilityStatus status = [[RealReachability sharedInstance] currentReachabilityStatus];
//    if(status == RealStatusViaWiFi){
//        networkType = @"wifi";
//    }else if(status == RealStatusViaWWAN){
//        WWANAccessType type = [[RealReachability sharedInstance] currentWWANtype];
//        if (type == WWANType4G) {
//            networkType = @"4G";
//        } else if (type == WWANType3G) {
//            networkType = @"3G";
//        } else if (type == WWANType2G) {
//            networkType = @"2g";
//        }else{
//            networkType = @"5G";
//        }
//    }
//    //     获取当前剩余电量, 我们通常采用上述方法。这也是苹果官方文档提供的。
//    //    它返回的是0.00-1.00之间的浮点值。 另外, -1.00表示模拟器。
//    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
//    double deviceLevel = [UIDevice currentDevice].batteryLevel * 100;
//
//
//    GBDeviceDisplay dispaly = GBDeviceInfo.deviceInfo.displayInfo.display;
//    NSString *physical_size = @"unknown";
//    switch (dispaly) {
//        case GBDeviceDisplay3p5Inch:physical_size = @"3.5"; break;
//        case GBDeviceDisplay4Inch:physical_size = @"4"; break;
//        case GBDeviceDisplay4p7Inch:physical_size = @"4.7"; break;
//        case GBDeviceDisplay5p4Inch:physical_size = @"5.4"; break;
//        case GBDeviceDisplay5p5Inch:physical_size = @"5.5"; break;
//        case GBDeviceDisplay5p8Inch:physical_size = @"5.8"; break;
//        case GBDeviceDisplay6p1Inch:physical_size = @"6.1"; break;
//        case GBDeviceDisplay6p5Inch:physical_size = @"6.5"; break;
//        case GBDeviceDisplay6p7Inch:physical_size = @"6.7"; break;
//        case GBDeviceDisplay7p9Inch:physical_size = @"7.9"; break;
//        case GBDeviceDisplay8p3Inch:physical_size = @"8.3"; break;
//        case GBDeviceDisplay9p7Inch:physical_size = @"9.7"; break;
//        case GBDeviceDisplay10p2Inch:physical_size = @"10.2"; break;
//        case GBDeviceDisplay10p5Inch:physical_size = @"10.5"; break;
//        case GBDeviceDisplay10p9Inch:physical_size = @"10.9"; break;
//        case GBDeviceDisplay11Inch:physical_size = @"11"; break;
//        case GBDeviceDisplay12p9Inch:physical_size = @"12.9"; break;
//        default:
//            break;
//    }
//
//    int64_t change2MB = 1024*1024.0;
//
//
//    NSDictionary *dict = @{
//        //        "imei1": "867701044265028", //第一张sim卡imei
//        //        "imei2": "867701044265029", //第二张sim卡imei
//        //        "serialNumber": "11111", //验证码
//        @"gaid": [[UIDevice currentDevice] uuid], //Google Advertising ID
//        @"android_id": [[UIDevice currentDevice] uuid], //Android ID
//        //        "latitude": "-111.017582", //维度
//        //        "longitude": "29.12265", //经度
//        @"os_release": UIDevice.getPhoneVerison, //安卓版本号
//        @"physical_size": physical_size, //手机屏幕尺寸
//        @"model": UIDevice.getPhoneDeviceName, //手机型号
//        @"is_simulator": @0, //是否是模拟器，0-否 1-是
//        @"is_root": @0,//@(GBDeviceInfo.deviceInfo.isJailbroken), //是否已roo他，0-否 1-是
//        @"device_name": UIDevice.getPhoneName, //设备名称
//        @"brand": @"iPhone", //手机品牌
//        @"time_zone": timeZoneName,//@"America/Phoenix", //时区
//        @"network": networkType, //网络类型
//        @"height": @(ZWTWindowHeight), //分辨率高度
//        @"width": @(ZWTWindowWidth), //分辨率宽度
//        @"cpu_num": @(GBDeviceInfo.deviceInfo.cpuInfo.numberOfCores), //Cpu核数
//        @"memory": [NSString stringWithFormat:@"%.0lfMB",GBDeviceInfo.deviceInfo.physicalMemory*1024.0], //内存大小，单位MB 例 2MB
//        @"network_carrier": UIDevice.getCarrierName ?: @"", //运营商名字
//        //        @"app_max_memory": @"256MB", //app最大占用内存，单位MB例 2MB
//        //        @"app_available_memory": @"18.49MB", //app当前可用内存，单位MB例 2MB
//        //        @"app_free_memory": @"7.09MB", //app可释放内存，单位MB例 2MB
//        @"total_boot_time": @(NSProcessInfo.processInfo.systemUptime*1000*1000), //开机总时长 单位微妙
//        //        @"total_boot_time_wake": @"50051175",
//
//        @"battery_max": @100, //最大电量，百分比
//        @"battery_level": @(deviceLevel), //剩余电量，百分比
//        @"ram_total_size": [NSString stringWithFormat:@"%lldMB",SmartBaseTools.sm_totalMemory/change2MB], //内存总大小，单位MB例 2MB
//        @"ram_usable_size": [NSString stringWithFormat:@"%lldMB",SmartBaseTools.sm_freeMemory/change2MB], //内存可用大小，单位MB例 2MB
//        //        @"memory_card_size": @"24.85GB", //外置存储空间大小，单位MB例 2MB
//        //        @"memory_card_size_use": @"20.92GB", //外置存储空间已用大小，单位MB例 2MB
//        @"internal_storage_total": [NSString stringWithFormat:@"%lldMB",SmartBaseTools.sm_totalDiskSpace/change2MB], //内置存储空间总大小，单位MB例 2MB
//        @"internal_storage_usable": [NSString stringWithFormat:@"%lldMB",SmartBaseTools.sm_freeDiskSpace/change2MB], //内置存储空间可用大小，单位MB例 2MB
//        //        @"contain_sd": @"2MB", //是否有外置存储空间，单位MB例 2MB
//        @"language": [[NSLocale currentLocale] localeIdentifier]//@"es-MX" //手机语言
//        //        [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] //zh-Hans-CN
//    };
//    [DHNetworkTool saveMobileInfoWithParams:dict callback:^(BOOL ret, NSString * _Nonnull msg) {
//        if(ret){
//            [DHBuryTools methodmark:@"device"];
//        }
//    }];
}

//-(long long)getAllTime {
//    long long tm = mach_absolute_time();
//    static mach_timebase_info_data_t    sTimebaseInfo;
//    if ( sTimebaseInfo.denom == 0 ){ //静态整型变量初始化时默认为0
//        mach_timebase_info(&sTimebaseInfo);
//    }
//    return tm * sTimebaseInfo.numer / sTimebaseInfo.denom  / (1000*1000);
//}
//-(long)getSystemUptime{
//    struct timespec ts;
//    if (@available(ios 10.0,*)) {
//        clock_gettime(CLOCK_MONOTONIC, &ts);
//    } else {
//        // Fallback on earlier versions
//    }
//    return ts.tv_sec;
//}
//
//+(void)resetTabBar {
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
////    window.rootViewController = nil;
////    ZWTNavigationController *nav = [[ZWTNavigationController alloc] initWithRootViewController:[DHMainTabbarManage.new setupMainTabbar]];
////    nav.navigationBar.hidden = YES;
//    UITabBarController *tab = [DHMainTabbarManage.new setupMainTabbar];
//    window.rootViewController = tab;
//}

@end
