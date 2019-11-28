//
//  WJProgressHUD.m
//  Test
//
//  Created by 王杰 on 2019/6/4.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "WJProgressHUD.h"

@interface WJHUD : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIImageView *gifView;

@property (nonatomic, strong) UIView *prohibitView;

@end

@implementation WJHUD

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _bgView.layer.cornerRadius = 5;
        [self addSubview:_bgView];
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont boldSystemFontOfSize:14];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        [_bgView addSubview:_messageLabel];
        
        _gifView = [[UIImageView alloc] init];
        _gifView.image = [UIImage imageNamed:@"loading_icon"];
        [self addSubview:_gifView];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.duration = 0.8;
        animation.byValue = [NSNumber numberWithFloat:2 * M_PI];
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        [_gifView.layer addAnimation:animation forKey:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = _gifView.image.size;
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width) / 2, ([UIScreen mainScreen].bounds.size.height - size.height) / 2, size.width, size.height) toView:self];
    _gifView.frame = CGRectMake((self.frame.size.width - size.width) / 2, rect.origin.y, rect.size.width, rect.size.height);
}

- (void)showTextHud:(NSString *)text {
    [self removeHUD];
    if (text.length == 0) return;
    _gifView.hidden = YES;
    _bgView.hidden = NO;
    _messageLabel.text = text;
    [self bgViewSizeToFit];
    _bgView.transform = CGAffineTransformMakeScale(.5f, .5f);
    self.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0. usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(1.f, 1.f);
    } completion:nil];
    [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1 inModes:@[NSRunLoopCommonModes]];
}

- (void)bgViewSizeToFit {
    CGSize size = [_messageLabel sizeThatFits:CGSizeMake(self.frame.size.width - 70, CGFLOAT_MAX)];
    CGRect rect = [[UIApplication sharedApplication].keyWindow convertRect:CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width - 30) / 2, ([UIScreen mainScreen].bounds.size.height - size.height - 20) / 2, size.width + 30, size.height + 20) toView:self];
    _bgView.frame = CGRectMake((self.frame.size.width - size.width - 30) / 2, rect.origin.y, rect.size.width, rect.size.height);
    _messageLabel.frame = CGRectMake(15, 10, rect.size.width - 30, rect.size.height - 20);
}

- (void)removeHUD {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _prohibitView.userInteractionEnabled = YES;
    self.hidden = YES;
}

- (void)showIndicator {
    [self showIndicatorProhibitView:nil];
}

- (void)showIndicatorProhibitView:(nullable UIView *)prohibitView {
    _bgView.hidden = YES;
    _gifView.hidden = NO;
    _prohibitView.userInteractionEnabled = YES;
    prohibitView.userInteractionEnabled = NO;
    _prohibitView = prohibitView;
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.1 inModes:@[NSRunLoopCommonModes]];
}

- (void)startAnimation {
    self.hidden = NO;
}

@end

/////////////////////////////////////////////////////////////////////////

@interface UIView (WJHUD)

@property (nonatomic, strong) WJHUD *hud;

@end

@implementation UIView (WJHUD)
@dynamic hud;

- (WJHUD *)hud {
    WJHUD *hud = objc_getAssociatedObject(self, _cmd);
    if (!hud) {
        hud = [[WJHUD alloc] init];
        hud.frame = self.bounds;
        [self addSubview:hud];
        objc_setAssociatedObject(self, _cmd, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self bringSubviewToFront:hud];
    return hud;
}

@end

/////////////////////////////////////////////////////////////////////////////////////

@implementation WJProgressHUD

+ (void)showTextHud:(NSString *)text inView:(UIView *)view {
    [view.hud showTextHud:text];
}

+ (void)showIndicatorHudInView:(UIView *)view prohibitView:(nullable UIView *)prohibitView {
    [view.hud showIndicatorProhibitView:prohibitView];
}

+ (void)showIndicatorHudInView:(UIView *)view {
    [view.hud showIndicator];
}

+ (void)removeHUDForView:(UIView *)view {
    [view.hud removeHUD];
}

@end
