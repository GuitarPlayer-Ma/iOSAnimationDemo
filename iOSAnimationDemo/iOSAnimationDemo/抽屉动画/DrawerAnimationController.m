//
//  DrawerAnimationController.m
//  iOSAnimationDemo
//
//  Created by mada on 15/10/5.
//  Copyright © 2015年 MD. All rights reserved.
//

#import "DrawerAnimationController.h"

@interface DrawerAnimationController ()

/** 出现在左边的view */
@property (weak, nonatomic) UIView *leftView;
/** 出现在右边的view */
@property (weak, nonatomic) UIView *rightView;
/** 最上层的view */
@property (weak, nonatomic) UIView *mainView;

@end

@implementation DrawerAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置子控件
    [self setupChildView];
    
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    // KVO
    [self.mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 根据x值的变化，决定要显示的view
    if (self.mainView.frame.origin.x > 0) { // 向右滑
        self.leftView.hidden = YES;
        self.rightView.hidden = NO;
    }
    if (self.mainView.frame.origin.x < 0) { // 向左滑
        self.leftView.hidden = NO;
        self.rightView.hidden = YES;
    }
}

- (void)dealloc {
    [self.mainView removeObserver:self forKeyPath:@"frame"];
}

// 监听手势
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    // 获取x轴的偏移量
    CGFloat offsetX = [pan translationInView:self.view].x;
    
    // 根据x轴的便宜量计算mainView的frame
    self.mainView.frame = [self frameWithOffsetX:offsetX];
    
    // 复位
    [pan setTranslation:CGPointZero inView:self.view];
    
    // 确定手指抬起后mainView的最终位置
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 屏幕宽
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat target = 0;
        if (self.mainView.frame.origin.x > screenW * 0.5) {
            target = 250.0;
        }
        else if (CGRectGetMaxX(self.mainView.frame) < screenW * 0.5) {
            target = -200.0;
        }
        
        // 定位
        CGFloat offsetX = target - self.mainView.frame.origin.x;
        [UIView animateWithDuration:0.25 animations:^{
            self.mainView.frame = [self frameWithOffsetX:offsetX];
        }];
    }
}

- (CGRect)frameWithOffsetX:(CGFloat)offsetX {
    
    // 屏幕的宽高
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGFloat screenH = screenRect.size.height;
    CGFloat screenW = screenRect.size.width;
    
    // 获取mainView当前的frame
    CGRect frame = self.mainView.frame;
    
    // 计算当前的x和y
    CGFloat x = frame.origin.x + offsetX;
    CGFloat y = x * 100 / screenW;
    if (self.mainView.frame.origin.x < 0) {
        y = -y;
    }
    
    // 获取当前的高度
    CGFloat height = screenH - 2 * y;
    // 缩放比例
    CGFloat scale = height / screenH;
    // 当前的宽带
    CGFloat width = screenW * scale;
    
    return CGRectMake(x, y, width, height);
}

// 设置子控件
- (void)setupChildView {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    // 出现在左边的view
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    leftView.backgroundColor = [UIColor redColor];
    [self.view addSubview:leftView];
    self.leftView = leftView;
    
    // 出现在右边的view
    UIView *rightView = [[UIView alloc] initWithFrame:frame];
    rightView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightView];
    self.rightView = rightView;
    
    // 最上层的view
    UIView *mainView = [[UIView alloc] initWithFrame:frame];
    mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView];
    self.mainView = mainView;
}

@end
