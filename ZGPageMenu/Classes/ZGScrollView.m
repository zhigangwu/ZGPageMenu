//
//  ZGScrollView.m
//  ZGPageMenu
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019年 Company. All rights reserved.
//

#import "ZGScrollView.h"
#import "ZGPageMenu_CollectionViewCell.h"

UIKIT_EXTERN const CGFloat UIScrollViewDecelerationRateNormal NS_AVAILABLE_IOS(3_0);
UIKIT_EXTERN const CGFloat UIScrollViewDecelerationRateFast NS_AVAILABLE_IOS(3_0);

#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ( [UIScreen mainScreen].bounds.size.height)

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
#define IS_IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//iPhoneX系列
#define Height_StatusBar ((IS_IPHONEX==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define Height_NavBar (IS_IPHONEX==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES)
#define Height_TabBar ((IS_IPHONEX==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)


//常规体
#define kNormalFont @"PingFangSC-Regular"
//中黑体
#define kBoldFont @"PingFangSC-Medium"

#define BGColor [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:249/255.0];


@interface ZGScrollView () <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat contentOffset_X;
    int remainder;
    UICollectionViewFlowLayout *layout;
    NSArray *allChildrenController;
    NSArray *selectedColorRGB;
    NSArray *defaultColorRGB;
    
    CGFloat sr,sg,sb;
    CGFloat dr,dg,db;
}

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic) NSInteger defaultInteger; // 默认选中的item
@property (nonatomic) NSInteger currentInteger; // 当前的item

@property (nonatomic) NSInteger unlineChangeInteger; // 下滑线移动样式

@property (nonatomic) UIColor *default_Color; // 默认颜色
@property (nonatomic) UIColor *selectedt_Color; // 选中颜色

@property (nonatomic) CGFloat line_Width;
@property (nonatomic) CGFloat line_Height;
@property (nonatomic, strong) UIColor *bgColor;

@end

@implementation ZGScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(100, 40);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[ZGPageMenu_CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_collectionView];
//        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self);
//            make.height.mas_equalTo(40);
//        }];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT)];
        _scrollView.tag = 2;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_scrollView];
//        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self->_collectionView.mas_bottom);
//            make.left.right.equalTo(self);
//            make.bottom.equalTo(self);
//        }];

    }
    return self;
}


- (void)setDataArray:(NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = dataArray;
        _scrollView.contentSize = CGSizeMake(_dataArray.count * WIDTH, HEIGHT - (Height_NavBar ? 88 : 64) - 40);
        _titleArray = dataArray;
        [self borderForCollectionView:_collectionView color:UIColor.lightGrayColor];
    }
}

