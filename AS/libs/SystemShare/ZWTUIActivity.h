//
//  ZWTUIActivity.h
//  ZWTCommonWebVC
//
//  Created by 李名扬 on 2019/1/23.
//  Copyright © 2019 李名扬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWTUIActivity : UIActivity

- (instancetype)initWithTitle:(NSString *)title activityImage:(UIImage *)image linkUrl:(NSURL *)url ActivityType:(NSString *)activityType;

@end

NS_ASSUME_NONNULL_END
