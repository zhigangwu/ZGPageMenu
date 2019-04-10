//
//  Humanity_ViewController.m
//  ZGPageMenu
//
//  Created by apple on 2019/3/14.
//  Copyright © 2019年 Company. All rights reserved.
//

#import "Humanity_ViewController.h"

@interface Humanity_ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *collectionView;
    NSArray *sectionArray;
    NSArray *rowArray;
    NSDictionary *dictionary;
    
    NSArray *iconHeroArray;
    NSArray *iconSoldierTypeArray;
    NSArray *iconBuildingArray;
    
    CGFloat contentFloat;
    UILabel *titleLab;
}

@end

@implementation Humanity_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(WIDTH / 4, WIDTH / 4 );
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 40 - (Height_NavBar ? 88 : 64)) collectionViewLayout:layout];
    collectionView.backgroundColor = UIColor.whiteColor ;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[HeroCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:collectionView];
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(10);
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];

    
    iconHeroArray = @[@"大法师",@"山丘之王",@"圣骑士",@"血魔法师"];
    iconSoldierTypeArray = @[@"农民",@"民兵",@"步兵",@"火枪手",@"牧师",@"女巫",@"魔法破坏者",@"矮人直升机",@"迫击炮小队",@"蒸汽坦克",@"狮鹫骑士",@"龙鹰",@"骑士"];
    iconBuildingArray = @[@"城镇大厅",@"国王祭坛",@"农场",@"兵营",@"神秘藏宝室",@"伐木场",@"铁匠铺",@"哨塔",@"防御塔",@"神秘之塔",@"要塞",@"车间",@"神秘圣地",@"狮鹫笼",@"城堡",@"炮塔"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource:@"Humanity" ofType:@"plist"];
    sectionArray = [NSArray arrayWithContentsOfFile:file];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return sectionArray.count;;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    rowArray = sectionArray[section];
    return rowArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HeroCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = BGColor;
    
    if (indexPath.section == 0) {
        cell.iconImageV.image = [UIImage imageNamed:iconHeroArray[indexPath.row]];
    } else if (indexPath.section == 1) {
        cell.iconImageV.image = [UIImage imageNamed:iconSoldierTypeArray[indexPath.row]];
    } else if (indexPath.section == 2) {
        cell.iconImageV.image = [UIImage imageNamed:iconBuildingArray[indexPath.row]];
    }
    
    rowArray = sectionArray[indexPath.section];
    cell.nameLab.font = [UIFont systemFontOfSize:14];
    cell.nameLab.text = rowArray[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(WIDTH, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.backgroundColor = BGColor;
        
        if (indexPath.row == 0) {
            headerView.titleLab.text = @"英雄";
        } else if (indexPath.row == 1) {
            headerView.titleLab.text = @"兵种";
        } else if (indexPath.row == 2) {
            headerView.titleLab.text = @"建筑";
        }
        
        return headerView;
    } else { // 返回每一组的尾部视图
        UICollectionReusableView *footerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        footerView.backgroundColor = [UIColor purpleColor];
        return footerView;
    }

}

/**
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
    CGFloat offsetY = point.y;

    if (offsetY < 0) {
        //上滑
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upcontentOffset" object:[NSString stringWithFormat:@"%f", scrollView.contentOffset.y]  userInfo:nil];

    } else {
        //下滑
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downcontentOffset" object:[NSString stringWithFormat:@"%f", scrollView.contentOffset.y] userInfo:nil];
    }
    
}
**/
@end