#pragma mark 默认选中
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentInteger = currentPage;
    _defaultInteger = currentPage;

    _scrollView.contentOffset = CGPointMake(WIDTH * currentPage, 20);
    [_collectionView reloadData];

    
    // 默认选中项居中
    [_collectionView performBatchUpdates:^{
        if (100 * currentPage + 50 - WIDTH / 2 > 0) {
            [self->_collectionView setContentOffset:CGPointMake(100 * currentPage + 50 - WIDTH / 2,0)];
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 设置选中和默认字体颜色
- (void)setDefaultColor:(UIColor *)defaultColor {
    _default_Color = defaultColor;
    defaultColorRGB = [self getRGBWithColor:defaultColor];
    [_collectionView reloadData];
}

- (void)setSelectedtColor:(UIColor *)selectedtColor {
    _selectedt_Color = selectedtColor;
    selectedColorRGB = [self getRGBWithColor:selectedtColor];
    [_collectionView reloadData];
}

- (NSArray *)getRGBWithColor:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}


- (void)customizeUnlineWidth:(CGFloat)width setUnlineHeight:(CGFloat)height setUnlineColor:(nonnull UIColor *)color{
    _line_Width = width;
    _line_Height = height;
    _bgColor = color;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentInteger inSection:0];
    ZGPageMenu_CollectionViewCell *cell = (ZGPageMenu_CollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    [cell setLineFrameWidth:width lineFrameHeight:height lineBackgroundColor:_bgColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ZGPageMenu_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.titleLab.text = self.dataArray[indexPath.row];
//    cell.layer.borderWidth = 0.5;
//    cell.layer.borderColor = UIColor.grayColor.CGColor;
    
    [cell setLineFrameWidth:_line_Width lineFrameHeight:_line_Height lineBackgroundColor:_bgColor];
    
    if (_currentInteger == indexPath.row) {
        cell.titleLab.textColor = _selectedt_Color;
        cell.titleLab.font = [UIFont fontWithName:kBoldFont size:16];
        cell.lineImageV.backgroundColor = _bgColor;
    } else {
        cell.titleLab.textColor = _default_Color;
        cell.titleLab.font = [UIFont fontWithName:kNormalFont size:14];
        cell.lineImageV.backgroundColor = UIColor.whiteColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView selectItemAtIndexPath:indexPath animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    _currentInteger = indexPath.row;
    _defaultInteger = indexPath.row;
    [_scrollView setContentOffset:CGPointMake(WIDTH * indexPath.row, 0)];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController = allChildrenController[_currentInteger];
    viewController.view.frame = CGRectMake(WIDTH * _currentInteger, 0, WIDTH, _scrollView.frame.size.height);
    [_scrollView addSubview:viewController.view];
    
    [_collectionView reloadData];
}


- (void)addChildrenController:(NSMutableArray *)childrenArray{
    allChildrenController = childrenArray;
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController = childrenArray[_currentInteger];
    viewController.view.frame = CGRectMake(WIDTH * _currentInteger, 0, WIDTH, _scrollView.frame.size.height);
    [_scrollView addSubview:viewController.view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 2) {
        int befor_contentOffset = WIDTH * _defaultInteger; // 默认偏移量
        int current_contentOffset = scrollView.contentOffset.x; // 当前的偏移量
        
//        NSLog(@"befor_contentOffset = %d",befor_contentOffset);
//        NSLog(@"current_contentOffset = %d",current_contentOffset);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentInteger inSection:0];
        ZGPageMenu_CollectionViewCell *cell = (ZGPageMenu_CollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        
        NSIndexPath *indexPath_right = [NSIndexPath indexPathForItem:_currentInteger + 1 inSection:0];
        ZGPageMenu_CollectionViewCell *rightCell = (ZGPageMenu_CollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath_right];
        
        NSIndexPath *indexPath_left = [NSIndexPath indexPathForItem:_currentInteger - 1 inSection:0];
        ZGPageMenu_CollectionViewCell *leftCell = (ZGPageMenu_CollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath_left];
        
        switch (_changeStyle) {
            case UICollectionViewCellChangeStyleSynchronizeStyle:
                [self progressiveStyle:scrollView contentOffsetBefor:befor_contentOffset contentOffsetCurrent:current_contentOffset currentCollectionCell:cell leftSlide:rightCell rightSlide:leftCell];
                break;
            case UICollectionViewCellChangeStyleMovingStyle:
                [self movingStyle:scrollView contentOffsetBefor:befor_contentOffset contentOffsetCurrent:current_contentOffset currentCollectionCell:cell leftSlide:rightCell rightSlide:leftCell];
                break;
            case UICollectionViewCellChangeStyleIndentationStyle:
                [self indentationStyle:scrollView contentOffsetBefor:befor_contentOffset contentOffsetCurrent:current_contentOffset currentCollectionCell:cell leftSlide:rightCell rightSlide:leftCell];
                break;
            default:
                break;
        }
    } else {
        
    }
}

#pragma mark 同步样式
- (void)progressiveStyle:(UIScrollView *)scrollView contentOffsetBefor:(int)OffsetBefor contentOffsetCurrent:(int)OffsetCurrent currentCollectionCell:(ZGPageMenu_CollectionViewCell *)cell leftSlide:(ZGPageMenu_CollectionViewCell *)cell_right rightSlide:(ZGPageMenu_CollectionViewCell *)cell_left{

    /**
     collectionView的滑动比例 = scrollView滑动的比例
     这样才能实现滑动开始结束达到同步结束
     **/
    CGFloat offsetRatio;
    // 左滑
    if (OffsetCurrent > OffsetBefor) {
        
        offsetRatio = (OffsetCurrent - OffsetBefor) * _line_Width / WIDTH;
        NSLog(@"Ratio = %f",(OffsetCurrent - OffsetBefor) / WIDTH);
        if (offsetRatio >= 0 && offsetRatio < _line_Width) {
            cell.lineImageV.backgroundColor = _bgColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 + offsetRatio , 40 - _line_Height, _line_Width - offsetRatio , _line_Height);
            cell_right.lineImageV.backgroundColor = _bgColor;
            cell_right.lineImageV.frame = CGRectMake((100 - _line_Width) / 2, 40 - _line_Height, offsetRatio, _line_Height);

        } else if (offsetRatio == _line_Width) {
            cell.lineImageV.backgroundColor = UIColor.whiteColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2, 40 - _line_Height, _line_Width, _line_Height);
            cell_right.lineImageV.backgroundColor = _bgColor;
            cell_right.lineImageV.frame = CGRectMake((100 - _line_Width) / 2, 40 - _line_Height, _line_Width, _line_Height);
        }
        

        [self colorTransition:OffsetBefor currentOffset:OffsetCurrent];
        cell.titleLab.textColor = [UIColor colorWithRed:sr green:sg blue:sb alpha:1];
        cell_right.titleLab.textColor = [UIColor colorWithRed:dr green:dg blue:db alpha:1];
        
    } else if (OffsetCurrent < OffsetBefor) { // 右滑
        offsetRatio = abs(OffsetCurrent - OffsetBefor) * _line_Width / WIDTH;

        if (offsetRatio >= 0 && offsetRatio < _line_Width) {
            cell.lineImageV.backgroundColor = _bgColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 , 40 - _line_Height, _line_Width - offsetRatio , _line_Height);
            cell_left.lineImageV.backgroundColor = _bgColor;
            cell_left.lineImageV.frame = CGRectMake(((100 - _line_Width) / 2 + _line_Width) - offsetRatio , 40 - _line_Height,offsetRatio , _line_Height);

        } else if (offsetRatio == _line_Width) {
            cell.lineImageV.backgroundColor = UIColor.whiteColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 , 40 - _line_Height, _line_Width, _line_Height);
            cell_left.lineImageV.backgroundColor = _bgColor;
            cell_left.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 , 40 - _line_Height, _line_Width, _line_Height);
        }
        
        [self colorTransition:OffsetBefor currentOffset:OffsetCurrent];
        cell.titleLab.textColor = [UIColor colorWithRed:sr green:sg blue:sb alpha:1];
        cell_left.titleLab.textColor = [UIColor colorWithRed:dr green:dg blue:db alpha:1];
    }
}

