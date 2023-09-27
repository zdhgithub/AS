//
//  ZWTAlertView.m
//  AlertDemo
//
//  Created by 游兵 on 2019/3/19.
//  Copyright © 2019 游兵. All rights reserved.
//

#import "ZWTAlertView.h"
#import "ZWTAlertController.h"
#import "UIView+ZWTKit.h"
//#import "ZWTKitRectConfig.h"
//#import <ZWTKitColorConfig.h>
//#import <ZWTKitFontConfig.h>
#import "UIImage+ZWTKit.h"
#import "UIColor+XYColor.h"

@implementation ZWTAlertView

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
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        
        self.messageLabel.font = [UIFont systemFontOfSize:15];
        self.messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];

        [self addSubview:self.titleLabel];
        [self addSubview:self.messageLabel];
    }
    return self;
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

- (void)setActions:(NSArray<ZWTAlertAction *> *)actions
{
    [super setActions:actions];
    [actions enumerateObjectsUsingBlock:^(ZWTAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *otherBtn = [self createBtn:obj tag:idx];
        otherBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:otherBtn];
        [otherBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#f4f5f7"]] forState:UIControlStateHighlighted];
        [self.otherBtns addObject:otherBtn];
    }];
    
    [self setupFrame];
}

- (void)setTextFields:(NSArray<UITextField *> *)textFields
{
    [super setTextFields:textFields];
    [textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
}

- (void)setTextViews:(NSArray<ZWTTextView *> *)textViews
{
    [super setTextViews:textViews];
    [textViews enumerateObjectsUsingBlock:^(ZWTTextView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.otherBtns.count==1) {
        [path moveToPoint:CGPointMake(0, rect.size.height-50)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height-50)];
    } else if (self.otherBtns.count==2) {
        [path moveToPoint:CGPointMake(0, rect.size.height-50)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height-50)];
        [path moveToPoint:CGPointMake(rect.size.width/2, rect.size.height-50)];
        [path addLineToPoint:CGPointMake(rect.size.width/2, rect.size.height)];
    } else if (self.otherBtns.count>=3) {
        for (int i=0; i<self.otherBtns.count; i++) {
            [path moveToPoint:CGPointMake(0, rect.size.height-50*(i+1))];
            [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height-50*(i+1))];
        }
    }
    [[UIColor colorWithHexString:@"#f4f5f7"] setStroke];
    [path stroke];
}

- (void)setupFrame
{
    __block CGFloat maxY = 0;
    
    if (self.titleLabel.text.length) {
        CGFloat height = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frameWidth-48, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size.height+1;

        self.titleLabel.frame = CGRectMake(24, 24, self.frameWidth-48, height>26?height:26);
        maxY += CGRectGetMaxY(self.titleLabel.frame);
    }
    if (self.messageLabel.text.length) {
        
        CGFloat height = [self.messageLabel.text boundingRectWithSize:CGSizeMake(self.frameWidth-48, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.messageLabel.font} context:nil].size.height+1;
        self.messageLabel.frame = CGRectMake(24, (maxY==0)?24:(maxY+8), self.frameWidth-48, height>26?height:26);
        maxY = CGRectGetMaxY(self.messageLabel.frame);
    }
    
    if (self.textFields.count) {
        [self.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(24, maxY+12+(50+8)*idx, self.frameWidth-48, 50);
        }];
        maxY = CGRectGetMaxY(self.textFields.lastObject.frame);
    }
    
    if (self.textViews.count) {
        [self.textViews enumerateObjectsUsingBlock:^(ZWTTextView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(24, maxY+12+(90+8)*idx, self.frameWidth-48, 90);
        }];
        maxY = CGRectGetMaxY(self.textViews.lastObject.frame);
    }
    
    if (self.otherBtns.count==1) {
        self.otherBtns.firstObject.frame = CGRectMake(0, maxY+24, self.frameWidth, 50);
        maxY += (50+24);
    } else if (self.otherBtns.count==2) {
        self.otherBtns.firstObject.frame = CGRectMake(0, maxY+24, self.frameWidth/2, 50);
        self.otherBtns.lastObject.frame = CGRectMake(self.frameWidth/2, maxY+24, self.frameWidth/2, 50);
        maxY += (50+24);
    } else if (self.otherBtns.count>=3) {
        [self.otherBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(0, maxY+24+(idx*50), self.frameWidth, 50);
        }];
        maxY += (24+50*self.otherBtns.count);
    }
    
    self.frame = CGRectMake(52, UIScreen.mainScreen.bounds.size.height/2-maxY/2, UIScreen.mainScreen.bounds.size.width-52*2, maxY);
    if (self.textFields.count||self.textViews.count) {
        [self.textFields.firstObject becomeFirstResponder];
        [self.textViews.firstObject becomeFirstResponder];
        self.frameY -= 100;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupFrame];
}

@end
