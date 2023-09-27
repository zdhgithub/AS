//
//  ZWTAlertBaseView.m
//  AlertDemo
//
//  Created by 游兵 on 2019/3/19.
//  Copyright © 2019 游兵. All rights reserved.
//

#import "ZWTAlertBaseView.h"
#import "ZWTAlertController.h"
//#import <ZWTKitColorConfig.h>
//#import <ZWTKitFontConfig.h>
#import "UIColor+XYColor.h"

@implementation ZWTAlertBaseView

- (NSMutableArray<UIButton *> *)setupOtherBtns
{
    if (_otherBtns==nil) {
        _otherBtns = [NSMutableArray array];
    }
    return _otherBtns;
}


- (UILabel *)setupTitleLabel
{
    if (_titleLabel==nil) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)setupMessageLabel
{
    if (_messageLabel==nil) {
        _messageLabel = [UILabel new];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupOtherBtns];
        [self setupTitleLabel];
        [self setupMessageLabel];
    }
    return self;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message clickBlock:(void (^)(void (^ _Nonnull completion)(void)))clickBlock
{
    ZWTAlertBaseView *view = [self new];
//    view.titleLabel.text = title;
    view.messageLabel.text = message;
    [view setClickBlock:clickBlock];
    
    /// 有数字/版本号标红 \d+(\.\d+){0,}
    NSRange range = [title rangeOfString:@"\\d+(\\.\\d+){0,}" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound && [view isKindOfClass:NSClassFromString(@"ZWTAlertView")]) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title ?:@""];
        [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]} range:NSMakeRange(0, title.length)];
        [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ff6725"]} range:range];
        view.titleLabel.attributedText = attr;
    }
    else{
        view.titleLabel.text = title;
    }
    
    return view;
}


- (UIButton *)createBtn:(ZWTAlertAction *)action tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:action.title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.tag = tag;
    [btn setTitleColor:[self getButtonTitleColorWithStyle:action.style] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIColor *)getButtonTitleColorWithStyle:(NSInteger)style
{
    UIColor *titleColor = [UIColor colorWithHexString:@"#666666"];
    if (style==ZWTAlertActionStyleDestructive) {
        titleColor = [UIColor colorWithHexString:@"#ff6726"];
    } else if (style==ZWTAlertActionStyleDefault) {
        titleColor = [UIColor colorWithHexString:@"#0084ff"];
    }
    return titleColor;
}

- (void)click:(UIButton *)btn
{
    ZWTAlertAction *action = self.actions[btn.tag];
    __weak typeof(action) weakAction = action;
    if (self.clickBlock) {
        self.clickBlock(^{
            __strong typeof(weakAction) strongAction = weakAction;
            if (strongAction.handler) {
                strongAction.handler(strongAction);
            }
        });
    }
}

@end