#pragma mark 移动样式
- (void)movingStyle:(UIScrollView *)scrollView contentOffsetBefor:(int)OffsetBefor contentOffsetCurrent:(int)OffsetCurrent currentCollectionCell:(ZGPageMenu_CollectionViewCell *)cell leftSlide:(ZGPageMenu_CollectionViewCell *)cell_right rightSlide:(ZGPageMenu_CollectionViewCell *)cell_left{
    
    // 左滑
    if (OffsetCurrent > OffsetBefor) {
        int ratio = OffsetCurrent % [@(WIDTH) intValue];
//        NSLog(@"ratio = %d",ratio);
        
        CGFloat offsetRatio = ratio * 100 / WIDTH;
//        NSLog(@"offsetRatio = %f",offsetRatio);
        if (offsetRatio > 0 && offsetRatio < 100 / 4) {
            cell.lineImageV.backgroundColor = _bgColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 + offsetRatio , 40 - _line_Height, _line_Width, _line_Height);
            
        } else if (offsetRatio >= 100 / 4 && offsetRatio < 100 / 2) {
            cell.lineImageV.backgroundColor = _bgColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 + offsetRatio , 40 - _line_Height,_line_Width - (offsetRatio - 100 / 4), _line_Height);
            
            cell_right.lineImageV.backgroundColor = _bgColor;
            cell_right.lineImageV.frame = CGRectMake(0, 40 - _line_Height,offsetRatio - 100 / 4, _line_Height);
            
        } else if (offsetRatio >= 100 / 2 && offsetRatio < 100 / 4 * 3) {
            cell.lineImageV.backgroundColor = _bgColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 + offsetRatio , 40 - _line_Height, 100 - ((100 - _line_Width) / 2 + offsetRatio ), _line_Height);
            
            cell_right.lineImageV.backgroundColor = _bgColor;
            cell_right.lineImageV.frame = CGRectMake(0 , 40 - _line_Height, _line_Width / 2 + (offsetRatio - _line_Width), _line_Height);
        } else if (offsetRatio >= 100 / 4 * 3 && offsetRatio <= 100) {
            cell.lineImageV.backgroundColor = UIColor.whiteColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 , 40 - _line_Height, _line_Width, _line_Height);
            
            cell_right.lineImageV.backgroundColor = _bgColor;
            cell_right.lineImageV.frame = CGRectMake(offsetRatio - (100 * 0.75), 40 - _line_Height, _line_Width, _line_Height);
        } else if (offsetRatio == 0) {
            cell.lineImageV.backgroundColor = UIColor.whiteColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 , 40 - _line_Height, _line_Width, _line_Height);
            
            cell_right.lineImageV.backgroundColor = _bgColor;
            cell_right.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 , 40 - _line_Height, _line_Width, _line_Height);
        }
        [self colorTransition:OffsetBefor currentOffset:OffsetCurrent];
        cell.titleLab.textColor = [UIColor colorWithRed:sr green:sg blue:sb alpha:1];
        cell_right.titleLab.textColor = [UIColor colorWithRed:dr green:dg blue:db alpha:1];

    } else if (OffsetCurrent < OffsetBefor) { // 右滑
        int ratio = OffsetCurrent % [@(WIDTH) intValue];
//        NSLog(@"ratio = %d",ratio);
        
        CGFloat offsetRatio = (WIDTH - ratio) * 100 / WIDTH;
//        NSLog(@"offsetRatio = %f",offsetRatio);
        if (offsetRatio >= 0 && offsetRatio < 100 / 4 ) {
            cell.lineImageV.backgroundColor = _bgColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 - offsetRatio , 40 - _line_Height, _line_Width, _line_Height);
            
        } else if (offsetRatio >= 100 / 4 && offsetRatio < 100 / 2) {
            cell.lineImageV.backgroundColor = _bgColor;
            cell.lineImageV.frame = CGRectMake(0 , 40 - _line_Height,_line_Width - (offsetRatio - (100 * 0.25)), _line_Height);

            cell_left.lineImageV.backgroundColor = _bgColor;
            cell_left.lineImageV.frame = CGRectMake(100 - (offsetRatio - (100 * 0.25)), 40 - _line_Height,offsetRatio - (100 * 0.25), _line_Height);
        } else if (offsetRatio >= 100 / 2 && offsetRatio < 100 / 4 * 3) {
            cell.lineImageV.backgroundColor = _bgColor;
            cell.lineImageV.frame = CGRectMake(0 , 40 - _line_Height,_line_Width / 2 - (offsetRatio - _line_Width), _line_Height);

            cell_left.lineImageV.backgroundColor = _bgColor;
            cell_left.lineImageV.frame = CGRectMake(100 - (_line_Width / 2 + (offsetRatio - _line_Width)) , 40 - _line_Height,_line_Width / 2 + (offsetRatio - _line_Width), _line_Height);
        } else if (offsetRatio >= 100 / 4 * 3 && offsetRatio <= 100 ) {
            cell.lineImageV.backgroundColor = UIColor.whiteColor;
            cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 , 40 - _line_Height, _line_Width, _line_Height);

            cell_left.lineImageV.backgroundColor = _bgColor;
            cell_left.lineImageV.frame = CGRectMake(100 - _line_Width - (offsetRatio - (100 * 0.75)), 40 - _line_Height, _line_Width, _line_Height);
        }
        [self colorTransition:OffsetBefor currentOffset:OffsetCurrent];
        cell.titleLab.textColor = [UIColor colorWithRed:sr green:sg blue:sb alpha:1];
        cell_left.titleLab.textColor = [UIColor colorWithRed:dr green:dg blue:db alpha:1];
    }
}

