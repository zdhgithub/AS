//
//  ZWTTextView.m
//  TextViewDemo
//
//  Created by C.K.Lian on 16/6/26.
//  Copyright © 2016年 C.K.Lian. All rights reserved.
//

#import "ZWTTextView.h"


#define ZWTTextViewIsNull(a) ((a)==nil || (a)==NULL || (NSNull *)(a)==[NSNull null])

//NSString * const SPECIAL_TEXT_NUM = @"SPECIAL_TEXT_NUM";

//标记插入文本的索引值
NSString * const kZWTInsterSpecialTextKeyAttributeName         = @"kZWTInsterSpecialTextKeyAttributeName";
//标记相同的插入文本
NSString * const kZWTInsterSpecialTextKeyGroupAttributeName    = @"kZWTInsterSpecialTextKeyGroupAttributeName";
//标记插入文本的range
NSString * const kZWTInsterSpecialTextRangeAttributeName       = @"kZWTInsterSpecialTextRangeAttributeName";
//标记插入文本的自定义参数
NSString * const kZWTInsterSpecialTextParameterAttributeName   = @"kZWTInsterSpecialTextParameterAttributeName";
//标记正常编辑的文本
NSString * const kZWTTextAttributeName                         = @"kZWTTextAttributeName";
//标记未设置标志符的插入文本
NSString * const kZWTInsterDefaultGroupAttributeName           = @"kZWTInsterDefaultGroupAttributeName";

typedef void(^ObserverResultBlock)(id oldValue, id newValue);
typedef BOOL(^ObserverJudgeBlock)(NSString *path, void *context);
@interface ZWTTextViewObserver : NSObject
@property (nonatomic, copy) ObserverResultBlock resultBlock;
@property (nonatomic, copy) ObserverJudgeBlock judgeBlock;
- (void)observerForTarget:(NSObject *)target forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context resultBlock:(ObserverResultBlock)resultBlock judgeBlock:(ObserverJudgeBlock)judgeBlock;
@end


@interface ZWTTextView()<UITextViewDelegate>
{
    BOOL _shouldChangeText;
    BOOL _enterDone;
    BOOL _afterLayout;
}
@property (nonatomic, strong) UILabel *placeHoldLabel;
@property (nonatomic, assign) BOOL placeHoldLabelHidden;
@property (nonatomic, strong) NSDictionary *defaultAttributes;
@property (nonatomic, assign) NSUInteger specialTextNum;//记录特殊文本的索引值
@property (nonatomic, assign) CGRect defaultFrame;//初始frame值
@property (nonatomic, assign) int addObserverTime;//注册KVO的次数

@property (nonatomic, strong) ZWTTextViewObserver *textViewObserver;//注册KVO观察者
@property (nonatomic, strong) NSMutableArray *insterSpecialTextIndexArray;
@property (nonatomic, assign) NSUInteger currentTextLength;

+ (NSRange)selectedRange:(UITextView *)textView selectTextRange:(UITextRange *)selectedTextRange;
@end

@implementation ZWTTextView
@dynamic delegate;

- (UILabel *)placeHoldLabel {
    if (!_placeHoldLabel) {
        _placeHoldLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_placeHoldLabel setBackgroundColor:[UIColor clearColor]];
        _placeHoldLabel.numberOfLines = 0;
        _placeHoldLabel.minimumScaleFactor = 0.01;
        _placeHoldLabel.adjustsFontSizeToFitWidth = YES;
        _placeHoldLabel.textAlignment = NSTextAlignmentLeft;
        _placeHoldLabel.font = self.font;
        _placeHoldLabel.textColor = [UIColor colorWithRed:0.498 green:0.498 blue:0.498 alpha:1.0];
        [self addSubview:_placeHoldLabel];
    }
    return _placeHoldLabel;
}

- (void)setPlaceHoldContainerInset:(UIEdgeInsets)placeHoldContainerInset {
    _placeHoldContainerInset = placeHoldContainerInset;
    [self placeHoldLabelFrame];
}

- (void)setPlaceHoldString:(NSString *)placeHoldString {
    _placeHoldString = placeHoldString;
    self.placeHoldLabel.text = placeHoldString;
}

- (void)setPlaceHoldTextFont:(UIFont *)placeHoldTextFont {
    _placeHoldTextFont = placeHoldTextFont;
    self.placeHoldLabel.font = placeHoldTextFont;
}

