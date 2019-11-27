//
//  WJUICategory.m
//  Category
//
//  Created by wangjie on 2019/11/21.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "WJUICategory.h"
#import <objc/runtime.h>

static char WJViewActionHandlerTapBlockKey;
static char WJViewActionHandlerTapGestureKey;
static char WJViewActionHandlerLongPressBlockKey;
static char WJViewActionHandlerLongPressGestureKey;

//静态就交换静态，实例方法就交换实例方法
void swizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = nil;
    if (!originalMethod) {//处理为类的方法
        originalMethod = class_getClassMethod(cls, originalSelector);
        swizzledMethod = class_getClassMethod(cls, swizzledSelector);
        if (!originalMethod || !swizzledMethod) return;
    } else {//处理为事例的方法
        swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        if (!swizzledMethod) return;
    }
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

#pragma mark UIViewController
@implementation UIViewController (WJPlugin)

@end

#pragma mark UIView

@interface UIView ()

@property (nonatomic, strong) CAGradientLayer *wj_gradientLayer;

@end

@implementation UIView (WJPlugin)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod([self class], @selector(setFrame:), @selector(wj_setFrame:));
    });
}
- (CGFloat)wj_left {
    return self.frame.origin.x;
}

- (void)setWj_left:(CGFloat)wj_left {
    CGRect frame = self.frame;
    frame.origin.x = wj_left;
    self.frame = frame;
}

- (CGFloat)wj_top {
    return self.frame.origin.y;
}

- (void)setWj_top:(CGFloat)wj_top {
    CGRect frame = self.frame;
    frame.origin.y = wj_top;
    self.frame = frame;
}

- (CGFloat)wj_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setWj_right:(CGFloat)wj_right {
    CGRect frame = self.frame;
    frame.origin.x = wj_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)wj_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setWj_bottom:(CGFloat)wj_bottom {
    CGRect frame = self.frame;
    frame.origin.y = wj_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)wj_centerX {
    return self.center.x;
}

- (void)setWj_centerX:(CGFloat)wj_centerX {
    self.center = CGPointMake(wj_centerX, self.center.y);
}

- (CGFloat)wj_centerY {
    return self.center.y;
}

- (void)setWj_centerY:(CGFloat)wj_centerY {
    self.center = CGPointMake(self.center.x, wj_centerY);
}

- (CGFloat)wj_width {
    return self.frame.size.width;
}

- (void)setWj_width:(CGFloat)wj_width {
    CGRect frame = self.frame;
    frame.size.width = wj_width;
    self.frame = frame;
}

- (CGFloat)wj_height {
    return self.frame.size.height;
}

- (void)setWj_height:(CGFloat)wj_height {
    CGRect frame = self.frame;
    frame.size.height = wj_height;
    self.frame = frame;
}

- (CGPoint)wj_origin {
    return self.frame.origin;
}

- (void)setWj_origin:(CGPoint)wj_origin {
    CGRect frame = self.frame;
    frame.origin = wj_origin;
    self.frame = frame;
}

- (CGSize)wj_size {
    return self.frame.size;
}

- (void)setWj_size:(CGSize)wj_size {
    CGRect frame = self.frame;
    frame.size = wj_size;
    self.frame = frame;
}

- (void)wj_setFrame:(CGRect)frame {
    [self wj_setFrame:frame];
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, @selector(wj_gradientLayer));
    if (gradientLayer) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        gradientLayer.frame = self.bounds;
        [CATransaction commit];
    }
}

- (CAGradientLayer *)wj_gradientLayer {
    CAGradientLayer *gradientLayer = objc_getAssociatedObject(self, _cmd);
    if (!gradientLayer) {
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [self.layer insertSublayer:gradientLayer atIndex:0];
        objc_setAssociatedObject(self, _cmd, gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gradientLayer;
}

- (void)setWj_gradientColors:(NSArray *)wj_gradientColors {
    self.wj_gradientLayer.colors = wj_gradientColors;
}

- (NSArray *)wj_gradientColors {
    return self.wj_gradientLayer.colors;
}

- (void)setWj_gradientStartPoint:(CGPoint)wj_gradientStartPoint {
    self.wj_gradientLayer.startPoint = wj_gradientStartPoint;
}

- (CGPoint)wj_gradientStartPoint {
    return self.wj_gradientLayer.startPoint;
}

- (void)setWj_gradientEndPoint:(CGPoint)wj_gradientEndPoint {
    self.wj_gradientLayer.endPoint = wj_gradientEndPoint;
}

- (CGPoint)wj_gradientEndPoint {
    return self.wj_gradientLayer.endPoint;
}

- (void)wj_removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)wj_setTapActionWithBlock:(void (^)(UIView *view))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &WJViewActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wj_handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &WJViewActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &WJViewActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)wj_setLongPressActionWithBlock:(void (^)(UIView *view))block {
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &WJViewActionHandlerLongPressGestureKey);
    if (!gesture) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(wj_handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &WJViewActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &WJViewActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)wj_handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(UIView *view) = objc_getAssociatedObject(self, &WJViewActionHandlerTapBlockKey);
        if (action) action(gesture.view);
    }
}