#pragma mark 缩进
- (void)indentationStyle:(UIScrollView *)scrollView contentOffsetBefor:(int)OffsetBefor contentOffsetCurrent:(int)OffsetCurrent currentCollectionCell:(ZGPageMenu_CollectionViewCell *)cell leftSlide:(ZGPageMenu_CollectionViewCell *)cell_right rightSlide:(ZGPageMenu_CollectionViewCell *)cell_left {
    CGFloat offsetRatio;
    if (OffsetCurrent > OffsetBefor) {
        offsetRatio = (OffsetCurrent - OffsetBefor) * _line_Width / WIDTH;
        
        cell.lineImageV.backgroundColor = _bgColor;
        cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 + offsetRatio / 2, 40 - _line_Height, _line_Width - offsetRatio, _line_Height);
        
        cell_right.lineImageV.backgroundColor = _bgColor;
        cell_right.lineImageV.frame = CGRectMake(50 - offsetRatio / 2, 40 - _line_Height, offsetRatio, _line_Height);
        
        [self colorTransition:OffsetBefor currentOffset:OffsetCurrent];
        cell.titleLab.textColor = [UIColor colorWithRed:sr green:sg blue:sb alpha:1];
        cell_right.titleLab.textColor = [UIColor colorWithRed:dr green:dg blue:db alpha:1];
        
    } else {
        offsetRatio = abs(OffsetCurrent - OffsetBefor) * _line_Width / WIDTH;
        
        cell.lineImageV.backgroundColor = _bgColor;
        cell.lineImageV.frame = CGRectMake((100 - _line_Width) / 2 + offsetRatio / 2, 40 - _line_Height, _line_Width - offsetRatio, _line_Height);
        
        cell_left.lineImageV.backgroundColor = _bgColor;
        cell_left.lineImageV.frame = CGRectMake(50 - offsetRatio / 2, 40 - _line_Height, offsetRatio, _line_Height);
        
        [self colorTransition:OffsetBefor currentOffset:OffsetCurrent];
        cell.titleLab.textColor = [UIColor colorWithRed:sr green:sg blue:sb alpha:1];
        cell_left.titleLab.textColor = [UIColor colorWithRed:dr green:dg blue:db alpha:1];
    }
}

