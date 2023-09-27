//
//  ZWTTextView.h
//  TextViewDemo
//
//  Created by C.K.Lian on 16/6/26.
//  Copyright © 2016年 C.K.Lian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWTTextView;
@class ZWTTextViewModel;

@protocol ZWTTextViewDelegate <NSObject>
@optional
/**
 当textView.returnKeyType = ReturnKeyDone时，点击done执行该回调
 
 @param textView ZWTTextView
 */
- (void)ZWTTextViewEnterDone:(ZWTTextView *)textView;

/**
 ZWTTextView自动改变高度
 
 @param textView ZWTTextView
 @param frame    改变后的高度
 */
- (void)ZWTTextView:(ZWTTextView *)textView heightChanged:(CGRect)frame;

/**
 placeHoldLabel是否显示
 
 @param textView ZWTTextView
 @param hidden   是否显示提示语
 */
- (void)ZWTTextView:(ZWTTextView *)textView placeHoldLabelHidden:(BOOL)hidden;

/**
 改变选中文本
 
 @param textView      ZWTTextView
 @param selectedRange 选中的文本范围
 */
- (void)ZWTTextView:(ZWTTextView *)textView changeSelectedRange:(NSRange)selectedRange;

- (BOOL)ZWTTextViewShouldBeginEditing:(ZWTTextView *)textView;
- (BOOL)ZWTTextViewShouldEndEditing:(ZWTTextView *)textView;

- (void)ZWTTextViewDidBeginEditing:(ZWTTextView *)textView;
- (void)ZWTTextViewDidEndEditing:(ZWTTextView *)textView;

- (BOOL)ZWTTextView:(ZWTTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)ZWTTextViewDidChange:(ZWTTextView *)textView;

- (void)ZWTTextViewDidChangeSelection:(ZWTTextView *)textView;

- (BOOL)ZWTTextView:(ZWTTextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0);
- (BOOL)ZWTTextView:(ZWTTextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0);

- (BOOL)ZWTTextView:(ZWTTextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_DEPRECATED_IOS(7_0, 10_0, "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead");
- (BOOL)ZWTTextView:(ZWTTextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_DEPRECATED_IOS(7_0, 10_0, "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead");
@end


/**
 ZWTTextView功能概要：
 1、可设置placeHold默认提示语；
 2、高度自动改变（autoLayoutHeight）设置，开启后TextView高度可根据输入内容动态调整
 3、支持插入特殊文本，比如 @人名 、#主题#，同时设置插入文本是否可编辑，插入文本可携带自定义参数
    比如：@"测试内容1 @人名 #主题# 测试内容2 @人名1 测试内容3"
 4、TextView输入内容，可通过 `-allTextModel` 等相关方法输出 ZWTTextViewModel 数组
    例如：@[ 测试内容1, @人名, #主题#, 测试内容2, @人名1, 测试内容3]
 */
@interface ZWTTextView : UITextView
/**
 注意!!!这里要实现的是myDelegate，而不是delegate代理
 */
@property (nonatomic, weak) id<UITextViewDelegate> delegate __attribute__((unavailable("这里要实现的是myDelegate，而不是delegate代理")));
/**
 代理
 */
@property (nonatomic, weak) id<ZWTTextViewDelegate> myDelegate;
/**
 输入提示语
 */
@property (nonatomic, copy, setter=setPlaceHoldString:) NSString *placeHoldString;
/**
 提示语字体大小（默认取self.font）
 */
@property (nonatomic, strong, setter=setPlaceHoldTextFont:) UIFont *placeHoldTextFont;
/**
 提示语字体颜色（默认 [UIColor colorWithRed:0.498 green:0.498 blue:0.498 alpha:1.0]）
 */
@property (nonatomic, strong, setter=setPlaceHoldTextColor:) UIColor *placeHoldTextColor;
/**
 placeHold提示内容Insets值(默认 (4, 4, 4, 4))
 */
@property (nonatomic, assign, setter=setPlaceHoldContainerInset:) UIEdgeInsets placeHoldContainerInset;
/**
 是否根据输入内容自动调整高度(默认 NO)
 */
@property (nonatomic, assign, setter=setAutoLayoutHeight:) BOOL autoLayoutHeight;
/**
 autoLayoutHeight为YES时的最大高度(默认 MAXFLOAT)
 */
@property (nonatomic, assign) CGFloat maxHeight;
/**
 插入文本的颜色(默认取 self.textColor)
 */
@property (nonatomic, strong, getter=getSpecialTextColor) UIColor *specialTextColor;
/**
 插入文本是否可编辑(默认 NO)
 */
@property (nonatomic, assign) BOOL enableEditInsterText;

/**
 在指定位置插入特殊文本
 注意⚠️：必须在self.textColor、self.font、self.attributedText等属性设置完成后才能插入特殊文本
 
 @param textModel 插入文本对象
 @param loc       插入位置
 @return          插入文本后的光标位置
 */
- (NSRange)insertSpecialText:(ZWTTextViewModel *)textModel atIndex:(NSUInteger)loc;

/**
 根据插入文本key获取插入文本数组
 
 @param identifier    插入文本key
 @return              ZWTTextViewModel数组
 */
- (NSArray <ZWTTextViewModel *>*)insertTextModelWithIdentifier:(NSString *)identifier;

/**
 获取所有插入数组
 
 @return ZWTTextViewModel数组
 */
- (NSArray <ZWTTextViewModel *>*)allInsertTextModel;

/**
 获取所有文本model数组，包括输入的文本内容，顺序排列
 比如：textView.attributedText = @"测试内容1 @人名 #主题# 测试内容2"
 结果为：@[ 测试内容1, @人名, #主题#, 测试内容2 ]
 
 @return  ZWTTextViewModel数组
 */
- (NSArray <ZWTTextViewModel *>*)allTextModel;

/**
 调整 placeHoldLabel 位置
 
 @param frame 自定义frame，传 CGRectNull 时根据文本内容自动调整
 */
- (void)adjustPlaceHoldLabelFrame:(CGRect)frame;
@end


/**
 ZWTTextView 插入特殊内容，以及输出当前内容的model转换类
 */
@interface ZWTTextViewModel : NSObject

/**
 插入文本标识符
 */
@property (nonatomic, copy) NSString *insertIdentifier;
/**
 文本range
 */
@property (nonatomic, assign) NSRange range;
/**
 文本的NSAttributedString
 */
@property (nonatomic, strong) NSMutableAttributedString *attrString;
/**
 文本自定义参数
 */
@property (nonatomic, strong) id parameter;

/**
 是否为插入文本
 */
@property (nonatomic, assign) BOOL isInsertText;


/**
 插入特殊文本时，根据identifier，初始化ZWTTextViewModel
 
 @param identifier 插入文本标识符
 @param attrString 插入的NSAttributedString
 @param parameter  自定义参数
 @return ZWTTextViewModel
 */
+ (ZWTTextViewModel *)modelWithIdentifier:(NSString *)identifier
                              attrString:(NSAttributedString *)attrString
                               parameter:(id)parameter;

@end

