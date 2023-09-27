

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIDevice+FCUUID.h"
//#import "SmartBaseService.h"
//#import "DHUserManger.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHBuryTools : NSObject

+(void)methodmark:(NSString *)methodmark;
+(void)methodmark:(NSString *)methodmark appName:(NSString *)appName;

//复贷
+(void)repatMethodmark:(NSString *)repatMethodmark;
+(void)repatMethodmark:(NSString *)repatMethodmark appName:(NSString *)appName;
+(void)repatMethodmark:(NSString *)repatMethodmark appName:(NSString *)appName productName:(NSString *)productName;



@end

NS_ASSUME_NONNULL_END
