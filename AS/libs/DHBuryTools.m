
#import "DHBuryTools.h"
#import "mx3app-Swift.h"
#import <MMKV/MMKV.h>
#import "UIDevice+SmartBase.h"

static NSString *appNameDefault = @"Prestapronto";

@implementation DHBuryTools

+ (void)methodmark:(NSString *)methodmark {
    [self methodmark:methodmark appName:appNameDefault];
}
+ (void)methodmark:(NSString *)methodmark appName:(NSString *)appName {
    
    appName = appName ?: appNameDefault;
    NSString *timestamp = [self getCurrentTimeBySecond];
    NSDictionary *dict = @{
        @"appName":appName,
        @"appVersion":UIDevice.sm_appVersion,
        @"deviceBrand":@"iphone",
        @"deviceId":[[UIDevice currentDevice] uuid],
        @"deviceModel": UIDevice.getPhoneDeviceName,
        @"method":methodmark,
        @"sign":[self signStrWithMehodmark:methodmark timestamp:timestamp appName:appName],
        @"timestamp":timestamp
    };
    
    
    NSString *token = [[MMKV defaultMMKV] getStringForKey:@"token"];
    if (token == nil || token.length == 0) return;
    NSDictionary *header = @{
        @"timestamp":timestamp,
        @"token":token,
    };
   
    [DHNetworkTool post:@"/app/insertDetail" params:dict headers:header callback:^(NSString * data, NSString * msg) {
        
    }];
}

+(void)repatMethodmark:(NSString *)method {
    [self repatMethodmark:method appName:appNameDefault];
}

//复贷埋点
+(void)repatMethodmark:(NSString *)repatMethodmark appName:(NSString *)appName {
    [self repatMethodmark:repatMethodmark appName:appName productName:@""];
}

//复贷埋点
+(void)repatMethodmark:(NSString *)repatMethodmark appName:(NSString *)appName productName:(NSString *)productName {
#warning need to change
    NSString * mobile = @"";
    appName = appName ?: appNameDefault;
    
    NSString *timestamp = [self getCurrentTimeBySecond];
    
    NSString *url = @"/repeat/insertDetail";
    if([repatMethodmark isEqualToString:@"refuse_product"] && productName != nil && productName.length > 0){
//        self.paramsDic[@"productName"] = productName;
        url = @"/repeat/insertRefuseDetail";
    }
  
    NSDictionary *dict = @{
        @"appName":appName,
        @"appVersion":UIDevice.sm_appVersion,
        @"deviceBrand":@"iphone",
        @"deviceId":[[UIDevice currentDevice] uuid],
        @"deviceModel": UIDevice.getPhoneDeviceName,
        @"method":repatMethodmark,
        @"sign":[self repatSinngStringWithMethod:repatMethodmark moibil:mobile timestamp:timestamp appName:appName productName:productName],
        @"timestamp":timestamp,
        @"mobile":mobile
    };
    
    NSString *token = [[MMKV defaultMMKV] getStringForKey:@"token"];
    if (token == nil || token.length == 0) return;
    
    NSDictionary *header = @{
        @"timestamp":timestamp,
        @"token":token,
    };
    
 
    [DHNetworkTool post:url params:dict headers:header callback:^(NSString * data, NSString * msg) {
        
    }];
}

//复贷签名
+ (NSString *)repatSinngStringWithMethod:(NSString *)method moibil:(NSString *)mobileStr timestamp:(NSString *)timestamp appName:(NSString *)appName productName:(NSString *)productName {
    NSMutableString * sinStr = [[NSString alloc] initWithFormat:@"appName%@appVersion%@deviceBrandiphonedeviceModel%@method%@mobile%@",appName,UIDevice.sm_appVersion,UIDevice.getPhoneDeviceName,method,mobileStr].mutableCopy;
    
//    productName%@timestamp%@ ,productName?:@"",timestamp
    if([method isEqualToString:@"refuse_product"] && productName != nil && productName.length > 0){
//        [sinStr appendFormat:@"productName%@", productName?:@""];
    }
    [sinStr appendFormat:@"timestamp%@", timestamp];
    
    NSLog(@"%@",sinStr);
    NSString *md5strOne = [self md5To32bit:sinStr];
    NSLog(@"首次加密 == %@",md5strOne);
    NSLog(@"在次加密 == %@",[self md5To32bit:md5strOne]);
    return [self md5To32bit:md5strOne];
}

//获取签名
+ (NSString *)signStrWithMehodmark:(NSString *)methodStr timestamp:(NSString *)timestamp appName:(NSString *)appName {
    
    NSString * sinStr = [[NSString alloc] initWithFormat:@"appName%@appVersion%@deviceBrandiphonedeviceId%@deviceModel%@method%@timestamp%@",appName,UIDevice.sm_appVersion,[[UIDevice currentDevice] uuid],UIDevice.getPhoneDeviceName,methodStr,timestamp];
    
    NSLog(@"%@",sinStr);
    NSString *md5strOne = [self md5To32bit:sinStr];
    NSLog(@"首次加密 == %@",md5strOne);
    NSLog(@"在次加密 == %@",[self md5To32bit:md5strOne]);
    return [self md5To32bit:md5strOne];
}

+ (NSString *)md5To32bit:(NSString *)input {
    
    const char* str = [input UTF8String];
    
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i<CC_MD2_DIGEST_LENGTH;i++){
        
        [ret appendFormat:@"%02x",result[i]];
        
    }
    
    return ret;
    
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%2s",result];
    }
    return ret;
}

+ (NSString *)getCurrentTimeBySecond {
    double currentTime =  [[NSDate date] timeIntervalSince1970];
    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];
    return strTime;
}


@end
