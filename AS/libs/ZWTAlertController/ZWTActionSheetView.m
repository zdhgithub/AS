//
//  ZWTActionSheetView.m
//  AlertDemo
//
//  Created by 游兵 on 2019/3/19.
//  Copyright © 2019 游兵. All rights reserved.
//

#import "ZWTActionSheetView.h"
#import "ZWTAlertController.h"
#import "UIView+ZWTKit.h"
//#import "ZWTKitRectConfig.h"
//#import <ZWTKitColorConfig.h>
//#import <ZWTKitFontConfig.h>
#import "UIView+ZWTKit.h"
#import "UIColor+XYColor.h"
#import "AS-Swift.h"

#define SMActionSheetCornerRadius 12.0f
#define dhScreenHeight UIScreen.mainScreen.bounds.size.height
#define dhScreenWidth UIScreen.mainScreen.bounds.size.width

#define isIPhoneX (((dhScreenHeight/dhScreenWidth)*100 == 216) ? true : false)
#define dhTabBarHeight (isIPhoneX ? (49+34) : 49)
#define dhBottomBarHeight (isIPhoneX ? 34 : 0)

@interface ZWTActionSheetView ()

@property (nonatomic, strong) UIView *titleBgView;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, assign, readonly, getter=isContainsCancelStyle) BOOL containsCancelStyle;

@end

@implementation ZWTActionSheetView

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
        self.backgroundColor = [UIColor colorWithHexString:@"#f4f5f7"];
        [self addSubview:self.titleBgView];

        [self.titleBgView addSubview:self.titleLabel];
        [self.titleBgView addSubview:self.messageLabel];
        
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.titleLabel.numberOfLines = 0;
        self.messageLabel.font = [UIFont systemFontOfSize:13];
        self.messageLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return self;
}

- (BOOL)isContainsCancelStyle
{
    __block BOOL result = NO;
    [self.actions enumerateObjectsUsingBlock:^(ZWTAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.style==ZWTAlertActionStyleCancel) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

- (UIView *)titleBgView
{
    if (_titleBgView==nil) {
        _titleBgView = [UIView new];
        _titleBgView.backgroundColor = [UIColor whiteColor];
    }
    return _titleBgView;
}

- (UIColor *)getButtonTitleColorWithStyle:(NSInteger)style
{
    UIColor *titleColor = [UIColor colorWithHexString:@"#333333"];
    if (style==ZWTAlertActionStyleDestructive) {
        titleColor = [UIColor colorWithHexString:@"#ff6726"];
    }
    return titleColor;
}

- (void)setActions:(NSArray<ZWTAlertAction *> *)actions
{
    [super setActions:actions];
    
    [actions enumerateObjectsUsingBlock:^(ZWTAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.style==ZWTAlertActionStyleCancel) {
            self.cancelBtn = [self createBtn:obj tag:idx];
            [self addSubview:self.cancelBtn];
        } else {
            UIButton *otherBtn = [self createBtn:obj tag:idx];
            [self addSubview:otherBtn];
            [self.otherBtns addObject:otherBtn];
        }
    }];
    
    [self setupFrame];
}

- (void)setupFrame
{
    [self zwt_setCornerByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(SMActionSheetCornerRadius, SMActionSheetCornerRadius)];
    
    __block NSInteger maxY = 0;
    if (self.titleLabel.text.length) {
        CGFloat height = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frameWidth-50*2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size.height+1;
        
        self.titleLabel.frameX = 50;
        self.titleLabel.frameY = 16;
        self.titleLabel.frameWidth = self.frameWidth-100;
        self.titleLabel.frameHeight = height;
        
        self.titleBgView.frame = CGRectMake(0, 0, self.frameWidth, CGRectGetMaxY(self.titleLabel.frame)+16);
//        [self.titleBgView zwt_setCornerByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(SMActionSheetCornerRadius, SMActionSheetCornerRadius)];
        
        maxY += self.titleBgView.frameHeight;
        
    } else {
        self.titleBgView.frame = CGRectZero;
        self.titleLabel.frame = CGRectZero;
    }
    
    if (self.messageLabel.text.length) {
        CGFloat height = [self.messageLabel.text boundingRectWithSize:CGSizeMake(self.frameWidth-50*2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil].size.height+1;
        self.messageLabel.frame = CGRectMake(50, (maxY==0)?16:(maxY-16+4), self.frameWidth-100, height);
        self.titleBgView.frame = CGRectMake(0, 0, self.frameWidth, CGRectGetMaxY(self.messageLabel.frame)+16);
        maxY = CGRectGetMaxY(self.titleBgView.frame);
    }
    
    if (self.otherBtns) {
        [self.otherBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frameHeight = 56;
            obj.frameY = ((maxY==0)?0:(maxY+1)) + (obj.frameHeight+0.5)*idx;
            obj.frameWidth = self.frameWidth;
            if(maxY == 0 && idx == 0) {
                [obj zwt_setCornerByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(SMActionSheetCornerRadius, SMActionSheetCornerRadius)];
            }
        }];
        maxY = CGRectGetMaxY(self.otherBtns.lastObject.frame);

    }
    
    if (self.isContainsCancelStyle) {
        self.cancelBtn.frameY = maxY + 8;
        self.cancelBtn.frameWidth = self.frameWidth;
        self.cancelBtn.frameHeight = 56+dhBottomBarHeight;
        self.cancelBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, dhBottomBarHeight, 0);
        self.frameHeight = CGRectGetMaxY(self.cancelBtn.frame);
    } else {
        self.cancelBtn.frame = CGRectZero;
        self.frameHeight = maxY;
    }
    self.frameY = UIScreen.mainScreen.bounds.size.height - self.frameHeight;
    
    self.frameWidth = UIScreen.mainScreen.bounds.size.width;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupFrame];
}

@end