- (void)setPlaceHoldTextColor:(UIColor *)placeHoldTextColor {
    _placeHoldTextColor = placeHoldTextColor;
    self.placeHoldLabel.textColor = placeHoldTextColor;
}

- (void)setAutoLayoutHeight:(BOOL)autoLayoutHeight {
    _autoLayoutHeight = autoLayoutHeight;
    if (_autoLayoutHeight) {
        if (self.maxHeight == 0) {
            self.maxHeight = MAXFLOAT;
        }
        self.layoutManager.allowsNonContiguousLayout = NO;
    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic addEntriesFromDictionary:self.defaultAttributes];
    [dic setValue:font forKey:NSFontAttributeName];
    self.defaultAttributes = dic;
    [self setPlaceHoldTextFont:font];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic addEntriesFromDictionary:self.defaultAttributes];
    [dic setValue:textColor forKey:NSForegroundColorAttributeName];
    self.defaultAttributes = dic;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    self.typingAttributes = self.defaultAttributes;
}

- (UIColor *)getSpecialTextColor {
    if (!_specialTextColor || nil == _specialTextColor) {
        if (!self.textColor || self.textColor == nil) {
            self.textColor = [UIColor blackColor];
        }
        _specialTextColor = self.textColor;
    }
    return _specialTextColor;
}

- (void)dealloc {
    _myDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidShowMenuNotification object:nil];
    id obser = self.observationInfo;
    if (obser) {
        @try {
            [self removeObserver:_textViewObserver forKeyPath:@"selectedTextRange" context:TextViewObserverSelectedTextRange];
        } @catch (NSException *exception) {
            NSLog(@"ZWTTextView 多次删除了 selectedTextRange KVO");
        } @finally {
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    //确保KVO只注册一次
    if (self.addObserverTime >= 1) {
        return;
    }
    self.insterSpecialTextIndexArray = [NSMutableArray array];
    self.specialTextNum = 1;
    self.placeHoldContainerInset = UIEdgeInsetsMake(4, 4, 4, 4);
    self.font = [UIFont systemFontOfSize:14];
    self.defaultFrame = CGRectNull;
    self.defaultAttributes = self.typingAttributes;
    [self addMenuControllerDidShowNotic];
    //由于delegate 被声明为 unavailable，这里只能通过kvc的方式设置了
    [self setValue:self forKey:@"delegate"];
    self.textViewObserver = [[ZWTTextViewObserver alloc]init];
    [self addObserverForTextView];
    [self hiddenPlaceHoldLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_afterLayout) {
        self.defaultFrame = self.frame;
        [self placeHoldLabelFrame];
    }
}

- (void)adjustPlaceHoldLabelFrame:(CGRect)frame {
    if (CGRectIsNull(frame)) {
        self.defaultFrame = self.frame;
        [self placeHoldLabelFrame];
    }else{
        self.placeHoldLabel.frame = frame;
    }
}

- (void)hiddenPlaceHoldLabel {
    if (self.text.length > 0 || self.attributedText.length > 0) {
        self.placeHoldLabel.hidden = YES;
    }else{
        self.placeHoldLabel.hidden = NO;
    }
    if (self.placeHoldLabelHidden != self.placeHoldLabel.hidden) {
        self.placeHoldLabelHidden = self.placeHoldLabel.hidden;
        if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextView:placeHoldLabelHidden:)]) {
            [self.myDelegate ZWTTextView:self placeHoldLabelHidden:self.placeHoldLabel.hidden];
        }
    }
}

- (void)placeHoldLabelFrame {
    CGFloat height = 24;
    if (height > self.defaultFrame.size.height-self.placeHoldContainerInset.top-self.placeHoldContainerInset.bottom) {
        height = self.defaultFrame.size.height-self.placeHoldContainerInset.top-self.placeHoldContainerInset.bottom;
    }
    self.placeHoldLabel.frame = CGRectMake(self.placeHoldContainerInset.left,self.placeHoldContainerInset.top, self.defaultFrame.size.width - self.placeHoldContainerInset.left-self.placeHoldContainerInset.right, height);
}

- (void)changeSize {
    CGRect oriFrame = self.frame;
    CGSize sizeToFit = [self sizeThatFits:CGSizeMake(oriFrame.size.width, MAXFLOAT)];
    if (sizeToFit.height < self.defaultFrame.size.height) {
        sizeToFit.height = self.defaultFrame.size.height;
    }
    if (oriFrame.size.height != sizeToFit.height && sizeToFit.height <= self.maxHeight) {
        oriFrame.size.height = sizeToFit.height;
        self.frame = oriFrame;
        
        if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextView:heightChanged:)]) {
            [self.myDelegate ZWTTextView:self heightChanged:oriFrame];
        }
        [self layoutIfNeeded];
    }
}

