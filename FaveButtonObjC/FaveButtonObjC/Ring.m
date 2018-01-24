//
//  Ring.m
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "Ring.h"
#import "FaveButton.h"

static NSString * const   sizeKey            = @"sizeKey";
static NSString * const   collapseAnimation  = @"collapseAnimation";
@interface Ring()<CAAnimationDelegate>{
    
    UIColor         *fillColor;
    CGFloat         radius;
    CGFloat         lineWidth;
    CAShapeLayer    *ringLayer;
    
}
@end
@implementation Ring

- (instancetype)initWithRadius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor{
    if(self = [super init]){
        fillColor = fillColor;
        lineWidth = lineWidth;
        radius    = radius;
        
        [self applyInit];
    }
    return self;
}

+ (instancetype)createRing:(FaveButton *)faveButton radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor{
    Ring *ring = [[Ring alloc] initWithRadius:radius lineWidth:lineWidth fillColor:fillColor];
    ring.translatesAutoresizingMaskIntoConstraints = NO;
    ring.backgroundColor = [UIColor clearColor];
    
    [faveButton.superview insertSubview:ring belowSubview:faveButton];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:ring attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:ring attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:ring attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2 * radius];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:ring attribute:NSLayoutAttributeHeight     relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2 * radius];
    widthConstraint.identifier  = sizeKey;
    heightConstraint.identifier = sizeKey;
    
    [ring addConstraints:@[widthConstraint,heightConstraint]];
    [faveButton addConstraints:@[centerXConstraint,centerYConstraint]];
    return ring;
}
#pragma mark - configure
- (void)applyInit{
    UIView *centerView = [[UIView alloc] init];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:centerView];
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(centerView);
    // constraint
    NSArray *constraints1=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[centerView]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:dict];
    
    NSArray *constraints2=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[centerView]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:dict];
    [self addConstraints:constraints1];
    [self addConstraints:constraints2];
    
    CAShapeLayer *circle = [self createRingLayer:radius lineWidth:lineWidth fillColor:[UIColor clearColor] strokeColor:fillColor];
    ringLayer = circle;
}

- (CAShapeLayer *)createRingLayer:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor{
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius - lineWidth / 2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    CAShapeLayer *ring = [CAShapeLayer layer];
    ring.path       = circle.CGPath;
    ring.fillColor  = fillColor.CGColor;;
    ring.lineWidth  = 0;
    ring.strokeColor= strokeColor.CGColor;
    return ring;
}

#pragma mark -- animation

- (void)animateToRadius:(CGFloat)radius toColor:(UIColor *)toColor duration:(CGFloat)duration delay:(CGFloat)delay{
    [self layoutIfNeeded];
    
    NSArray *selfConstraints = self.constraints;
    for(NSLayoutConstraint *constraint in selfConstraints){
        if(![constraint.identifier isEqualToString:sizeKey]) continue;
        constraint.constant = 2 * radius;
    }
    
    CGFloat fitterdRadius = radius - lineWidth / 2;
    
    CABasicAnimation *fillColorAnim = [self animationFillColor:fillColor toColor:toColor duration:duration delay:delay];
    CABasicAnimation *lineWidthAnim = [self animationLineWidth:lineWidth duration:duration delay:delay];
    CABasicAnimation *lineColorAnim = [self animationStrokeColor:toColor duration:duration delay:delay];
    CABasicAnimation *circlePathAnim= [self animationCirclePath:fitterdRadius duration:duration delay:delay];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {}];
    
    [ringLayer addAnimation:fillColorAnim forKey:nil];
    [ringLayer addAnimation:lineColorAnim forKey:nil];
    [ringLayer addAnimation:lineWidthAnim forKey:nil];
    [ringLayer addAnimation:circlePathAnim forKey:nil];
}

- (CABasicAnimation *)animationFillColor:(UIColor *)fromColor toColor:(UIColor *)toColor duration:(CGFloat)duration delay:(CGFloat)delay{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.fromValue = (__bridge id _Nullable)(fromColor.CGColor);
    animation.toValue   = (__bridge id _Nullable)(toColor.CGColor);
    animation.duration  = duration;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CABasicAnimation *)animationLineWidth:(CGFloat)lineWidth duration:(CGFloat)duration delay:(CGFloat)delay{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation.toValue   = @(lineWidth);
    animation.duration  = duration;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.fillMode  = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CABasicAnimation *)animationStrokeColor:(UIColor *)strokeColor duration:(CGFloat)duration delay:(CGFloat)delay{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    animation.toValue   = (__bridge id _Nullable)(strokeColor.CGColor);
    animation.duration  = duration;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.fillMode  = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CABasicAnimation *)animationCirclePath:(CGFloat )radius duration:(CGFloat)duration delay:(CGFloat)delay{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    animation.toValue   = (__bridge id _Nullable)(path.CGPath);
    animation.duration  = duration;
    animation.beginTime = CACurrentMediaTime() + delay;
    animation.fillMode  = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (void)animateColapse:(CGFloat)radius duration:(CGFloat)duration delay:(CGFloat)delay{
    CABasicAnimation *lineWidthAni  = [self animationLineWidth:0 duration:duration delay:delay];
    
    CABasicAnimation *circlePathAni = [self animationCirclePath:radius duration:duration delay:delay];
    circlePathAni.delegate = self;
    [circlePathAni setValue:collapseAnimation forKey:collapseAnimation];
    
    [ringLayer addAnimation:lineWidthAni forKey:nil];
    [ringLayer addAnimation:circlePathAni forKey:nil];
}
#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if([anim valueForKey:collapseAnimation]){
        [self removeFromSuperview];
    }
}
@end