// _collectionView的对应的偏移量和选中项
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 2) {
        contentOffset_X = 0;
        contentOffset_X = scrollView.contentOffset.x;
        CGFloat index = contentOffset_X / WIDTH;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [_collectionView selectItemAtIndexPath:indexPath animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        _currentInteger = indexPath.row;
        
        if (_currentInteger > _defaultInteger) {
            UIViewController *viewController = [[UIViewController alloc] init];
            viewController = allChildrenController[_currentInteger - 1];
            [viewController.view removeFromSuperview];
        } else {
            UIViewController *viewController = [[UIViewController alloc] init];
            viewController = allChildrenController[_currentInteger + 1];
            [viewController.view removeFromSuperview];
        }
        
        _defaultInteger = indexPath.row;
        
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController = allChildrenController[_currentInteger];
        viewController.view.frame = CGRectMake(WIDTH * _currentInteger, 0, WIDTH, _scrollView.frame.size.height);
        [_scrollView addSubview:viewController.view];
        
    } else {
        
    }
    [_collectionView reloadData];
}

- (UIView *)borderForCollectionView:(UIView *)originalView color:(UIColor *)color {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 40)];
    [bezierPath addLineToPoint:CGPointMake(100 * _dataArray.count, 40)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineWidth = 1.0f;
    [originalView.layer addSublayer:shapeLayer];
    return originalView;
}

// 用于滑动时字体颜色的过度计算
- (void)colorTransition:(int)OffsetBefor currentOffset:(int)OffsetCurrent {
    if ([selectedColorRGB[0] floatValue] > [defaultColorRGB[0] floatValue]) {
        sr = [selectedColorRGB[0] floatValue] - ([selectedColorRGB[0] floatValue] - [defaultColorRGB[0] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
        
        dr = [defaultColorRGB[0] floatValue] - ([selectedColorRGB[0] floatValue] - [defaultColorRGB[0] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
    } else {
        sr = [selectedColorRGB[0] floatValue] + ([defaultColorRGB[0] floatValue] - [selectedColorRGB[0] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
        
        dr = [defaultColorRGB[0] floatValue] - ([selectedColorRGB[0] floatValue] + [defaultColorRGB[0] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
    }
    
    if ([selectedColorRGB[1] floatValue] > [defaultColorRGB[1] floatValue]) {
        sg = [selectedColorRGB[1] floatValue] - ([selectedColorRGB[1] floatValue] - [defaultColorRGB[1] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
        
        dg = [defaultColorRGB[1] floatValue] - ([selectedColorRGB[1] floatValue] - [defaultColorRGB[1] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
    } else {
        sg = [selectedColorRGB[1] floatValue] + ([defaultColorRGB[1] floatValue] - [selectedColorRGB[1] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
        
        dg = [defaultColorRGB[1] floatValue] + ([selectedColorRGB[1] floatValue] - [defaultColorRGB[1] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
    }
    
    if ([selectedColorRGB[2] floatValue] > [defaultColorRGB[2] floatValue]) {
        sb = [selectedColorRGB[2] floatValue] - ([selectedColorRGB[2] floatValue] - [defaultColorRGB[2] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
        
        db = [defaultColorRGB[2] floatValue] - ([selectedColorRGB[2] floatValue] - [defaultColorRGB[2] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
    } else {
        sb = [selectedColorRGB[2] floatValue] + ([defaultColorRGB[2] floatValue] - [selectedColorRGB[2] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
        
        db = [defaultColorRGB[2] floatValue] + ([selectedColorRGB[2] floatValue] - [defaultColorRGB[2] floatValue]) * (abs(OffsetCurrent - OffsetBefor) / WIDTH);
    }
}

@end
