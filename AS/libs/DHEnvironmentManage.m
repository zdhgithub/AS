//
//  DHEnvironmentManage.m
//  Prestapronto
//
//  Created by dh on 2023/3/7.
//

#import "DHEnvironmentManage.h"

/// 活动 更多跳转链接
#define kActivityMoreKey @"activity_more"
/// 是否有忘记密码功能
#define kForgetPasswordKey @"is_forget_password"


#define kAccessKey @"AK"
#define kSecretKey @"SK"
#define kOBSBucketKey @"obs_bucket"


/*---项目渠道---*/
#define kProjectChannelKey @"project_channel"
/*---项目名称---*/
#define kProjectNameKey @"project_name"
/*---工程组态---*/
#define kBulidTypeKey @"bulid_configuration"
/*------*/
/*---服务主机---*/
#define kServiceHostKey @"service_host"
/*---*/
#define kUMHostKey @"um_host"
#define kMDHostKey @"md_host"
#define kOBSHostKey @"obs_host"

#define kMeetHostKey @"meeting_host"
#define kScheduleHostKey @"schedule_host"
#define kPublicHostKey @"public_host"
#define kMtroomHostKey @"mtroom_host"
#define kHolidayHostKey @"holiday_host"
#define kCoreHostKey @"core_host"
#define kEventHostKey @"event_host"
#define kFileHostKey @"file_host"
#define kProposalHostKey @"proposal_host"
#define kSTKAuthHostKey @"stk_auth"

#define kMXMDHostKey @"md_host"

#define kOAHostKey @"oa_host"

/// 全会日程 对接正宇接口
#define kQHPlanHostKey @"qh_plan_host"
/*------*/
/*---加解密相关---*/
#define kEncryptKey @"encrypt"
/*---*/
#define kRsaExponentKey @"rsa_public_exponent"
#define kRsaModulusKey @"rsa_public_modulus"
#define k3DesZWTKey @"3des_key"
#define kHmacsha1ZWTKey @"hmacsha1_key"
/*------*/

@implementation NSDictionary (SmartNetwork)
    
- (NSString *)sm_stringForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}
    
- (NSDictionary *)sm_dictionaryForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    
    return nil;
}
    
@end

static NSString *_bulidConfiguration = nil;
static NSDictionary *_configDict = nil;
static NSDictionary *_serviceDomainDict = nil;
static NSDictionary *_encryptDict = nil;
static NSString *_projectChannel = nil;
static NSString *_projectName = nil;


@interface SmartEnvironmentManage ()

@property (nonatomic, readonly, class) NSString *bulidConfiguration;
@property (nonatomic, readonly, class) NSDictionary *configDict;
@property (nonatomic, readonly, class) NSDictionary *serviceDomainDict;
@property (nonatomic, readonly, class) NSDictionary *encryptDict;
@property (nonatomic, readonly, class) NSString *projectChannel;
@property (nonatomic, readonly, class) NSString *projectName;

@end

@implementation SmartEnvironmentManage

#pragma mark - AK
NSString * SMProjectAK(void) {
    return SmartEnvironmentManage.getAk;
}
#pragma mark - SK
NSString * SMProjectSK(void) {
    return SmartEnvironmentManage.getSK;
}
#pragma mark - bucket name
NSString * SMProjectBucketName(void) {
    return SmartEnvironmentManage.OBSBucketName;
}

#pragma mark - 活动更多链接
NSString * SMProjectActivityMoreUrl(void) {
    return SmartEnvironmentManage.activityMoreUrl;
}

#pragma mark - 忘记密码功能
BOOL SMProjectShowForgetPassword(void) {
    return SmartEnvironmentManage.showForgetPassword;
}

#pragma mark - 项目渠道
/** 获取Project Channel*/
NSString* SMProjectChannel(void) {
    return SmartEnvironmentManage.projectChannel;
}

