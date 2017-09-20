//
//  LTKitCollectionViewCell.m
//  LTKit
//
//  Created by 孟令通 on 2017/9/21.
//  Copyright © 2017年 LryMlt. All rights reserved.
//

#import "LTKitCollectionViewCell.h"

@implementation LTKitCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.iconImageView = [UIImageView emptyFrameView];
        [self.contentView addSubview:self.iconImageView];
        
        self.nameLabel = [UILabel emptyFrameView];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