/**
 *  截取指定位置的富文本
 *
 *  @param attString 要截取的文本
 *  @param withRange 截取的位置
 *  @param attrs     截取文本的attrs属性
 *
 *  @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)interceptString:(NSAttributedString *)attString
                                     withRange:(NSRange)withRange
                                     withAttrs:(NSDictionary *)attrs
{
    NSString *resultString = [attString.string substringWithRange:withRange];
    NSMutableAttributedString *resultAttStr = [[NSMutableAttributedString alloc]initWithString:resultString];
    [attString enumerateAttributesInRange:withRange options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:attrs];
        if (attrs[kZWTInsterSpecialTextKeyAttributeName] && ![attrs[kZWTInsterSpecialTextKeyAttributeName] isEqualToString:kZWTTextAttributeName]) {
            self.specialTextNum = self.specialTextNum > [attrs[kZWTInsterSpecialTextKeyAttributeName] hash]?self.specialTextNum:[attrs[kZWTInsterSpecialTextKeyAttributeName] hash];
            [dic setObject:self.specialTextColor forKey:NSForegroundColorAttributeName];
        }else{
            if (!self.textColor || self.textColor == nil) {
                self.textColor = [UIColor blackColor];
            }
            [dic setObject:self.textColor forKey:NSForegroundColorAttributeName];
        }
        [resultAttStr addAttributes:dic range:NSMakeRange(range.location-withRange.location, range.length)];
    }];
    return resultAttStr;
}

- (NSMutableAttributedString *)instertAttributedString:(NSAttributedString *)attStr {
    if (attStr.length == 0) {
        return [[NSMutableAttributedString alloc] init];
    }
    NSMutableAttributedString *specialTextAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attStr];
    NSRange specialRange = NSMakeRange(0, attStr.length);
    NSDictionary *dicAtt = [attStr attributesAtIndex:0 effectiveRange:&specialRange];
    //设置默认字体属性
    UIFont *font = dicAtt[NSFontAttributeName];
    UIFont *defaultFont = [UIFont systemFontOfSize:13];//默认字体
    if ([font.fontName isEqualToString:defaultFont.fontName] && font.pointSize == defaultFont.pointSize) {
        font = self.font;
        [specialTextAttStr addAttribute:NSFontAttributeName value:font range:specialRange];
    }
    UIColor *color = dicAtt[NSForegroundColorAttributeName];
    if (!color || nil == color) {
        color = self.specialTextColor;
        [specialTextAttStr addAttribute:NSForegroundColorAttributeName value:color range:specialRange];
    }
    return specialTextAttStr;
}

/**
 *  在指定位置插入字符，并返回插入字符后的SelectedRange值
 *
 *  @param specialText    要插入的字符
 *  @param selectedRange  插入位置
 *  @param attributedText 插入前的文本
 *
 *  @return 插入字符后的光标位置
 */
