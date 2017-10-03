//
//  NSMutableParagraphStyle+LTKit.m
//  LTKit
//
//  Created by 孟令通 on 2017/10/3.
//  Copyright © 2017年 LryMlt. All rights reserved.
//

#import "NSMutableParagraphStyle+LTKit.h"

@implementation NSMutableParagraphStyle (LTKit)

+ (instancetype)ltKit_paragraphStyleWithLineHeight:(CGFloat)lineHeight {
    return [self ltKit_paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)ltKit_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self ltKit_paragraphStyleWithLineHeight:lineHeight lineBreakMode:lineBreakMode textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)ltKit_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = textAlignment;
    return paragraphStyle;
}

@end
