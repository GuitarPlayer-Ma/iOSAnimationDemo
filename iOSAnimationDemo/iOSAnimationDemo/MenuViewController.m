//
//  MenuViewController.m
//  iOSAnimationDemo
//
//  Created by mada on 15/9/21.
//  Copyright © 2015年 MD. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuViewCell.h"
#import "PathAnimationController.h"

#define kItemKeyTitle @"title"
#define kItemKeyDetailTitle @"detailTitle"
#define kItemKeyClassName @"className"

@interface MenuViewController ()
/** 数据 */
@property (strong, nonatomic) NSMutableArray *items;
@end

@implementation MenuViewController

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [@[
                   @{
                       kItemKeyTitle : @"路径动画",
                       kItemKeyDetailTitle : @"根据绘图的路径生成动画。",
                       kItemKeyClassName : @"PathAnimation"
                    },
                   @{
                       kItemKeyTitle : @"折纸效果动画",
                       kItemKeyDetailTitle : @"图片的一半可以对折翻转，另一半图片会有阴影效果。",
                       kItemKeyClassName : @"PaperFolding"
                    },
                   @{
                       kItemKeyTitle : @"个人主页动画",
                       kItemKeyDetailTitle : @"往下拖动和往上拖动试试吧。",
                       kItemKeyClassName : @"HomePage"
                    },
                   @{
                       kItemKeyTitle : @"抽屉效果动画",
                       kItemKeyDetailTitle : @"这里实现了最简单的抽屉效果，左右都可以滑动。",
                       kItemKeyClassName : @"DrawerAnimation"
                    }
                 ] mutableCopy];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"与手势相关的动画效果";
    // 添加手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longPress];
    
    // 清空导航条的图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 导航条的分隔线也去掉
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    MenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    NSDictionary *item = self.items[indexPath.row];
    cell.titleLabel.text = item[kItemKeyTitle];
    cell.detailLabel.text = item[kItemKeyDetailTitle];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.items[indexPath.row];
    NSString *className = [item[kItemKeyClassName] stringByAppendingString:@"Controller"];
    
    if (NSClassFromString(className)) {
        Class aClass = NSClassFromString(className);
        id instance = [[aClass alloc] init];
        
        if ([instance isKindOfClass:[UIViewController class]]) {
            [(UIViewController *)instance setTitle:item[kItemKeyTitle]];
            [self.navigationController pushViewController:(UIViewController *)instance animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数组中移除
    [self.items removeObjectAtIndex:indexPath.row];
    // 移除cell
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - 手势识别

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    UIGestureRecognizerState status = longPress.state;
    CGPoint location = [longPress locationInView:self.tableView];
    
    // 当前位置的cell的indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    // 创建cell的快照
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (status) {
        case UIGestureRecognizerStateBegan:{
            // 记录最开始的位置
            sourceIndexPath = indexPath;
            // 手势起始位置的cell
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // 创建cell的快照
            snapshot = [self cumstomSnapshotFromView:cell];
            [self.view addSubview:snapshot];
            
            snapshot.alpha = 0.0;
            CGPoint center = cell.center;
            snapshot.center = center;
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.alpha = 0.98;
                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                cell.alpha = 0.0;
            } completion:^(BOOL finished) {
                cell.hidden = YES;
            }];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            // 开始拖动，快照跟着移动
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // 手指移动到其他cell的范围上时
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // 改变数据模型的位置
                [self.items exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // 改变cell的位置
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:sourceIndexPath];
                // 记录当前位置
                sourceIndexPath = indexPath;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            // 手指松开后所在位置
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            break;
        }
        default:
            break;
    }
}

// 自定义cell的快照
- (UIView *)cumstomSnapshotFromView:(UIView *)inputView
{
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    // 把输入的view的图层渲染到图形上下文
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 获取图形上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 创建快照
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    UIGraphicsEndImageContext();
    
    // 设置快照的样式
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOffset = CGSizeMake(-0.5, 0.0);
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

@end
