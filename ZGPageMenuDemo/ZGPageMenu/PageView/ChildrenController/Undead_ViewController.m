//
//  Undead_ViewController.m
//  ZGPageMenu
//
//  Created by apple on 2019/3/14.
//  Copyright © 2019年 Company. All rights reserved.
//

#import "Undead_ViewController.h"

@interface Undead_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
    NSArray *sectionArray;
    NSArray *rowArray;
    NSDictionary *dictionary;
    
    NSArray *iconHeroArray;
    NSArray *iconSoldierTypeArray;
    NSArray *iconBuildingArray;
    
    CGFloat contentFloat;
}


@end

@implementation Undead_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = UIColor.whiteColor;
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    iconHeroArray = @[@"死亡骑士",@"巫妖",@"恐惧魔王",@"地穴领主"];
    iconSoldierTypeArray = @[@"侍僧",@"食尸鬼",@"地穴恶魔",@"石像鬼",@"亡灵巫师",@"女妖",@"绞肉车",@"憎恶",@"黑曜石雕像",@"毁灭者",@"阴影",@"冰霜巨龙"];
    iconBuildingArray = @[@"闹鬼金矿",@"大墓地",@"亡者大厅",@"黑色城堡",@"地穴",@"通灵塔",@"黑暗祭坛",@"坟场",@"屠宰场",@"诅咒神庙",@"牺牲深渊",@"埋骨地",@"古墓废墟",@"蜘蛛怪塔",@"幽魂之塔"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource:@"Undead" ofType:@"plist"];
    sectionArray = [NSArray arrayWithContentsOfFile:file];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    rowArray = sectionArray[section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:iconHeroArray[indexPath.row]];
    } else if (indexPath.section == 1) {
        cell.imageView.image = [UIImage imageNamed:iconSoldierTypeArray[indexPath.row]];
    } else if (indexPath.section == 2) {
        cell.imageView.image = [UIImage imageNamed:iconBuildingArray[indexPath.row]];
    }
    
    rowArray = sectionArray[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = rowArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = BGColor;
    
    NSArray *sectionTitle = @[@"英雄",@"兵种",@"建筑"];
    
    UILabel *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.text = sectionTitle[section];
    [headerView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerView);
        make.left.equalTo(headerView).offset(10);
        make.right.equalTo(headerView);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    
    return footerView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    contentFloat = scrollView.contentOffset.y;
}

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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