//- (NSRange)insterSpecialTextAndGetSelectedRange:(NSAttributedString *)specialText
//                                  selectedRange:(NSRange)selectedRange
//                                           text:(NSAttributedString *)attributedText
//{
//    //针对输入时，文本内容为空，直接插入特殊文本的处理
//    if (self.text.length == 0) {
//        [self installStatus];
//    }
//    NSMutableAttributedString *specialTextAttStr = [self instertAttributedString:specialText];
//    
//    NSMutableAttributedString *headTextAttStr = [[NSMutableAttributedString alloc] init];
//    NSMutableAttributedString *tailTextAttStr = [[NSMutableAttributedString alloc] init];
//    //在文本中间
//    if (selectedRange.location > 0 && selectedRange.location != attributedText.length) {
//        //头部
//        [attributedText enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, selectedRange.location) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//            [headTextAttStr insertAttributedString:[self interceptString:attributedText withRange:range withAttrs:attrs] atIndex:0];
//        }];
//        //尾部
//        [attributedText enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(selectedRange.location, attributedText.length-selectedRange.location) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//            [tailTextAttStr insertAttributedString:[self interceptString:attributedText withRange:range withAttrs:attrs] atIndex:0];
//        }];
//    }
//    //在文本首部
//    else if (selectedRange.location == 0) {
//        [attributedText enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(selectedRange.location, attributedText.length-selectedRange.location) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//            [tailTextAttStr insertAttributedString:[self interceptString:attributedText withRange:range withAttrs:attrs] atIndex:0];
//        }];
//    }
//    //在文本最后
//    else if (selectedRange.location == attributedText.length) {
//        [attributedText enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, selectedRange.location) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//            [headTextAttStr insertAttributedString:[self interceptString:attributedText withRange:range withAttrs:attrs] atIndex:0];
//        }];
//    }
//    
//    //为插入文本增加SPECIAL_TEXT_NUM索引
//    self.specialTextNum ++;
//    [specialTextAttStr addAttribute:kZWTInsterSpecialTextKeyAttributeName value:[NSString stringWithFormat:@"%@",@(self.specialTextNum)] range:NSMakeRange(0, specialTextAttStr.length)];
//    
//    NSMutableAttributedString *newTextStr = [[NSMutableAttributedString alloc] init];
//    
//    if (selectedRange.location > 0 && selectedRange.location != newTextStr.length) {
//        [newTextStr appendAttributedString:headTextAttStr];
//        [newTextStr appendAttributedString:specialTextAttStr];
//        [newTextStr appendAttributedString:tailTextAttStr];
//    }
//    //在文本首部
//    else if (selectedRange.location == 0) {
//        [newTextStr appendAttributedString:specialTextAttStr];
//        [newTextStr appendAttributedString:tailTextAttStr];
//    }
//    //在文本最后
//    else if (selectedRange.location == newTextStr.length) {
//        [newTextStr appendAttributedString:headTextAttStr];
//        [newTextStr appendAttributedString:specialTextAttStr];
//    }
//    self.attributedText = newTextStr;
//    NSRange newSelsctRange = NSMakeRange(selectedRange.location+specialTextAttStr.length, 0);
//    self.selectedRange = newSelsctRange;
//    if (self.autoLayoutHeight) {
//        [self changeSize];
//    }
//    [self scrollRangeToVisible:NSMakeRange(self.selectedRange.location+self.selectedRange.length, 0)];
//    return newSelsctRange;
//}

- (NSRange)insertSpecialText:(ZWTTextViewModel *)textModel atIndex:(NSUInteger)loc {
    //针对输入时，文本内容为空，直接插入特殊文本的处理
    if (self.text.length == 0) {
        [self installStatus];
    }
    
    if (self.attributedText.length == 0) {
        loc = 0;
    }else{
        if (loc >= self.attributedText.length) {
            loc = self.attributedText.length;
        }
    }
    
    NSMutableAttributedString *textAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:[ZWTTextView handleEditTextModel:self.attributedText]];
    
    NSRange selectedRange = self.selectedRange;
    
    NSMutableAttributedString *insertTextAttStr = [self instertAttributedString:textModel.attrString];
    NSString *insertKeyGroup = (textModel.insertIdentifier && textModel.insertIdentifier.length > 0)?textModel.insertIdentifier:kZWTInsterDefaultGroupAttributeName;
    [insertTextAttStr addAttribute:kZWTInsterSpecialTextKeyGroupAttributeName value:insertKeyGroup range:NSMakeRange(0, insertTextAttStr.length)];
    //插入key
    NSString *insertKey = [NSUUID UUID].UUIDString;
    [insertTextAttStr addAttribute:kZWTInsterSpecialTextKeyAttributeName value:insertKey range:NSMakeRange(0, insertTextAttStr.length)];
    //插入range
    NSRange insertRange = NSMakeRange(loc, insertTextAttStr.length);
    [insertTextAttStr addAttribute:kZWTInsterSpecialTextRangeAttributeName value:NSStringFromRange(insertRange) range:NSMakeRange(0, insertTextAttStr.length)];
    //插入参数
    if (textModel.parameter) {
        [insertTextAttStr addAttribute:kZWTInsterSpecialTextParameterAttributeName value:textModel.parameter range:NSMakeRange(0, insertTextAttStr.length)];
    }
    
    [textAttStr insertAttributedString:insertTextAttStr atIndex:loc];
    self.attributedText = textAttStr;
    NSRange newSelsctRange = NSMakeRange(selectedRange.location+selectedRange.length+insertTextAttStr.length, 0);
    if (self.autoLayoutHeight) {
        [self changeSize];
    }
    [self scrollRangeToVisible:NSMakeRange(newSelsctRange.location+newSelsctRange.length, 0)];
    self.selectedRange = newSelsctRange;
    return newSelsctRange;
}