#pragma mark - 项目名称
/** 获取Project name*/
NSString* SMProjectName(void) {
    return SmartEnvironmentManage.projectName;
}

#pragma mark - AF_DEV_KEY
/** 获取AF_DEV_KEY*/
NSString* SMProjectAFDevKey(void) {
    return SmartEnvironmentManage.afDevKey;
}

#pragma mark - APPLE_APP_ID
/** 获取APPLE_APP_ID*/
NSString* SMProjectAppleAppID(void) {
    return SmartEnvironmentManage.appleAPPID;
}

#pragma mark - 项目运行态
/** 获取工程configuration类型*/
 SMBuildType SMBuildConfiguration(void) {
    //默认为Debug
    SMBuildType type = SMBuild_Debug;
    
    if([SmartEnvironmentManage.bulidConfiguration isEqualToString:@"debug"]) {
        type = SMBuild_Debug;
    }else if([SmartEnvironmentManage.bulidConfiguration isEqualToString:@"release"]) {
        type = SMBuild_Release;
    }
    return type;
}

#pragma mark - 服务主机

/// 埋点
NSString* SMMDUrl(void) {
    NSString *aggregateUrl = [SmartEnvironmentManage.serviceDomainDict sm_stringForKey:kMDHostKey];;
    return aggregateUrl;
}

/// OBSUrl
NSString* SMYOBSUrl(void) {
    NSString *yzFileUrl = [SmartEnvironmentManage.serviceDomainDict sm_stringForKey:kOBSHostKey];;
    return yzFileUrl;
}


/** IM体系URL*/
NSDictionary* SMIMCoreUrl(void) {
    NSDictionary *iMCoreDict = [SmartEnvironmentManage.serviceDomainDict sm_dictionaryForKey:kCoreHostKey];
    return iMCoreDict;
}

/** 埋点URL*/
NSString* SMAggregateUrl(void) {
    NSString *aggregateUrl = [SmartEnvironmentManage.serviceDomainDict sm_stringForKey:kEventHostKey];;
    return aggregateUrl;
}

/** 永中文件浏览URL*/
NSString* SMYZFileUrl(void) {
    NSString *yzFileUrl = [SmartEnvironmentManage.serviceDomainDict sm_stringForKey:kFileHostKey];;
    return yzFileUrl;
}

//    深投控OA服务器地址
NSString * STKOAUrl(void){
    NSString *temp = [SmartEnvironmentManage.serviceDomainDict sm_stringForKey:kOAHostKey];;
    return temp;
}
//    竹云服务器地址
NSString * STKAuthUrl(void){
    NSString *temp = [SmartEnvironmentManage.serviceDomainDict sm_stringForKey:kSTKAuthHostKey];;
    return temp;
}
/** 获取环境域
 * @param requestKey API对应的Key
 * @return 返回值 URL字符串地址
 */
NSString* SMDomainRequestUrl(NSString *requestKey) {
    
    if(requestKey == nil) {
        requestKey = @"";
    }
    
    NSString *serviceHostKey = kUMHostKey;//um体系
    if(requestKey.length > 0) {
        if([requestKey hasPrefix:@"/HMP"]) {
            serviceHostKey = kPublicHostKey;//公众号体系
        }else if([requestKey hasPrefix:@"/peimcmeeting"]) {
            serviceHostKey = kMeetHostKey;//会议体系
        }else if([requestKey hasPrefix:@"/schedule"]) {
            serviceHostKey = kScheduleHostKey;//日程体系
        }else if([requestKey hasPrefix:@"/mtroom"]) {
            serviceHostKey = kMtroomHostKey;//mtroom
        }else if([requestKey hasPrefix:@"/holiday"]) {
            serviceHostKey = kHolidayHostKey;//请休假体系
        }else if([requestKey hasPrefix:@"/proposal"]) {
            serviceHostKey = kProposalHostKey;
        }else if([requestKey hasPrefix:@"/sz-szzx"]) {
            serviceHostKey = kQHPlanHostKey;
        }else if([requestKey hasPrefix:@"/app/insertDetail"]|| [requestKey hasPrefix:@"/repeat/insertDetail"]) {
            serviceHostKey = kMXMDHostKey;
        }
        else if([requestKey hasPrefix:@"/prod-api/"]
                 || [requestKey hasPrefix:@"/stk-oa-h5/#"]
                || [requestKey hasPrefix:@"/stk-oa-phone/todolist"]){
            serviceHostKey = kOAHostKey;
        }
    }
    
    NSString *requestDommain = SmartEnvironmentManage.serviceDomainDict[serviceHostKey];
//    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",requestDommain,requestKey];
    if(![requestKey hasPrefix:@"http"] && requestKey.length > 0){
        if ([requestKey hasPrefix:@"/"]) {
            return [NSString stringWithFormat:@"%@%@",requestDommain,requestKey];
        }else{
            return [NSString stringWithFormat:@"http://%@",requestKey];
        }
    }
    if (requestKey.length == 0) {
        return requestDommain;
    }
    
    return requestKey;
}

