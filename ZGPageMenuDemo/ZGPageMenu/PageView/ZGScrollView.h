//
//  ZGScrollView.h
//  ZGPageMenu
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019年 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UICollectionViewCellChangeStyle) {
    UICollectionViewCellChangeStyleDefaultStyle,        // 默认样式
    UICollectionViewCellChangeStyleSynchronizeStyle,    // 同步
    UICollectionViewCellChangeStyleMovingStyle,         // 移动
    UICollectionViewCellChangeStyleIndentationStyle,    // 缩进
    UICollectionViewCellChangeStyleCrawlStyle           // 爬行
};

@protocol AddChindrenViewControllerDelegate <NSObject>


@end

@interface ZGScrollView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic) NSInteger currentPage; // 默认选中项

@property (nonatomic, copy) NSArray *dataArray; // 菜单标题

@property (nonatomic) UICollectionViewCellChangeStyle changeStyle;// 下划线变化样式

@property (nonatomic, strong) UIColor *defaultColor; // 默认颜色
@property (nonatomic, strong) UIColor *selectedtColor; // 选中颜色

- (void)customizeUnlineWidth:(CGFloat)width setUnlineHeight:(CGFloat)height setUnlineColor:(UIColor *)color;// 设置下划线的高宽 颜色

@property (nonatomic, weak) id<AddChindrenViewControllerDelegate> delegate;

- (void)addChildrenController:(NSMutableArray *)childrenArray;


@end

NS_ASSUME_NONNULL_END