- (NSArray <ZWTTextViewModel *>*)insertTextModelWithIdentifier:(NSString *)identifier {
    [self handleEditAttributedTextToZWTTextModel];
    __block NSArray *array = @[];
    //遍历相同的KeyGroup
    [self.attributedText enumerateAttribute:kZWTInsterSpecialTextKeyGroupAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        NSMutableAttributedString *rangeText = [[NSMutableAttributedString alloc]initWithAttributedString:[self.attributedText attributedSubstringFromRange:range]];
        NSRange rangeTextRange = NSMakeRange(0, rangeText.length);
        NSDictionary* dicAtt = @{};
        if (!NSEqualRanges(rangeTextRange,NSMakeRange(0, 0))) {
            dicAtt = [rangeText attributesAtIndex:0 effectiveRange:&rangeTextRange];
        }
        if (dicAtt.count > 0) {
            NSString *keyGroup = dicAtt[kZWTInsterSpecialTextKeyGroupAttributeName];
            if (keyGroup.length > 0 && identifier.length > 0) {
                if ([keyGroup isEqualToString:identifier]) {
                    array = [self textModelFromAttributedString:rangeText insert:YES rangeTextRange:rangeTextRange];
                }
            }
        }
    }];
    return array;
}

- (NSArray <ZWTTextViewModel *>*)allInsertTextModel {
    [self handleEditAttributedTextToZWTTextModel];
    NSArray *array = [self textModelFromAttributedString:self.attributedText insert:YES rangeTextRange:NSMakeRange(0, self.attributedText.length)];
    return array;
}

- (NSArray <ZWTTextViewModel *>*)allTextModel {
    [self handleEditAttributedTextToZWTTextModel];
    NSArray *array = [self textModelFromAttributedString:self.attributedText insert:NO rangeTextRange:NSMakeRange(0, self.attributedText.length)];
    return array;
}

- (NSArray <ZWTTextViewModel *>*)textModelFromAttributedString:(NSAttributedString *)attributedString
                                                       insert:(BOOL)insert
                                               rangeTextRange:(NSRange)rangeTextRange
{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    [attributedString enumerateAttribute:kZWTInsterSpecialTextKeyAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        NSString *key = (NSString *)attrs;
        BOOL condition = NO;
        if (insert) {
            condition = (key.length > 0 && ![key isEqualToString:kZWTTextAttributeName]);
        }else{
            condition = key.length > 0;
        }
        if (condition) {
            
            NSMutableAttributedString *sText = [[NSMutableAttributedString alloc]initWithAttributedString:[attributedString attributedSubstringFromRange:range]];
            
            NSDictionary *modelAttrs = [sText attributesAtIndex:0 effectiveRange:&range];
            NSString *specialStrKey = modelAttrs[kZWTInsterSpecialTextKeyGroupAttributeName];
            NSString *rangeStr = modelAttrs[kZWTInsterSpecialTextRangeAttributeName];
            id parameter = modelAttrs[kZWTInsterSpecialTextParameterAttributeName];
            
            NSRange modelRange = NSMakeRange(rangeTextRange.location+range.location, range.length);
            if (rangeStr.length > 0) {
                modelRange = NSRangeFromString(rangeStr);
            }
            ZWTTextViewModel *model = [ZWTTextViewModel modelWithIdentifier:specialStrKey attrString:sText parameter:parameter];
            model.range = modelRange;
            model.isInsertText = ![key isEqualToString:kZWTTextAttributeName];
            [array insertObject:model atIndex:0];
        }
    }];
    return array;
}

- (void)handleEditAttributedTextToZWTTextModel {
    self.attributedText = [ZWTTextView handleEditTextModel:self.attributedText];
}