/** 拼接图片http路径
 * @param url 图片的路径
 * @return 返回值 URL字符串地址
 */
NSString* SMDomainImageUrl(NSString *url) {
    
    NSString *serviceHostKey = kUMHostKey;//um体系
    NSString *requestDommain = SmartEnvironmentManage.serviceDomainDict[serviceHostKey];
//    NSString *pathPrefix = @"userplatforms/rest/file/download?url=";
//    NSString *fileDomain = [NSString stringWithFormat:@"%@/%@",requestDommain,pathPrefix];
    NSString *fileDomain = [NSString stringWithFormat:@"%@/",requestDommain];
    if(!url || url.length == 0) return @"";
    
    BOOL isHttpPrefix = [url hasPrefix:@"http"];
    if(!isHttpPrefix) {
        return [NSString stringWithFormat:@"%@%@",fileDomain,url];;
    }
    
    return url;
}

/** 批量拼接图片http路径
 * @param urls 图片的路径
 * @return 拼接完成的 图片URL字符串地址 数组
 */
NSArray* SMDomainImageUrlList(NSArray *urls) {
    NSMutableArray *list = [NSMutableArray array];
    for(NSString *urlStr in urls) {
        [list addObject:SMDomainImageUrl(urlStr)];
    }
    return list;
}

#pragma mark - encrypt
/** 账密登录公钥指数*/
NSString* SMRSAPublicExponent(void) {
    return [SmartEnvironmentManage.encryptDict sm_stringForKey:kRsaExponentKey];
}

/** 账密登录公钥模块*/
NSString* SMRSAPublicModulus(void) {
    return [SmartEnvironmentManage.encryptDict sm_stringForKey:kRsaModulusKey];
}

/** 3des加解密Key */
NSString* SM3DESKey(void) {
    return [SmartEnvironmentManage.encryptDict sm_stringForKey:k3DesZWTKey];;
}

/** 哈希加解密key */
NSString* SMHMACSHA1Key(void) {
    return [SmartEnvironmentManage.encryptDict sm_stringForKey:kHmacsha1ZWTKey];
}

NSDictionary *ZWTEnvironmentDict(void) {
    NSString *environmentPath = [[NSBundle mainBundle] pathForResource:@"ZWTEnvironment" ofType:@"plist"];
        NSDictionary *environmentDict = [NSDictionary dictionaryWithContentsOfFile:environmentPath];
//    NSDictionary *environmentDict = [SMProfileDecryptor decodeResourceFilePath:environmentPath fileType:SMProfileTypePlist];
    return environmentDict;
}
+(NSString *)project {
    NSDictionary *environmentDict = ZWTEnvironmentDict();
    NSString *project = environmentDict[@"project"];
    return project;
}

+(NSString *)afDevKey {
    NSDictionary *environmentDict = ZWTEnvironmentDict();
    NSString *project = environmentDict[@"AF_DEV_KEY"];
    return project;
}

