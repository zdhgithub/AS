//
//  ZWTAlertController.h
//  AlertDemo
//
//  Created by 游兵 on 2019/3/19.
//  Copyright © 2019 游兵. All rights reserved.
//

#import "ZWTAlertBaseView.h"
#import "ZWTTextView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZWTAlertActionStyle) {
    ZWTAlertActionStyleDefault = 0,
    ZWTAlertActionStyleCancel,
    ZWTAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, ZWTAlertControllerStyle) {
    ZWTAlertControllerStyleActionSheet = 0,
    ZWTAlertControllerStyleAlert
};

@interface ZWTAlertAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) ZWTAlertActionStyle style;
@property (nonatomic, copy, nullable) void (^handler)(ZWTAlertAction *action);

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(ZWTAlertActionStyle)style handler:(void (^ __nullable)(ZWTAlertAction *action))handler;


@end

@interface ZWTAlertController : UIViewController

@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, strong, readonly) ZWTAlertBaseView *contentView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) void(^touch2dismissBlock)(void);


+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(ZWTAlertControllerStyle)preferredStyle;

- (void)addAction:(ZWTAlertAction *)action;
@property (nonatomic, strong, readonly) NSArray<ZWTAlertAction *> *actions;
- (ZWTAlertAction *)getActionByTitle:(NSString *)title;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

- (void)addTextViewWithConfigurationHandler:(void (^ __nullable)(ZWTTextView *textView))configurationHandler;
@property (nullable, nonatomic, readonly) NSArray<ZWTTextView *> *textViews;



@property (nonatomic, assign, readonly) ZWTAlertControllerStyle preferredStyle;

+ (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttonTitle:(NSString *)buttonTitle;
+ (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttonTitle:(NSString *)buttonTitle textAlignment:(NSTextAlignment)textAlignment;
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                titleArray:(NSArray<NSString *> *)titleArray
              actionHandle:(void (^)(NSInteger index))actionHandle;
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             textAlignment:(NSTextAlignment)textAlignment
                titleArray:(NSArray<NSString *> *)titleArray
              actionHandle:(void (^)(NSInteger index))actionHandle;
+ (void)showSheetWithTitle:(NSString *)title
                   message:(NSString *)message
                titleArray:(NSArray<NSString *> *)titleArray
              actionHandle:(void (^)(NSInteger index))actionHandle;
+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                 textAlignment:(NSTextAlignment)textAlignment
                         style:(UIAlertControllerStyle)style
                    titleArray:(NSArray<NSString *> *)titleArray
                  actionHandle:(void (^)(NSInteger index))actionHandle;


@end

NS_ASSUME_NONNULL_END
