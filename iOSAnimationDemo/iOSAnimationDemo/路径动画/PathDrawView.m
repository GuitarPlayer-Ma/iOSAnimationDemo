//
//  PathDrawView.m
//  iOSAnimationDemo
//
//  Created by mada on 15/9/21.
//  Copyright © 2015年 MD. All rights reserved.
//

#import "PathDrawView.h"


@interface PathDrawView()
/** 画图路径 */
@property (strong, nonatomic) UIBezierPath *path;
@end

@implementation PathDrawView

- (IBAction)startAnimation {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = self.path.CGPath;
    
    // 清除之前的路径
    [self.path removeAllPoints];
    [self setNeedsDisplay];
    
    // 动画画线的颜色
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    // 不要填充
    shapeLayer.fillColor = nil;
    
    // 添加到rootLayer
    [self.layer addSublayer:shapeLayer];
    
    // 画线动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"strokeEnd";
    anim.fromValue = @0;
    anim.toValue = @1;
    anim.duration = 3.0;
    [shapeLayer addAnimation:anim forKey:nil];
    [self setNeedsDisplay];
    
}

- (void)awakeFromNib
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint currentPoint = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) { // 手势刚开始
        [self.path moveToPoint:currentPoint];
    }
    [self.path addLineToPoint:currentPoint];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // 画线
    [self.path stroke];
}

- (UIBezierPath *)path
{
    if (!_path) {
        _path = [UIBezierPath bezierPath];
    }
    return _path;
}
@end
