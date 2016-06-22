//
//  ViewController.m
//  IT007CoreAnimationDemo02
//
//  Created by lwx on 16/6/16.
//  Copyright © 2016年 lwx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    UIButton *_button;
    CALayer  *_layer;
    
    int a;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 100, 100);
    button.center = self.view.center;
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    CALayer *layer = [CALayer layer];
    layer.position = CGPointMake(80, 80);
    layer.bounds = CGRectMake(0, 0, 160, 160);
    layer.contents = (id)[UIImage imageNamed:@"pic3.jpg"].CGImage;
    [self.view.layer addSublayer:layer];
    _layer = layer;
    
}

- (void)buttonClick:(UIButton *)sender {
    
//    [self rotationMethod];
    
//    [self groupAnimation];
    [self transform3D];
}


- (void)transform3D {
    
//    //1.scale
//    CABasicAnimation *basicS = [CABasicAnimation animationWithKeyPath:@"transform"];
//    
//    basicS.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    basicS.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01, 0.01, 0.01)];
//    basicS.duration = 1;
//    basicS.repeatCount = 2;
//    
//    
//    //2.rotation
//    CABasicAnimation *basicR = [CABasicAnimation animationWithKeyPath:@"transform"];
//    
//    basicR.duration = 2;
//    basicR.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 1)];
    
    
    //scale + rotation + position
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 2;
    
    
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CATransform3D postion = CATransform3DMakeTranslation(300, 600, 0);
    CATransform3D scale = CATransform3DMakeScale(0.001, 0.001, 0.001);
    CATransform3D rotation = CATransform3DMakeRotation(M_PI, 1, 1, 1);
    
    //组合CATransform3D
    CATransform3D combin = CATransform3DConcat(rotation, scale);
    
    //组合的时候position需要放在最后面
    combin = CATransform3DConcat(combin, postion);
    
    
    animation.toValue = [NSValue valueWithCATransform3D:combin];
    
    
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeBoth;
    
    //这句的效果等同于上面两句的效果
    _layer.transform = combin;
    
    
    
    [_layer addAnimation:animation forKey:nil];
    
}



- (void)groupAnimation {
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    basicAnimation.duration = 2;
    basicAnimation.repeatCount = 2;
//    basicAnimation.removedOnCompletion = NO;
//    basicAnimation.fillMode = kCAFillModeBoth;
    
    //3d旋转
    basicAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    basicAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 1, 1, 1)];
    
    basicAnimation.cumulative = YES;
    
    CAKeyframeAnimation *KFA = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    KFA.duration = 4;
    
//    KFA.removedOnCompletion = YES;
//    KFA.fillMode = kCAFillModeBoth;
    
    KFA.path = [self getBezierPath];
    
    
    CABasicAnimation *animationS =[CABasicAnimation animationWithKeyPath:@"transform"];
    
    animationS.duration = 4;
    animationS.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animationS.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00001, 0.00001, 0.00001)];
    
    
    
    
    //组动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    //将分动画添加组动画中
    group.animations = @[KFA,basicAnimation,animationS];
    
    //组动画的时间不能小于分动画的时间，否则，分动画会做不完就结束。
    group.duration = 4;
//    group.repeatCount = 2;
    
    //组动画的fillMode由组动画设置的值决定，分动画设置的fillMode无意义
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeBoth;
    
    [_layer addAnimation:group forKey:nil];

    
    
}


- (CGPathRef)getBezierPath {

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:_layer.position];
    
    [path addQuadCurveToPoint:CGPointMake(350, 0) controlPoint:CGPointMake(180, 1400)];
    
    
    return path.CGPath;
}




- (void)rotationMethod {
    
    CABasicAnimation *basicA = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    basicA.duration = 2;
    basicA.repeatCount = 2;
    
    
    //3d旋转
//    给一个CATransform3D
//    然后转成NSValue
//    CATransform3DIdentity : 表示图形不做任何变换时候的状态
    basicA.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    
//    CATransform3DMakeRotation：3D旋转的一个方法，返回一个CATransform3D的值
    basicA.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.5, 0, 0)];
    
    
    //累计动画，动画必须重复次数
//    不能和autoreverses属性一起使用
    basicA.cumulative = YES;
    
//    
//    basicA.autoreverses = YES;
    
    
    [_layer addAnimation:basicA forKey:nil];
    
}






@end