- (void)wj_handleActionForLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void(^action)(UIView *view) = objc_getAssociatedObject(self, &WJViewActionHandlerLongPressBlockKey);
        if (action) if (action) action(gesture.view);
    }
}

@end

#pragma mark UIControl
@interface UIControl ()
@property (nonatomic) NSTimeInterval wj_repeatEventTime;//记录时间
@end

@implementation UIControl (WJPlugin)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod([self class], @selector(sendAction:to:forEvent:), @selector(wj_sendAction:to:forEvent:));
    });
}

- (void)wj_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([[NSDate date] timeIntervalSince1970] - self.wj_repeatEventTime < self.wj_repeatEventInterval) return;
    if (self.wj_repeatEventInterval > 0) self.wj_repeatEventTime = [[NSDate date] timeIntervalSince1970];
    [self wj_sendAction:action to:target forEvent:event];
}

- (void)setWj_repeatEventInterval:(NSTimeInterval)wj_repeatEventInterval {
    objc_setAssociatedObject(self, @selector(wj_repeatEventInterval), @(wj_repeatEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)wj_repeatEventInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setWj_repeatEventTime:(NSTimeInterval)wj_repeatEventTime {
    objc_setAssociatedObject(self, @selector(wj_repeatEventTime), @(wj_repeatEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)wj_repeatEventTime {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

@end

#pragma mark UIButton

@implementation UIButton (WJPlugin)

- (void)wj_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage wj_imageWithColor:backgroundColor] forState:state];
}

@end

#pragma mark UIImage
@implementation UIImage (WJPlugin)

// 使用颜色创建UIImage
+ (UIImage *)wj_imageWithColor:(UIColor *)color {
    CGRect imageRect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, imageRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

#pragma mark UILabel
@implementation UILabel (WJPlugin)

- (void)setWj_copy:(BOOL)wj_copy {
    objc_setAssociatedObject(self, @selector(wj_copy), @(wj_copy), OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (wj_copy) {
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *copyLpg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:copyLpg];
    }
}

- (BOOL)wj_copy {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)lpg {
    if (lpg.state == UIGestureRecognizerStateBegan) {
        if (self.text.length > 0 || self.attributedText.string.length > 0) {
            UIPasteboard *board = [UIPasteboard generalPasteboard];
            board.string = self.text ? self.text : self.attributedText.string;
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [impactLight impactOccurred];
            }
//            [WJProgressHUD showTextHud:@"复制成功" inView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

@end

#pragma mark UITextField
@implementation UITextField (WJPlugin)

- (void)setWj_prohibitPerformAction:(BOOL)wj_prohibitPerformAction {
    objc_setAssociatedObject(self, @selector(wj_prohibitPerformAction), @(wj_prohibitPerformAction), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wj_prohibitPerformAction {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return !self.wj_prohibitPerformAction;
}

- (void)wj_limitTextFieldLength:(NSUInteger)maxLength {
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > maxLength) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1) {
                self.text = [toBeString substringToIndex:maxLength];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                self.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

@end

#pragma mark UITextView
@implementation UITextView (WJPlugin)
/**< UITextView限制字数 */
- (void)wj_limitTextViewLength:(NSUInteger)maxLength {
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > maxLength) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1) {
                self.text = [toBeString substringToIndex:maxLength];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                self.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

@end

#pragma mark UIColor
@implementation UIColor (WJPlugin)

static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

+ (nullable UIColor *)wj_colorWithHexString:(NSString *)hexStr {
    return [self wj_colorWithHexString:hexStr alpha:1];
}

+ (nullable UIColor *)wj_colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *string = [[hexStr stringByTrimmingCharactersInSet:set] uppercaseString];
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    } else if ([string hasPrefix:@"0X"]) {
        string = [string substringFromIndex:2];
    }
    NSUInteger length = [string length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) return nil;
    CGFloat r,g,b;
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        r = hexStrToInt([string substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        g = hexStrToInt([string substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        b = hexStrToInt([string substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
    } else {
        r = hexStrToInt([string substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        g = hexStrToInt([string substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        b = hexStrToInt([string substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
    }
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

@end


