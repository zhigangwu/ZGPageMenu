# ZGPageMenu

[![CI Status](https://img.shields.io/travis/zhigangwu/ZGPageMenu.svg?style=flat)](https://travis-ci.org/zhigangwu/ZGPageMenu)
[![Version](https://img.shields.io/cocoapods/v/ZGPageMenu.svg?style=flat)](https://cocoapods.org/pods/ZGPageMenu)
[![License](https://img.shields.io/cocoapods/l/ZGPageMenu.svg?style=flat)](https://cocoapods.org/pods/ZGPageMenu)
[![Platform](https://img.shields.io/cocoapods/p/ZGPageMenu.svg?style=flat)](https://cocoapods.org/pods/ZGPageMenu)


## Installation

ZGPageMenu is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'ZGPageMenu'
```

## Tutorial

```
#import "ZGScrollView.h"

```

```
ZGScrollView *scrollView = [[ZGScrollView alloc] initWithFrame:<#(CGRect)#>];
```

```
scrollView.dataArray = @[@"标题1",@"标题2",@"标题3",@"标题4"];
```

```
// 设置默认字体颜色
scrollView.defaultColor = UIColor.lightGrayColor;

// 设置选中项字体颜色
scrollView.selectedtColor = UIColor.blackColor;

// 设置当前默认选中栏
scrollView.currentPage = 0;

// 设置下滑线的宽度 高度 颜色 
[scrollView customizeUnlineWidth:50 setUnlineHeight:2 setUnlineColor:UIColor.blackColor];
```

### <font color = red> 默认的字体颜色设置一定要优于设置当前的选择页，不然没有效果 </font>

```
// 下划线的改变类型 一共提供了五中变化类型 
scrollView.changeStyle = UICollectionViewCellChangeStyleDefaultStyle;

typedef NS_ENUM(NSInteger, UICollectionViewCellChangeStyle) {
    UICollectionViewCellChangeStyleDefaultStyle,        // 默认样式
    UICollectionViewCellChangeStyleSynchronizeStyle,    // 同步
    UICollectionViewCellChangeStyleMovingStyle,         // 移动
    UICollectionViewCellChangeStyleIndentationStyle,    // 缩进
    UICollectionViewCellChangeStyleCrawlStyle           // 爬行
};

```

### UICollectionViewCellChangeStyleDefaultStyle 默认

![default](https://github.com/zhigangwu/zhigangwu.github.io/blob/master/images/default.gif?raw=true)

### UICollectionViewCellChangeStyleSynchronizeStyle 同步

![Synchronize](https://github.com/zhigangwu/zhigangwu.github.io/blob/master/images/Synchronize.gif?raw=true)

### UICollectionViewCellChangeStyleMovingStyle 移动

![Moving](https://github.com/zhigangwu/zhigangwu.github.io/blob/master/images/Moving.gif?raw=true)

### UICollectionViewCellChangeStyleIndentationStyle 缩进

![Indentation](https://github.com/zhigangwu/zhigangwu.github.io/blob/master/images/Indentation.gif?raw=true)

### UICollectionViewCellChangeStyleCrawlStyle 爬行

![Crawl](https://github.com/zhigangwu/zhigangwu.github.io/blob/master/images/Crawl.gif?raw=true)


```
// 添加相应的子视图
[self addChildView];

- (void)addChildView {
    Humanity_ViewController *humanity = [[Humanity_ViewController alloc] init];
    [self addChildViewController:humanity];

    Undead_ViewController *undead = [[Undead_ViewController alloc] init];
    [self addChildViewController:undead];

    ...

// 添加子视图到数组中
    NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:humanity,undead,nil];
    
//  添加子视图数组到 scrollView 中
    [scrollView addChildrenController:mutablearray];
}
```

## Author

Ryan, 1402832352@qq.com, hardcoreproblem@gmail.com,[Blog](https://zhigangwu.github.io/)

## License

ZGPageMenu is available under the MIT license. See the LICENSE file for more info.
