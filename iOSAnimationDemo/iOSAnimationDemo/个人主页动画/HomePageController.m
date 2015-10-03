//
//  HomePageController.m
//  iOSAnimationDemo
//
//  Created by mada on 15/10/3.
//  Copyright © 2015年 MD. All rights reserved.
//

#import "HomePageController.h"

@interface HomePageController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightCons;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualView;

@end

@implementation HomePageController

static CGFloat const headViewHeight = 200.0;
static CGFloat const tabViewHeight = 44.0;
// 64 + 44
static CGFloat const headViewMinHeight = 108.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 设置tableView*/
    [self setupTableView];
}

- (void)setupTableView {
    // 取消scrollView的自动调节inset功能
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置额外滚动区域
    
    self.tableView.contentInset = UIEdgeInsetsMake(headViewHeight + tabViewHeight, 0, 0, 0);
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 当前Y轴偏移量
    CGFloat curOffsetY = scrollView.contentOffset.y;
    // 最初的Y轴偏移量
    CGFloat originOffsetY = -(headViewHeight + tabViewHeight);
    // 被拖拽的距离
    CGFloat delta = curOffsetY - originOffsetY;
    
    
    // 头部背景的透明度
    CGFloat headAlpha = (delta + 150) / 200.0;
    if (headAlpha < 0) {
        headAlpha = 0;
    }
    self.visualView.alpha = headAlpha;
    
    // 导航条的透明度
    CGFloat navBarAlpha = delta * 1 / 136.0;
    if (navBarAlpha >= 1) {
        navBarAlpha = 0.99;
    }
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithWhite:1.0 alpha:navBarAlpha]] forBarMetrics:UIBarMetricsDefault];
    
    // 当前头部背景的高度
    CGFloat headHeight = -originOffsetY - delta;
    if (headHeight < headViewMinHeight) {
        headHeight = headViewMinHeight;
    }
    
    self.headViewHeightCons.constant = headHeight;
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
