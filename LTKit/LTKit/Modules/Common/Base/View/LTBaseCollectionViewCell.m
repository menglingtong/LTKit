//
//  LTBaseCollectionViewCell.m
//  LTKit
//
//  Created by 孟令通 on 2017/9/20.
//  Copyright © 2017年 LryMlt. All rights reserved.
//

#import "LTBaseCollectionViewCell.h"

@interface LTBaseCollectionViewCell ()

@end

@implementation LTBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setNameStr:(NSString *)nameStr
{
    if (_nameStr != nameStr) {
        
        _nameStr = nameStr;
    }
}

@end
