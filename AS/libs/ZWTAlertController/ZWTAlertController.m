//
//  ZWTAlertController.m
//  AlertDemo
//
//  Created by 游兵 on 2019/3/19.
//  Copyright © 2019 游兵. All rights reserved.
//

#import "ZWTAlertController.h"
#import "ZWTActionSheetView.h"
#import "ZWTActionSheetTransitioning.h"
//#import "ZWTKitRectConfig.h"
#import "ZWTAlertView.h"
#import "ZWTAlertTransitioning.h"

@implementation ZWTAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(ZWTAlertActionStyle)style handler:(void (^)(ZWTAlertAction * _Nonnull))handler
{
    ZWTAlertAction *action = [ZWTAlertAction new];
    action.title = title;
    action.style = style;
    action.handler = handler;
    return action;
}

@end

@interface ZWTAlertController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSMutableArray<ZWTAlertAction *> *private_actions;

@property (nonatomic, strong) NSMutableArray<UITextField *> *private_textFields;

@property (nonatomic, strong) NSMutableArray<ZWTTextView *> *private_textViews;


@end

@implementation ZWTAlertController

@dynamic title;

- (NSArray<UITextField *> *)textFields
{
    return self.private_textFields;
}

- (NSArray<ZWTTextView *> *)textViews
{
    return self.private_textViews;
}

- (NSArray<ZWTAlertAction *> *)actions
{
    return self.private_actions;
}

- (NSMutableArray<ZWTAlertAction *> *)private_actions
{
    if (_private_actions==nil) {
        _private_actions = [NSMutableArray array];
    }
    return _private_actions;
}

- (NSMutableArray<UITextField *> *)private_textFields
{
    if (_private_textFields==nil) {
        _private_textFields = [NSMutableArray array];
    }
    return _private_textFields;
}

- (NSMutableArray<ZWTTextView *> *)private_textViews
{
    if (_private_textViews==nil) {
        _private_textViews = [NSMutableArray array];
    }
    return _private_textViews;
}

