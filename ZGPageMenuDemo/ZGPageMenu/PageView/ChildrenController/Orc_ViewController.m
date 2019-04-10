//
//  Orc_ViewController.m
//  ZGPageMenu
//
//  Created by apple on 2019/3/14.
//  Copyright © 2019年 Company. All rights reserved.
//

#import "Orc_ViewController.h"

@interface Orc_ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
    NSArray *sectionArray;
    NSArray *rowArray;
    NSDictionary *dictionary;
    
    NSArray *iconHeroArray;
    NSArray *iconSoldierTypeArray;
    NSArray *iconBuildingArray;
}


@end

@implementation Orc_ViewController

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
    
    iconHeroArray = @[@"剑圣",@"先知",@"牛头人酋长",@"暗影猎手"];
    iconSoldierTypeArray = @[@"苦工",@"兽族步兵",@"巨魔猎头者",@"巨魔狂暴战士",@"粉碎者",@"萨满祭司",@"巨魔巫医",@"灵魂行者",@"掠夺者",@"科多兽",@"风骑士",@"巨魔蝙蝠骑士",@"牛头人"];
    iconBuildingArray = @[@"大厅",@"兽族要塞",@"堡垒",@"兽族兵营",@"风暴祭坛",@"战争磨坊",@"兽栏",@"灵魂归宿",@"牛头人图腾",@"巫毒商店",@"兽族地洞",@"瞭望塔"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource:@"Orc" ofType:@"plist"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
