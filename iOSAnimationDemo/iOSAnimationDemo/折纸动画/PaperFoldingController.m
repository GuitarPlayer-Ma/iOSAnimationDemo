//
//  PaperFoldingController.m
//  iOSAnimationDemo
//
//  Created by mada on 15/9/22.
//  Copyright © 2015年 MD. All rights reserved.
//

#import "PaperFoldingController.h"

@interface PaperFoldingController ()
@property (weak, nonatomic) IBOutlet UIImageView *topPartImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomPartImageView;
@property (weak, nonatomic) IBOutlet UIView *dragView;

/** 渐变图层 */
@property (weak, nonatomic) CAGradientLayer *gradientLayer;
@end

@implementation PaperFoldingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 修改layer的显示区域
    self.topPartImageView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    self.bottomPartImageView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    
    // 修改锚点位置
    self.topPartImageView.layer.anchorPoint = CGPointMake(0.5, 1);
    self.bottomPartImageView.layer.anchorPoint = CGPointMake(0.5, 0);
    
    // 添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.dragView addGestureRecognizer:pan];
    
    // 创建渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    // 图层位置和大小
    gradientLayer.frame = self.bottomPartImageView.bounds;
    // 渐变色
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    gradientLayer.opacity = 0;
    [self.bottomPartImageView.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取手指在Y轴上的偏移量
    CGFloat transY = [pan translationInView:self.dragView].y;
    
    // 计算旋转的角度
    if (transY >= 200.0) {
        transY = 200.0;
    }
    CGFloat angle = -transY * M_PI / 200.0;
    
    // 3D形变
    CATransform3D tranform = CATransform3DIdentity;
    // ”垂直视距“人与手机屏幕的距离
    CGFloat distance = 400.0;
    tranform.m34 = -1 / distance;
    // 绕x轴旋转
    tranform = CATransform3DRotate(tranform, angle, 1, 0, 0);
    self.topPartImageView.layer.transform = tranform;
    
    // 下半部分的渐变效果
    self.gradientLayer.opacity = transY / 200.0;
    
    // 手指抬起
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 下半部分的渐变效果消失
        self.gradientLayer.opacity = 0;
        
        // 设置弹性还原动画
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            // 清空形变
            self.topPartImageView.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
}

@end
