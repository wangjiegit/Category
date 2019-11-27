//
//  WJProgressHUD.h
//  Test
//
//  Created by 王杰 on 2019/6/4.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WJProgressHUD : NSObject

+ (void)showTextHud:(NSString *)text inView:(UIView *)view;

+ (void)showIndicatorHudInView:(UIView *)view prohibitView:(nullable UIView *)prohibitView;//禁止交互

+ (void)showIndicatorHudInView:(UIView *)view;//可以交互

+ (void)removeHUDForView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
