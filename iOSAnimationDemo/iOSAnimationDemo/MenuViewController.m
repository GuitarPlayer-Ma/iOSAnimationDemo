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

@interface MenuViewController ()
/** 数据 */
@property (strong, nonatomic) NSArray *items;
@end

@implementation MenuViewController

- (NSArray *)items
{
    if (!_items) {
        _items = @[
                   @{
                       kItemKeyTitle : @"路径动画",
                       kItemKeyDetailTitle : @"根据绘图的路径生成动画。"
                    }
                 ];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    PathAnimationController *patnVc = [[PathAnimationController alloc] init];
    [self.navigationController pushViewController:patnVc animated:YES];
}


@end
