//
//  FaveIcon.m
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "FaveIcon.h"
#import "Easing.h"

@implementation FaveIcon{
    UIColor      *iconColor;
    UIImage      *iconImage;
    CAShapeLayer *iconLayer;
    CALayer      *iconMask;
    CGRect       contentRegion;
    
    NSArray<NSNumber *>   *tweenValues;
}

- (instancetype)init{
    if(self = [super init]){
        iconColor = [UIColor grayColor];
    }
    return self;
}

- (instancetype)initWithRegion:(CGRect)region icon:(UIImage *)icon color:(UIColor *)color{
    if(self = [self init]){
        iconColor       = color;
        iconImage       = icon;
        contentRegion   = region;
        
        [self applyInit];
    }
    return self;
}

+ (instancetype)createFaveIcon:(UIView *)onView icon:(UIImage *)icon color:(UIColor *)color{
    // onView.bounds is not always correct
    FaveIcon *faveIcon = [[self alloc] initWithRegion:onView.bounds icon:icon color:color];
    faveIcon.translatesAutoresizingMaskIntoConstraints = NO;
    faveIcon.backgroundColor = [UIColor clearColor];
    [onView addSubview:faveIcon];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:faveIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:onView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:faveIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:onView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:faveIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:faveIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    
    [onView addConstraints:@[centerXConstraint, centerYConstraint]];
    [faveIcon addConstraints:@[widthConstraint, heightConstraint]];
    return faveIcon;
}

#pragma mark - configure
- (void)applyInit{
    CGSize scaleBySize = CGSizeMake(contentRegion.size.width * 0.7, contentRegion.size.height * 0.7);
    CGPoint center = CGPointMake(contentRegion.size.width / 2.0, contentRegion.size.height / 2.0);

    CGRect maskRegion = CGRectMake(center.x - scaleBySize.width/2, center.y - scaleBySize.height/2, scaleBySize.width, scaleBySize.height);
    CGPoint shapeOrigin = CGPointMake(- center.x, - center.y);
    
    iconMask = [[CALayer alloc] init];
    iconMask.contents = (__bridge id _Nullable)(iconImage.CGImage);
    iconMask.contentsScale = [UIScreen mainScreen].scale;
    iconMask.bounds = maskRegion;
    
    iconLayer = [[CAShapeLayer alloc] init];
    iconLayer.fillColor = iconColor.CGColor;
    iconLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(shapeOrigin.x, shapeOrigin.y, contentRegion.size.width, contentRegion.size.height)].CGPath;
    iconLayer.mask = iconMask;
    
    [self.layer addSublayer:iconLayer];
}

#pragma mark - animate
- (void)ainmateSelect:(BOOL)isSelected fillColor:(UIColor *)fillColor duration:(CGFloat) duration delay:(CGFloat)delay{
    if(nil == tweenValues){
        tweenValues = [self generateTweenValues:0 to:1.0 duration:duration];
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:true];
    iconLayer.fillColor = fillColor.CGColor;
    [CATransaction commit];
    
    CGFloat selectedDelay = isSelected ? delay : 0;
    if(isSelected){
        self.alpha  = 0;
        [UIView animateWithDuration:0 delay:selectedDelay options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {}];
    }
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = tweenValues;
    scaleAnimation.duration = duration;
    scaleAnimation.beginTime = CACurrentMediaTime() + selectedDelay;
    [iconMask addAnimation:scaleAnimation forKey:nil];
}

- (NSArray *)generateTweenValues:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration{
    NSMutableArray *values = [NSMutableArray array];
    CGFloat fps            = 60;
    CGFloat tpf            = duration / fps;
    CGFloat c              = to - from;
    CGFloat d              = duration;
    CGFloat t              = 0.0;
    
    while(t < d){
        CGFloat scale = [Easing ExtendedEaseInOut:t b:from c:c d:d a:c+0.001 p:0.3988]; // p=oscillations, c=amplitude(velocity)
        [values addObject:@(scale)];
        t += tpf;
    }
    return values;
}
@end
