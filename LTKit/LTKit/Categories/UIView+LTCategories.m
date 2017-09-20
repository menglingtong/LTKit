//
//  UIView+LTCategories.m
//  LTKit
//
//  Created by 孟令通 on 2017/9/21.
//  Copyright © 2017年 LryMlt. All rights reserved.
//

#import "UIView+LTCategories.h"

@implementation UIView (LTCategories)

@end

@implementation UIView (LTCreate)

+ (id)emptyFrameView;
{
    return [[[self class] alloc] initWithFrame:CGRectZero];
}

@end
