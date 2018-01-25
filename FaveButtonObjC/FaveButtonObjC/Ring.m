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
    
    UIColor         *_fillColor;
    CGFloat         _radius;
    CGFloat         _lineWidth;
    CAShapeLayer    *_ringLayer;
    
}
@end
@implementation Ring

- (instancetype)initWithRadius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor{
    if(self = [super init]){
        _fillColor = fillColor;
        _lineWidth = lineWidth;
        _radius    = radius;
        
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
    [faveButton.superview addConstraints:@[centerXConstraint,centerYConstraint]];
    return ring;
}
#pragma mark - configure
- (void)applyInit{
    UIView *centerView = [[UIView alloc] init];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    centerView.backgroundColor = [UIColor clearColor];
    [self addSubview:centerView];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    
    [self addConstraints:@[centerXConstraint, centerYConstraint]];
    [centerView addConstraints:@[widthConstraint, heightConstraint]];
    
    CAShapeLayer *circle = [self createRingLayer:_radius lineWidth:_lineWidth fillColor:[UIColor clearColor] strokeColor:_fillColor];
    [centerView.layer addSublayer:circle];
    
    _ringLayer = circle;
}

- (CAShapeLayer *)createRingLayer:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor{
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius - lineWidth / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
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
    
    for(NSLayoutConstraint *constraint in self.constraints){
        if([constraint.identifier isEqualToString:sizeKey])
            constraint.constant = 2 * radius;
    }
    
    CGFloat fitterdRadius = radius - _lineWidth / 2;
    
    CABasicAnimation *fillColorAnim = [self animationFillColor:_fillColor toColor:toColor duration:duration delay:delay];
    CABasicAnimation *lineWidthAnim = [self animationLineWidth:_lineWidth duration:duration delay:delay];
    CABasicAnimation *lineColorAnim = [self animationStrokeColor:toColor duration:duration delay:delay];
    CABasicAnimation *circlePathAnim= [self animationCirclePath:fitterdRadius duration:duration delay:delay];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {}];
    
    [_ringLayer addAnimation:fillColorAnim forKey:nil];
    [_ringLayer addAnimation:lineColorAnim forKey:nil];
    [_ringLayer addAnimation:lineWidthAnim forKey:nil];
    [_ringLayer addAnimation:circlePathAnim forKey:nil];
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
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
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
    
    [_ringLayer addAnimation:lineWidthAni forKey:nil];
    [_ringLayer addAnimation:circlePathAni forKey:collapseAnimation];
}
#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if([anim valueForKey:collapseAnimation]){
        [self removeFromSuperview];
    }
}
@end
