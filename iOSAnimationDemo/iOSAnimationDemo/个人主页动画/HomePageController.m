//
//  HomePageController.m
//  iOSAnimationDemo
//
//  Created by mada on 15/10/3.
//  Copyright © 2015年 MD. All rights reserved.
//

#import "HomePageController.h"

@interface HomePageController ()

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 设置导航条的样式*/
    // 清空导航条的图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 导航条的分隔线也去掉
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    /* */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}



@end
