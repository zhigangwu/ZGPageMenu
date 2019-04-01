//
//  ZGPageMenu_CollectionViewCell.h
//  TEST
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019年 吴志刚. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface ZGPageMenu_CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *lineImageV;

- (void)setLineFrameWidth:(CGFloat)line_Width lineFrameHeight:(CGFloat)line_Height lineBackgroundColor:(UIColor *)color;

//- (void)setSelectedItemStyle:(NSInteger)integer;

@end

NS_ASSUME_NONNULL_END
