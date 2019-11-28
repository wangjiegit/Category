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

//过滤掉复制来的手机号码中的特殊符号
- (NSString *)filterPhoneNumSpecialSign;

@end

#pragma mark NSTimer
@interface NSTimer (WJPlugin)

+ (instancetype)wj_timerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(NSTimer *timer))block;

@end

#pragma mark NSData
@interface NSData (WJPlugin)

/// 压缩图片
/// @param image 要压缩的图片
/// @param maxKBLength  单位kb
+ (NSData *)dataWithCompressImage:(UIImage *)image maxKBLength:(CGFloat)maxKBLength;


/// 本地视频转MP4
/// @param URL 视频本地地址
/// @param startSeconds 截取视频从第几秒开始
/// @param endSeconds  截取视频从第几秒结束
+ (void)videoToMP4ByURL:(NSURL *)URL startSeconds:(CGFloat)startSeconds endSeconds:(CGFloat)endSeconds completion:(void(^)(NSData *data))comepleteBlock;

@end
NS_ASSUME_NONNULL_END
