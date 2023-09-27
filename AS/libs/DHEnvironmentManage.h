//
//  DHEnvironmentManage.h
//  Prestapronto
//
//  Created by dh on 2023/3/7.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, SMBuildType) {
    /** debug状态*/
    SMBuild_Debug,
    /** release状态*/
    SMBuild_Release
};

NS_ASSUME_NONNULL_BEGIN
/// 浏阳项目渠道号
#define LYFZ @"ZTLIUYANG"
/// 深投云控渠道号
#define STK @"ZTSHENTOUKONG"
/// 深圳政协渠道号
#define SZZX @"ZTSZZX"
/// 金阳项目渠道号
#define JYFZ @"ZTJINFA"
/// 国资委干教中心渠道号
#define GZW @"ZTGUOZIWEI"

@interface SmartEnvironmentManage : NSObject
#ifdef __cplusplus
extern "C" {
#endif

    
#pragma mark - AK
NSString * SMProjectAK(void);
    
#pragma mark - SK
NSString * SMProjectSK(void);
    
#pragma mark - bucket name
NSString * SMProjectBucketName(void);
    
    
    
#pragma mark - 活动更多链接
NSString * SMProjectActivityMoreUrl(void);
    
#pragma mark - 忘记密码功能
BOOL SMProjectShowForgetPassword(void);
    
#pragma mark - 项目渠道号
/** 获取Project Channel*/
NSString* SMProjectChannel(void);

#pragma mark - 项目名称
/** 获取Project name*/
NSString* SMProjectName(void);
    
#pragma mark - AF_DEV_KEY
/** 获取AF_DEV_KEY*/
    NSString* SMProjectAFDevKey(void);

#pragma mark - APPLE_APP_ID
/** 获取APPLE_APP_ID*/
    NSString* SMProjectAppleAppID(void);
    
    
    
#pragma mark - 项目运行态
/** 获取工程configuration类型*/
 SMBuildType SMBuildConfiguration(void);

#pragma mark - 服务域
    
    
/// 埋点
NSString* SMMDUrl(void);

/// OBSUrl
NSString* SMYOBSUrl(void);
    
/** IM体系URL*/
NSDictionary* SMIMCoreUrl(void);

/** 埋点URL*/
NSString* SMAggregateUrl(void);

/** 永中文件浏览URL*/
NSString* SMYZFileUrl(void);

    //    深投控OA服务器地址
NSString * STKOAUrl(void);

//    深投控认证服务器地址
NSString * STKAuthUrl(void);

/** 获取环境域
 * @param requestKey API对应的Key
 * @return 返回值 URL字符串地址
 */
NSString* SMDomainRequestUrl(NSString *requestKey);

/** 拼接图片http路径
 * @param url 图片的路径
 * @return 返回值 URL字符串地址
 */
NSString* SMDomainImageUrl(NSString *url);

/** 批量拼接图片http路径
 * @param urls 图片的路径
 * @return 拼接完成的 图片URL字符串地址 数组
 */
NSArray* SMDomainImageUrlList(NSArray *urls);

#pragma mark - encrypt
/** 账密登录公钥指数*/
NSString* SMRSAPublicExponent(void);

/** 账密登录公钥模块*/
NSString* SMRSAPublicModulus(void);

/** 3des加解密Key */
NSString* SM3DESKey(void);

/** 哈希加解密key */
NSString* SMHMACSHA1Key(void);



#ifdef __cplusplus
}
#endif

+ (NSString *)zwt_getUMnegAppkey;
+ (NSString *)zwt_getUMnegChannel;
+(NSString *)project;

+ (NSString *)sp_auth_appid;

@end


NS_ASSUME_NONNULL_END
