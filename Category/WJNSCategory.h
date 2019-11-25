//
//  WJNSCategory.h
//  Category
//
//  Created by wangjie on 2019/11/21.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark NSArray
@interface NSArray (WJPlugin)

@end

#pragma mark NSMutableArray
@interface NSMutableArray (WJPlugin)

@end

#pragma mark NSDictionary
@interface NSDictionary (WJPlugin)

@end

#pragma mark
@interface NSString (WJPlugin)
//md5加密
- (NSString *)wj_md5;

//去除字符串前后的空白,不包含换行符
- (NSString *)wj_trim;

//去除字符串中所有空白
- (NSString *)wj_removeWhiteSpace;
- (NSString *)wj_removeNewLine;

/**< 根据最大长度截断字符串 在行尾加上...*/
- (NSString *)wj_limitWidthByTruncatingTail:(CGFloat)maxWidth font:(UIFont *)font;
/**< 根据最大字数截断字符串 在行尾加上...*/
- (NSString *)wj_limitWordsLengthByTruncatingTail:(NSUInteger)maxLength;

// 手机号码
- (BOOL)wj_isMobileNumber;
// 邮箱
- (BOOL)wj_isEmail;
// 身份证号码
- (BOOL)wj_isIdentityCardNumber;
// 邮政编码
- (BOOL)wj_isZipcode;

@end

#pragma mark NSTimer
@interface NSTimer (WJPlugin)

+ (instancetype)wj_timerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(NSTimer *timer))block;

@end


NS_ASSUME_NONNULL_END
