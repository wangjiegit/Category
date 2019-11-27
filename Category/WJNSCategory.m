//
//  WJNSCategory.m
//  Category
//
//  Created by wangjie on 2019/11/21.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "WJNSCategory.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <Photos/Photos.h>

#pragma mark NSArray

@implementation NSArray (WJPlugin)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifndef DEBUG
        //越界崩溃方式一：[array objectAtIndex:1000];
        swizzleMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:), @selector(wj_safeObjectAtIndex:));
        //越界崩溃方式二：arr[1000];   Subscript n:下标、脚注
        swizzleMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndexedSubscript:), @selector(wj_safeObjectAtIndexedSubscript:));
#endif
    });
}

- (id)wj_safeObjectAtIndex:(NSUInteger)index {
    if (index > (self.count - 1)) return nil;
    return [self wj_safeObjectAtIndex:index];
}

- (id)wj_safeObjectAtIndexedSubscript:(NSUInteger)index {
    if (index > (self.count - 1)) return nil;
    return [self wj_safeObjectAtIndexedSubscript:index];
}

//打印输出
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"(\n"];
    for (NSString *title in self) {
        [string appendFormat:@"\t\"%@\",\n",title];
    }
    [string appendString:@")"];
    return string;
}

@end

#pragma mark NSMutableArray

@implementation NSMutableArray (WJPlugin)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifndef DEBUG
        //越界崩溃方式一：[array objectAtIndex:1000];
        swizzleMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:), @selector(wj_safeObjectAtIndex:));
        //越界崩溃方式二：arr[1000];   Subscript n:下标、脚注
        swizzleMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndexedSubscript:), @selector(wj_safeObjectAtIndexedSubscript:));
#endif
    });
}

- (id)wj_safeObjectAtIndex:(NSUInteger)index {
    if (index > (self.count - 1)) return nil;
    return [self wj_safeObjectAtIndex:index];
}

- (id)wj_safeObjectAtIndexedSubscript:(NSUInteger)index {
    if (index > (self.count - 1)) return nil;
    return [self wj_safeObjectAtIndexedSubscript:index];
}

@end

#pragma mark NSDictionary
@implementation NSDictionary (WJPlugin)

- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"{\n"];
    for (NSString *key in self) {
        NSString *value =[self valueForKey:key];
        [string appendFormat:@"\t\"%@\" = %@;\n",key,value];
    }
    [string appendString:@"}"];
    return string;
}

@end

#pragma mark NSString
@implementation NSString (WJPlugin)

- (NSString *)wj_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)wj_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)wj_removeWhiteSpace {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
}

- (NSString *)wj_removeNewLine {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
}

- (BOOL)wj_isMobileNumber {
    if (!self || self.length == 0) return false;
    NSString *regex = @"^[1][1,2,3,4,5,6,7,8,9][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)wj_isEmail {
    if (!self || self.length == 0) return false;
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)wj_isIdentityCardNumber {
    if (!self || self.length == 0) return false;
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)wj_isZipcode {
    if (!self || self.length == 0) return false;
    NSString *regex = @"^[1-9]\\d{5}(?!\\d)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (NSString *)wj_limitWidthByTruncatingTail:(CGFloat)maxWidth font:(UIFont *)font {
    if (!self || ![self length]) return self;
    CGFloat width = [self sizeWithAttributes:@{NSFontAttributeName:font}].width;
    if (width <= maxWidth) return self;
    NSString *substring = @"";
    for (int i = 1; i <= [self length]; i++) {
        substring = [self substringToIndex:i];
        CGFloat subwidth = [substring sizeWithAttributes:@{NSFontAttributeName:font}].width;
        if (subwidth > maxWidth) {
            substring = [NSString stringWithFormat:@"%@...", [self substringToIndex:i - 1]];
            return substring;
        }
    }
    return self;
}

- (NSString *)wj_limitWordsLengthByTruncatingTail:(NSUInteger)maxLength {
    if (self.length <= maxLength) return self;
    NSString *string = [self substringToIndex:maxLength];
    string = [NSString stringWithFormat:@"%@...", string];
    return string;
}

@end

#pragma mark NSTimer
@implementation NSTimer (WJPlugin)

+ (instancetype)wj_timerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(NSTimer *timer))block {
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(wj_invocationEvent:) userInfo:[block copy] repeats:YES];
    [timer fire];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:(NSRunLoopCommonModes)];
    return timer;
}

+ (void)wj_invocationEvent:(NSTimer *)timer {
    void(^block)(NSTimer *timer) = timer.userInfo;
    if (block) block(timer);
}

@end

#pragma mark NSData
@implementation NSData (WJPlugin)

+ (NSData *)dataWithCompressImage:(UIImage *)image maxKBLength:(CGFloat)maxKBLength {
    if (!image) return nil;
    CGFloat compression = 1;
    CGFloat maxLength = maxKBLength * 1000;
    NSData *compressionData = UIImageJPEGRepresentation(image, compression);
    if (compressionData.length < maxLength) return compressionData;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        compressionData = UIImageJPEGRepresentation(image, compression);
        if (compressionData.length < maxLength * 0.9) {
            min = compression;
        } else if (compressionData.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    if (compressionData.length < maxLength) return compressionData;
    UIImage *resultImage = [UIImage imageWithData:compressionData];
    NSUInteger lastDataLength = 0;
    while (compressionData.length > maxLength && compressionData.length != lastDataLength) {
        lastDataLength = compressionData.length;
        CGFloat ratio = (CGFloat)maxLength / compressionData.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        compressionData = UIImageJPEGRepresentation(resultImage, compression);
    }
    return compressionData;
}

+ (void)videoToMP4ByURL:(NSURL *)URL startSeconds:(CGFloat)startSeconds endSeconds:(CGFloat)endSeconds completion:(void(^)(NSData *data))comepleteBlock {
    if (!URL || endSeconds <= startSeconds || startSeconds < 0) {
        if (comepleteBlock) comepleteBlock(nil);
        return;
    }
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:URL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSString *presetName = AVAssetExportPresetLowQuality;
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) presetName = AVAssetExportPresetMediumQuality;
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:presetName];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *uniqueName = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:date]];
    NSString *resultPath = [NSTemporaryDirectory() stringByAppendingPathComponent:uniqueName];
    exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
    exportSession.outputFileType = AVFileTypeMPEG4;//可以配置多种输出文件格式
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(startSeconds, 600), CMTimeMakeWithSeconds(endSeconds, 600));
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (comepleteBlock) comepleteBlock([NSData dataWithContentsOfFile:resultPath]);
        });
    }];
}

@end