+ (NSMutableAttributedString *)handleEditTextModel:(NSAttributedString *)attributedText {
    NSMutableAttributedString *textAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    [textAttStr.string enumerateSubstringsInRange:NSMakeRange(0, [textAttStr.string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         NSDictionary *dicAtt = [textAttStr attributesAtIndex:substringRange.location effectiveRange:&substringRange];
         if (ZWTTextViewIsNull(dicAtt[kZWTInsterSpecialTextKeyAttributeName])) {
             [textAttStr addAttribute:kZWTInsterSpecialTextKeyAttributeName value:kZWTTextAttributeName range:substringRange];
         }
     }];
    return textAttStr;
}

//ZWTTextView直接显示富文本需先设置一下初始值显示效果才有效
- (void)installStatus {
    NSMutableAttributedString *emptyTextStr = [[NSMutableAttributedString alloc] initWithString:@"1"];
    UIFont *font = self.font;
    [emptyTextStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, emptyTextStr.length)];
    if (!self.textColor || self.textColor == nil) {
        self.textColor = [UIColor blackColor];
    }
    [emptyTextStr addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, emptyTextStr.length)];
    self.attributedText = emptyTextStr;
    [emptyTextStr deleteCharactersInRange:NSMakeRange(0, emptyTextStr.length)];
    self.attributedText = emptyTextStr;
}

///**
// 设置指定range的内容为特殊文本
// 
// @param range 指定range
// @param attrs 设置属性
// @param attributedText 设置的源NSAttributedString
// @return 设置后的NSAttributedString
// */
//+ (NSMutableAttributedString *)setRangeStrAsSpecialText:(NSRange)range
//                                             attributes:(NSDictionary<NSAttributedStringKey, id> *)attrs
//                                         attributedText:(NSMutableAttributedString *)attributedText
//{
//    if (range.location == NSNotFound) {
//        return attributedText;
//    }
//    if (range.location >= attributedText.length) {
//        return attributedText;
//    }
//    if (range.location + range.length > attributedText.length) {
//        range = NSMakeRange(range.location, attributedText.length-range.location);
//    }
//    
//    attributedText = [ZWTTextView handleEditTextModel:attributedText];
//    
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
//    NSString *insertKeyGroup = kZWTInsterDefaultGroupAttributeName;
//    [attStr addAttribute:kZWTInsterSpecialTextKeyGroupAttributeName value:insertKeyGroup range:range];
//    //插入key
//    NSString *insertKey = [NSUUID UUID].UUIDString;
//    [attStr addAttribute:kZWTInsterSpecialTextKeyAttributeName value:insertKey range:range];
//    [attStr addAttribute:kZWTInsterSpecialTextRangeAttributeName value:NSStringFromRange(range) range:range];
//    [attStr addAttributes:attrs range:range];
//    return attStr;
//}

#pragma mark - NSNotificationCenter
- (void)addMenuControllerDidShowNotic {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerDidShow:) name:UIMenuControllerDidShowMenuNotification object:nil];
}

- (void)menuControllerDidShow:(NSNotification *)notification {
    NSRange selectedRange = self.selectedRange;
    [self getLeftSelextIndex:selectedRange.location completion:^(NSUInteger index) {
        self.selectedRange = NSMakeRange(index, (selectedRange.location+selectedRange.length) - index);
    }];
}

#pragma mark - Observer
static void *TextViewObserverSelectedTextRange = &TextViewObserverSelectedTextRange;
- (void)addObserverForTextView {
    //确保KVO只注册一次
    if (self.addObserverTime >= 1) {
        return;
    }
    __weak typeof(self) wSelf = self;
    [self.textViewObserver observerForTarget:self forKeyPath:@"selectedTextRange" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:TextViewObserverSelectedTextRange resultBlock:^(id oldValue, id newValue) {
        UITextRange *newContentStr = newValue;
        UITextRange *oldContentStr = oldValue;
        if (!ZWTTextViewIsNull(newContentStr) && !ZWTTextViewIsNull(oldContentStr)) {
            NSRange newRange = [ZWTTextView selectedRange:wSelf selectTextRange:newContentStr];
            NSRange oldRange = [ZWTTextView selectedRange:wSelf selectTextRange:oldContentStr];
            
            //长按弹出放大镜时，移动光标
            if (newRange.length == 0) {
                if (newRange.location != oldRange.location) {
                    //判断光标移动，光标不能处在特殊文本内
                    [wSelf.attributedText enumerateAttribute:kZWTInsterSpecialTextKeyAttributeName inRange:NSMakeRange(0, wSelf.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                        NSString *key = (NSString *)attrs;
                        if (key && ![key isEqualToString:kZWTTextAttributeName]) {
                            if (newRange.location > range.location && newRange.location < (range.location+range.length)) {
                                //光标距离左边界的值
                                NSUInteger leftValue = newRange.location - range.location;
                                //光标距离右边界的值
                                NSUInteger rightValue = range.location+range.length - newRange.location;
                                if (leftValue >= rightValue) {
                                    wSelf.selectedRange = NSMakeRange(wSelf.selectedRange.location-leftValue, 0);
                                }else{
                                    wSelf.selectedRange = NSMakeRange(wSelf.selectedRange.location+rightValue, 0);
                                }
                            }
                        }
                    }];
                }
            }
            //长按选择文字，移动选中文字时移动左右大头针
            else{
                //右边大头针移动
                if (newRange.location == oldRange.location) {
                    NSUInteger rightIndex = newRange.location + newRange.length;
                    [wSelf getRightSelextIndex:rightIndex completion:^(NSUInteger index) {
                        wSelf.selectedRange = NSMakeRange(newRange.location, index-newRange.location);
                    }];
                }
                //左边大头针移动
                else {
                    //左边大头针选中不可编辑文本的判断，交由menuControllerDidShow方法判断
                }
                
            }
        }
        wSelf.typingAttributes = wSelf.defaultAttributes;
        if (wSelf.myDelegate && [wSelf.myDelegate respondsToSelector:@selector(ZWTTextView:changeSelectedRange:)]) {
            [wSelf.myDelegate ZWTTextView:wSelf changeSelectedRange:wSelf.selectedRange];
        }
        
    } judgeBlock:^BOOL(NSString *path, void *context) {
        return (context == TextViewObserverSelectedTextRange && [path isEqual:@"selectedTextRange"] && !wSelf.enableEditInsterText);
    }];
    self.addObserverTime ++;
}

