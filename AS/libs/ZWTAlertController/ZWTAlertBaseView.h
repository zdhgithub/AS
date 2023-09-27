//
//  ZWTAlertBaseView.h
//  AlertDemo
//
//  Created by 游兵 on 2019/3/19.
//  Copyright © 2019 游兵. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZWTAlertAction, ZWTTextView;

@interface ZWTAlertBaseView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) NSMutableArray<UIButton *> *otherBtns;

@property (nonatomic, strong) NSArray<ZWTAlertAction *> *actions;
@property (nonatomic, strong) NSArray<UITextField *> *textFields;
@property (nonatomic, strong) NSArray<ZWTTextView *> *textViews;

@property (nonatomic, copy) void(^clickBlock)(void(^completion)(void));

- (UIColor *)getButtonTitleColorWithStyle:(NSInteger)style;
- (UIButton *)createBtn:(ZWTAlertAction *)action tag:(NSInteger)tag;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message clickBlock:(void(^)(void(^completion)(void)))clickBlock;

@end

NS_ASSUME_NONNULL_END
