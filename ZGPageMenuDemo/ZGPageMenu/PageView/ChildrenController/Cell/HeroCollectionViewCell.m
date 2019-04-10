//
//  HeroCollectionViewCell.m
//  ZGPageMenu
//
//  Created by apple on 2019/3/26.
//  Copyright © 2019年 Presonal. All rights reserved.
//

#import "HeroCollectionViewCell.h"

@implementation HeroCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _iconImageV = [[UIImageView alloc] init];
        _iconImageV.layer.cornerRadius = 3;
        _iconImageV.layer.masksToBounds = YES;
        [self addSubview:_iconImageV];
        [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.equalTo(self).offset(5);
            make.size.mas_equalTo(CGSizeMake(64, 64));
        }];
        
        _nameLab = [[UILabel alloc] init];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont fontWithName:kNormalFont size:13];
        [self addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.equalTo(self->_iconImageV.mas_bottom).offset(5);
            make.left.right.equalTo(self);
        }];
    }
    return self;
}

@end
