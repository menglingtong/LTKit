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
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(10, 30, 50, 30));
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.bottom.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.iconImageView.mas_bottom);
    }];
    
}

- (void)setNameStr:(NSString *)nameStr
{
    [super setNameStr:nameStr];
    
    if ([nameStr isEqualToString:@"LTDailogViewController"]) {
        self.iconImageView.image = [UIImage imageNamed:@"icon_grid_dialog"];
        self.nameLabel.text = nameStr;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
