//
//  ZGPageMenu_CollectionViewCell.m
//  TEST
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 吴志刚. All rights reserved.
//

#import "ZGPageMenu_CollectionViewCell.h"
#import "Masonry.h"

@interface ZGPageMenu_CollectionViewCell () {
    CGFloat underline_width;
    CGFloat underline_height;
}

@end

@implementation ZGPageMenu_CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _titleLab.font = [UIFont fontWithName:kNormalFont size:14];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLab];

        [self selectedStyleUnline];
    }
    return self;
}


- (void)selectedStyleUnline {
    _lineImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _lineImageV.layer.cornerRadius = 3;
    _lineImageV.layer.masksToBounds = YES;
    [self addSubview:_lineImageV];
}

- (void)selectedStyleBackgroundColor {
    self.backgroundColor = UIColor.redColor;
    _titleLab.textColor = UIColor.whiteColor;
}

- (void)setLineFrameWidth:(CGFloat)line_Width lineFrameHeight:(CGFloat)line_Height lineBackgroundColor:(UIColor *)color{
    _lineImageV.frame = CGRectMake((100 - line_Width) / 2, 40 - line_Height, line_Width, line_Height);
    _lineImageV.backgroundColor = color;
}


@end