- (UIView *)bgView
{
    if (_bgView==nil) {
        _bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.frame = self.view.bounds;
    }
    return _bgView;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    self.contentView.messageLabel.textAlignment = textAlignment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview:self.bgView atIndex:0];
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(ZWTAlertControllerStyle)preferredStyle
{
    if (self=[super init]) {
        self.title = title;
        self.message = message;
        _preferredStyle = preferredStyle;
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self _setupUI];
    }
    return self;
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(ZWTAlertControllerStyle)preferredStyle
{
    return [[ZWTAlertController alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (void)addAction:(ZWTAlertAction *)action
{
    [self.private_actions addObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler
{
    UITextField *tf = [UITextField new];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    if (configurationHandler) {
        configurationHandler(tf);
    }
    [self.private_textFields addObject:tf];
}

- (void)addTextViewWithConfigurationHandler:(void (^)(ZWTTextView * _Nonnull))configurationHandler
{
    ZWTTextView *tv = [ZWTTextView new];
    if (configurationHandler) {
        configurationHandler(tv);
    }
    [self.private_textViews addObject:tv];
}

- (void)_setupUI
{
    Class cls = ZWTAlertBaseView.class;
    if (self.preferredStyle==ZWTAlertControllerStyleActionSheet) {
        cls = ZWTActionSheetView.class;
    } else if (self.preferredStyle==ZWTAlertControllerStyleAlert) {
        cls = ZWTAlertView.class;
    }
    
    __weak typeof(self) weakSelf = self;
    _contentView = [cls alertWithTitle:self.title message:self.message clickBlock:^(void (^ _Nonnull completion)(void)) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:^{
            if (completion) {
                completion();
            }
        }];
    }];
    [self.view addSubview:self.contentView];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if (self.preferredStyle==ZWTAlertControllerStyleAlert) {
        return [ZWTAlertTransitioning new];
    } else {
        return [[ZWTActionSheetTransitioning alloc] init];
    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (self.preferredStyle==ZWTAlertControllerStyleAlert) {
        return [ZWTAlertTransitioning new];
    } else {    
        return [[ZWTActionSheetTransitioning alloc] init];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.preferredStyle==ZWTAlertControllerStyleActionSheet) {
        if (_touch2dismissBlock) {
            _touch2dismissBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    [self showAlertWithTitle:title message:message buttonTitle:buttonTitle textAlignment:NSTextAlignmentCenter];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle textAlignment:(NSTextAlignment)textAlignment
{
    [self showAlertWithTitle:title message:message titleArray:@[buttonTitle] actionHandle:nil];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                titleArray:(NSArray<NSString *> *)titleArray
              actionHandle:(void (^)(NSInteger index))actionHandle {
    [self showAlertWithTitle:title
                            message:message
                      textAlignment:NSTextAlignmentCenter
                         titleArray:titleArray
                       actionHandle:actionHandle];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             textAlignment:(NSTextAlignment)textAlignment
                titleArray:(NSArray<NSString *> *)titleArray
              actionHandle:(void (^)(NSInteger index))actionHandle {
    ZWTAlertController *alert = [self alertWithTitle:title
                                             message:message
                                       textAlignment:textAlignment
                                               style:UIAlertControllerStyleAlert
                                          titleArray:titleArray
                                        actionHandle:actionHandle];
    [[self alert_getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}

+ (void)showSheetWithTitle:(NSString *)title
                   message:(NSString *)message
                titleArray:(NSArray<NSString *> *)titleArray
              actionHandle:(void (^)(NSInteger index))actionHandle {
    ZWTAlertController *alert = [self alertWithTitle:title
                                             message:message
                                       textAlignment:NSTextAlignmentCenter
                                               style:UIAlertControllerStyleActionSheet
                                          titleArray:titleArray
                                        actionHandle:actionHandle];
    [[self alert_getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}

/** 统一创建方法 */
+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                 textAlignment:(NSTextAlignment)textAlignment
                         style:(UIAlertControllerStyle)style
                    titleArray:(NSArray<NSString *> *)titleArray
                  actionHandle:(void (^)(NSInteger index))actionHandle {
    
    ZWTAlertController *alert = [ZWTAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:style];
    alert.textAlignment = textAlignment;
    
    for (NSInteger i = 0; i < titleArray.count; i++) {
        ZWTAlertActionStyle actionStyle = ZWTAlertActionStyleDefault;
        NSString *buttonTitle = titleArray[i];
        if([buttonTitle isEqualToString:@"取消"] || [buttonTitle isEqualToString:@"Cancel"] || [buttonTitle isEqualToString:@"Cancelar"]) {
            actionStyle = ZWTAlertActionStyleCancel;
        }
        if([buttonTitle isEqualToString:@"取消收藏"] || [buttonTitle containsString:@"删除"] || [buttonTitle containsString:@"Confirmar"]) {
            actionStyle = ZWTAlertActionStyleDestructive;
        }
        ZWTAlertAction *confirm = [ZWTAlertAction actionWithTitle:titleArray[i]
                                                            style:actionStyle
                                                          handler:^(ZWTAlertAction * _Nonnull action) {
                                                              if (actionHandle) {
                                                                  actionHandle(i);
                                                              }
                                                          }];
        [alert addAction:confirm];
    }
    
    if (style == ZWTAlertControllerStyleActionSheet && ![titleArray containsObject:@"取消"]) {
        ZWTAlertAction *cancelAction = [ZWTAlertAction actionWithTitle:@"取消" style:ZWTAlertActionStyleCancel handler:^(ZWTAlertAction * _Nonnull action) {
            if (actionHandle) {
                actionHandle(titleArray.count);
            }
        }];
        [alert addAction:cancelAction];
    }
    
    return alert;
}

/**
 展示弹框
 */
- (void)zwt_showAlert {
    [[ZWTAlertController alert_getCurrentViewController] presentViewController:self animated:YES completion:nil];
}

#pragma mark - private
/** 获取当前controller */
+ (UIViewController *)alert_getCurrentViewController {
    //获得当前活动窗口的根视图
    UIViewController* vc = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    while (1) {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

- (ZWTAlertAction *)getActionByTitle:(NSString *)title {
    ZWTAlertAction *act = nil;
    for (ZWTAlertAction *action in self.actions) {
        if ([action.title isEqualToString:title]) {
            act = action;
            break;
        }
    }
    return act;
}

@end