+ (NSRange)selectedRange:(UITextView *)textView selectTextRange:(UITextRange *)selectedTextRange {
    UITextPosition* beginning = textView.beginningOfDocument;
    UITextRange* selectedRange = selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    const NSInteger location = [textView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [textView offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

- (void)currentTextLengthAndInsterSpecialTextIndexArray {
    NSUInteger textLength = self.text.length;
    if (textLength == 0) {
        textLength = self.attributedText.length;
    }
    if (textLength != self.currentTextLength) {
        [self.insterSpecialTextIndexArray removeAllObjects];
        [self.attributedText enumerateAttribute:kZWTInsterSpecialTextKeyAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            NSString *key = (NSString *)attrs;
            if (key && ![key isEqualToString:kZWTTextAttributeName]) {
                for (NSInteger i = 1; i < range.length; i++) {
                    [self.insterSpecialTextIndexArray addObject:@(range.location + i)];
                }
            }
        }];
        self.currentTextLength = textLength;
    }
}

- (void)getRightSelextIndex:(NSInteger)index completion:(void (^)(NSUInteger index))completion {
    if ([self.insterSpecialTextIndexArray containsObject:@(index)]) {
        index = index + 1;
        [self getRightSelextIndex:index completion:completion];
    }else{
        if (completion) {
            completion(index);
        }
    }
}

- (void)getLeftSelextIndex:(NSInteger)index completion:(void (^)(NSUInteger index))completion {
    //当左边选中内容刚好在插入的不可编辑文本内时才要移动光标
    if ([self.insterSpecialTextIndexArray containsObject:@(index)]) {
        [self caculateLeftSelextIndex:index completion:completion];
    }
}

- (void)caculateLeftSelextIndex:(NSInteger)index completion:(void (^)(NSUInteger index))completion {
    if ([self.insterSpecialTextIndexArray containsObject:@(index)]) {
        index = index - 1;
        [self caculateLeftSelextIndex:index completion:completion];
    }else{
        if (completion) {
            completion(index);
        }
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextViewShouldBeginEditing:)]) {
        return [self.myDelegate ZWTTextViewShouldBeginEditing:self];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextViewShouldEndEditing:)]) {
        return [self.myDelegate ZWTTextViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextViewDidBeginEditing:)]) {
        [self.myDelegate ZWTTextViewDidBeginEditing:self];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextViewDidEndEditing:)]) {
        [self.myDelegate ZWTTextViewDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    _shouldChangeText = YES;
    self.typingAttributes = self.defaultAttributes;
    if ([text isEqualToString:@""] && !self.enableEditInsterText) {//删除
        __block BOOL deleteSpecial = NO;
        NSRange oldRange = textView.selectedRange;
        
        [textView.attributedText enumerateAttribute:kZWTInsterSpecialTextKeyAttributeName inRange:NSMakeRange(0, textView.selectedRange.location) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            NSRange deleteRange = NSMakeRange(textView.selectedRange.location-1, 0) ;
            NSString *key = (NSString *)attrs;
            if (key && ![key isEqualToString:kZWTTextAttributeName]) {
                if (deleteRange.location > range.location && deleteRange.location < (range.location+range.length)) {
                    NSMutableAttributedString *textAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
                    [textAttStr deleteCharactersInRange:range];
                    textView.attributedText = textAttStr;
                    deleteSpecial = YES;
                    textView.selectedRange = NSMakeRange(oldRange.location-range.length, 0);
                    *stop = YES;
                }
            }
        }];
        return !deleteSpecial;
    }
    
    _enterDone = NO;
    //输入了done
    if ([text isEqualToString:@"\n"]) {
        _enterDone = YES;
        if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextViewEnterDone:)]) {
            [self.myDelegate ZWTTextViewEnterDone:self];
        }
        if (self.returnKeyType == UIReturnKeyDone) {
            [self resignFirstResponder];
            return NO;
        }
    }
    
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextView:shouldChangeTextInRange:replacementText:)]) {
        return [self.myDelegate ZWTTextView:self shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextViewDidChange:)]) {
        [self.myDelegate ZWTTextViewDidChange:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    _afterLayout = YES;
    self.typingAttributes = self.defaultAttributes;
    if (_shouldChangeText) {
        if (self.autoLayoutHeight) {
            [self changeSize];
        }else{
            textView.layoutManager.allowsNonContiguousLayout = YES;
            if ((self.selectedRange.location+self.selectedRange.length) == (self.text.length)) {
                if (_enterDone) {
                    textView.layoutManager.allowsNonContiguousLayout = NO;
                    [self scrollRangeToVisible:NSMakeRange(self.selectedRange.location+self.selectedRange.length, 0)];
                }
            }
        }
        _shouldChangeText = NO;
    }
    [self hiddenPlaceHoldLabel];
    
    [self currentTextLengthAndInsterSpecialTextIndexArray];
    
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextViewDidChangeSelection:)]) {
        [self.myDelegate ZWTTextViewDidChangeSelection:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextView:shouldInteractWithURL:inRange:interaction:)]) {
        return [self.myDelegate ZWTTextView:self shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextView:shouldInteractWithTextAttachment:inRange:interaction:)]) {
        return [self.myDelegate ZWTTextView:self shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    }
    return YES;
}
- (BOOL)textView:(ZWTTextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextView:shouldInteractWithURL:inRange:)]) {
        return [self.myDelegate ZWTTextView:self shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}
- (BOOL)textView:(ZWTTextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(ZWTTextView:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.myDelegate ZWTTextView:self shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}
@end

@implementation ZWTTextViewModel

+ (ZWTTextViewModel *)modelWithIdentifier:(NSString *)identifier
                              attrString:(NSMutableAttributedString *)attrString
                               parameter:(id)parameter
{
    ZWTTextViewModel *model = [[ZWTTextViewModel alloc]init];
    model.insertIdentifier = identifier;
    model.attrString = attrString;
    model.parameter = parameter;
    return model;
}

- (id)copyWithZone:(NSZone *)zone {
    ZWTTextViewModel *model = [[ZWTTextViewModel alloc]init];
    model.range = self.range;
    model.isInsertText = self.isInsertText;
    model.insertIdentifier = self.insertIdentifier;
    model.attrString = self.attrString;
    model.parameter = self.parameter;
    return model;
}
@end


@implementation ZWTTextViewObserver
- (void)dealloc {
    NSLog(@"ZWTTextViewObserver dealloc");
}
- (void)observerForTarget:(NSObject *)target forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context resultBlock:(ObserverResultBlock)resultBlock judgeBlock:(ObserverJudgeBlock)judgeBlock {
    [target addObserver:self forKeyPath:keyPath options:options context:context];
    self.resultBlock = resultBlock;
    self.judgeBlock = judgeBlock;
}
- (void)observeValueForKeyPath:(NSString*)path ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    BOOL needObserver = NO;
    if (self.judgeBlock) {
        needObserver = self.judgeBlock(path,context);
    }
    if (needObserver){
        UITextRange *newContentStr = [change objectForKey:@"new"];
        UITextRange *oldContentStr = [change objectForKey:@"old"];
        if (self.resultBlock) {
            self.resultBlock(oldContentStr, newContentStr);
        }
    }else{
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}
@end
