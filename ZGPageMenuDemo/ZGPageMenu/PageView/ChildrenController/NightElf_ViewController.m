//
//  NightElf_ViewController.m
//  ZGPageMenu
//
//  Created by apple on 2019/3/14.
//  Copyright © 2019年 Company. All rights reserved.
//

#import "NightElf_ViewController.h"

@interface NightElf_ViewController () <UITableViewDelegate,UITableViewDataSource>
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

@implementation NightElf_ViewController

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
    
    iconHeroArray = @[@"恶魔猎手",@"丛林守护者",@"月之女祭司",@"守望者"];
    iconSoldierTypeArray = @[@"小精灵",@"弓箭手",@"女猎手",@"投刃车",@"树妖",@"利爪德鲁依人形态",@"利爪德鲁依熊形态",@"山岭巨人",@"角鹰兽",@"角鹰兽骑士",@"猛禽德鲁依人形态",@"猛禽德鲁依鸟形态",@"精灵龙",@"奇美拉"];
    iconBuildingArray = @[@"缠绕金矿",@"生命之树",@"远古之树",@"永恒之树",@"战争古树",@"知识古树",@"风之古树",@"远古守护者",@"奇迹古树",@"月亮井",@"长者祭坛",@"猎手大厅",@"奇美拉栖木"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource:@"NightElf" ofType:@"plist"];
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
