//
//  WJAPPMacro.h
//  Category
//
//  Created by wangjie on 2019/11/22.
//  Copyright © 2019 wangjie. All rights reserved.
//

#ifndef WJAPPMacro_h
#define WJAPPMacro_h

#ifdef DEBUG
#define DBLog(format, ...)       printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#define DBLog_func               NSLog(@"%s", __FUNCTION__)
#else
#define DBLog(...)
#define DBLog_func
#endif

#define SCREEN_WIDTH                        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                       [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE                        [UIScreen mainScreen].scale
#define STATUSBAR_HEIGHT                    [UIApplication sharedApplication].statusBarFrame.size.height
#define NAVBAR_HEIGHT                       (STATUSBAR_HEIGHT + 44)
#define ONE_PIXEL                           1.0f / [UIScreen mainScreen].scale
#define RATIO_WIDTH(value)                  ceilf(value * [UIScreen mainScreen].bounds.size.width / 375.0)
#define RATIO_HEIGHT(value)                 ceilf(value * [UIScreen mainScreen].bounds.size.width / 667.0)
#define F(string, args...)                  [NSString stringWithFormat:string, args]
#define Font(CGFloat)                       [UIFont systemFontOfSize:(CGFloat)]
#define FontMedium(CGFloat)                 [UIFont systemFontOfSize:(CGFloat) weight:(UIFontWeightMedium)]
#define Block_After(seconds, block)         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block)

//获取temp路径
#define PathTemp                            NSTemporaryDirectory()
//获取沙盒 Document路径
#define PathDocument                        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache路径
#define PathCache                           [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


#endif /* WJAPPMacro_h */
