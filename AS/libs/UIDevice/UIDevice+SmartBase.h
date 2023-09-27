//
//  UIDevice+SmartBase.h
//  SmartBase
//
//  Created by 曹志君 on 2019/9/2.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SmartBase)

#pragma mark - About App Config Info Method
/** 获取当前App的版本号信息 */
+ (NSString *)sm_appVersion;

/** 获取当前App的build版本号信息 */
+ (NSString *)sm_appBuildVersion;

/** 获取当前App的包名信息 */
+ (NSString *)sm_appBundleId;

/** 获取当前App的名称信息 */
+ (NSString *)sm_appDisplayName;


/// 设备id
//+ (NSString *)getPhoneDeviceId;
 
/// 手机版
+ (NSString *)getPhoneVerison;

/// 设备名称
+ (NSString *)getPhoneName;

/// 设备型号
+ (NSString *)getPhoneDeviceName;

///获取运营商名称
+(NSString *)getCarrierName;

@end
