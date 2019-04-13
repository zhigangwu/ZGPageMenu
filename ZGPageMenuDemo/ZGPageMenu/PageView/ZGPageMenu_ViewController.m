//
//  ZGPageMenu_ViewController.m
//  ZGPageMenu
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019年 Company. All rights reserved.
//

#import "ZGPageMenu_ViewController.h"
#import "ZGScrollView.h"

#import "Naga_ViewController.h"
#import "DarkTroll_ViewController.h"
#import "RedDragon_ViewController.h"

@interface ZGPageMenu_ViewController () <AddChindrenViewControllerDelegate>
{
    ZGScrollView *scrollView;
    NSArray *titleArray;
    
    UIView *topView;
}

@end

@implementation ZGPageMenu_ViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, Height_NavBar ? 88 : 64)];
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.mas_offset(Height_NavBar ? 88 : 64);
//    }];
    
    [self borderForCollectionView:topView color:UIColor.grayColor];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"魔兽争霸";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBoldFont size:18];
    [topView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self->topView).offset(-10);
        make.left.right.equalTo(self->topView);
    }];
    
    scrollView = [[ZGScrollView alloc] init];
    scrollView.collectionView.backgroundColor = BGColor;
    scrollView.delegate = self;
    scrollView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->topView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    scrollView.dataArray = @[@"人族",@"不死族",@"精灵族",@"兽族",@"娜迦族",@"黑暗巨魔",@"红龙"];
    /*
    默认的字体颜色设置一定要优于设置当前的选择页，不然没有效果
    */
    scrollView.defaultColor = UIColor.lightGrayColor;
    scrollView.selectedtColor = UIColor.blackColor;
    scrollView.currentPage = 0;
    [scrollView customizeUnlineWidth:50 setUnlineHeight:2 setUnlineColor:UIColor.blackColor];
    scrollView.changeStyle = UICollectionViewCellChangeStyleCrawlStyle;

    [self addChildView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upcontentOffset:) name:@"upcontentOffset" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downcontentOffset:) name:@"downcontentOffset" object:nil];
}

- (void)addChildView {
    Humanity_ViewController *humanity = [[Humanity_ViewController alloc] init];
    [self addChildViewController:humanity];

    Undead_ViewController *undead = [[Undead_ViewController alloc] init];
    [self addChildViewController:undead];

    NightElf_ViewController *nightElf = [[NightElf_ViewController alloc] init];
    [self addChildViewController:nightElf];

    Orc_ViewController *orc = [[Orc_ViewController alloc] init];
    [self addChildViewController:orc];
    
    Naga_ViewController *naga = [[Naga_ViewController alloc] init];
    [self addChildViewController:naga];
    
    DarkTroll_ViewController *darkTroll = [[DarkTroll_ViewController alloc] init];
    [self addChildViewController:naga];
    
    RedDragon_ViewController *redDragon = [[RedDragon_ViewController alloc] init];
    [self addChildViewController:redDragon];

    NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:humanity,undead,nightElf,orc,naga,darkTroll,redDragon,nil];
    [scrollView addChildrenController:mutablearray];
}

// 上滑消失
- (void)upcontentOffset:(NSNotification *)notif {
    double offsetNumber = [notif.object doubleValue];
    CGFloat topHeight = Height_NavBar ? 88 : 64;
    
//    NSLog(@"upoffsetNumber = %f",offsetNumber);
    
    if (offsetNumber >= HEIGHT / 4 && offsetNumber < HEIGHT / 4 + topHeight) {
        topView.frame = CGRectMake(0, 0 , WIDTH, topHeight - (offsetNumber - HEIGHT / 4));
    } else if (offsetNumber >= HEIGHT / 4 + topHeight) {
        topView.frame = CGRectMake(0, 0 , WIDTH, 0);
    }
}

// 下滑消失
- (void)downcontentOffset:(NSNotification *)notif {
    double offsetNumber = [notif.object doubleValue];
    CGFloat topHeight = Height_NavBar ? 88 : 64;
    
//    NSLog(@"downoffsetNumber = %f",offsetNumber);
    if (offsetNumber >= HEIGHT / 4 && offsetNumber < HEIGHT / 4 + topHeight) {
        topView.frame = CGRectMake(0, 0 , WIDTH, topHeight - (offsetNumber - HEIGHT / 4));
    } else if (offsetNumber < HEIGHT / 4) {
        topView.frame = CGRectMake(0, 0 , WIDTH, Height_NavBar ? 88 : 64);
    }
}

- (UIView *)borderForCollectionView:(UIView *)originalView color:(UIColor *)color {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, Height_NavBar ? 88 : 64)];
    [bezierPath addLineToPoint:CGPointMake(WIDTH, Height_NavBar ? 88 : 64)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineWidth = 1.0f;
    [originalView.layer addSublayer:shapeLayer];
    return originalView;
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