+(NSString *)appleAPPID {
    NSDictionary *environmentDict = ZWTEnvironmentDict();
    NSString *project = environmentDict[@"APPLE_APP_ID"];
    return project;
}
#pragma mark - getter
+ (NSDictionary *)configDict {
    if(_configDict == nil) {
        
        NSString *project = [self project];
//        NSDictionary *configNameDict = environmentDict[@"configs"];
//        /*----------*/
//        NSDictionary *domainDict = configNameDict[project];
//        NSString *configName = [domainDict sm_stringForKey:SmartEnvironmentManage.bulidConfiguration];
        NSString *configPath = [[NSBundle mainBundle] pathForResource:project ofType:@"plist"];
        
        _configDict = [NSDictionary dictionaryWithContentsOfFile:configPath];
//        _configDict = [SMProfileDecryptor decodeResourceFilePath:configPath fileType:SMProfileTypePlist];
    }
    return _configDict;
}

+ (NSString *)getAk {
    return [SmartEnvironmentManage.configDict sm_stringForKey:kAccessKey];
}

+ (NSString *)getSK {
    return [SmartEnvironmentManage.configDict sm_stringForKey:kSecretKey];
}

+ (NSString *)OBSBucketName {
    return [SmartEnvironmentManage.configDict sm_stringForKey:kOBSBucketKey];
}

+ (BOOL)showForgetPassword {
    return [SmartEnvironmentManage.configDict sm_stringForKey:kForgetPasswordKey].boolValue;
}

+ (NSString *)activityMoreUrl {
    return [SmartEnvironmentManage.configDict sm_stringForKey:kActivityMoreKey];
}

+ (NSString *)projectChannel {
    if(_projectChannel == nil) {
        _projectChannel = [SmartEnvironmentManage.configDict sm_stringForKey:kProjectChannelKey];
    }
    return _projectChannel;
}

+ (NSString *)projectName {
    if(_projectName == nil) {
        _projectName = [SmartEnvironmentManage.configDict sm_stringForKey:kProjectNameKey];
    }
    return _projectName;
}

+ (NSString *)bulidConfiguration {
    if(_bulidConfiguration == nil) {
        NSString *environmentPath = [[NSBundle mainBundle] pathForResource:@"ZWTEnvironment" ofType:@"plist"];
        NSDictionary *environmentDict = [NSDictionary dictionaryWithContentsOfFile:environmentPath];
//        NSDictionary *environmentDict = [SMProfileDecryptor decodeResourceFilePath:environmentPath fileType:SMProfileTypePlist];
        /*----------*/
        _bulidConfiguration = [environmentDict sm_stringForKey:kBulidTypeKey];
    }
    return _bulidConfiguration?:@"debug";
}

+ (NSDictionary *)serviceDomainDict {
    
    if(_serviceDomainDict == nil) {
        _serviceDomainDict = [SmartEnvironmentManage.configDict sm_dictionaryForKey:kServiceHostKey];;
    }
    
    return _serviceDomainDict;
}

+ (NSDictionary *)encryptDict {
    if(_encryptDict == nil) {
        _encryptDict = [SmartEnvironmentManage.configDict sm_dictionaryForKey:kEncryptKey];
    }
    return _encryptDict;
}

+ (NSString *)zwt_getUMnegAppkey {
    return [[SmartEnvironmentManage.configDict sm_dictionaryForKey:@"UMeng"] sm_stringForKey:@"Appkey"];
}

+ (NSString *)zwt_getUMnegChannel {
    return [[SmartEnvironmentManage.configDict sm_dictionaryForKey:@"UMeng"] sm_stringForKey:@"Channel"];
}

+ (NSString *)sp_auth_appid{
    if ([[self project] isEqualToString:@"stk_prd"]) {
        return @"PAIAPP_654eb29ac72243f";
    }
    return @"PAIAPP";
}

@end
