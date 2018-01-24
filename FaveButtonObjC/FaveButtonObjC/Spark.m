//
//  Spark.m
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "Spark.h"
#import "FaveButton.h"

static NSString *const  expandKey = @"expandKey";
static NSString *const  dotSizeKey= @"dotSizeKey";

@interface Spark(){
    CGFloat     radius;
    UIColor     *firstColor;
    UIColor     *secondColor;
    CGFloat     angle;
    
    DotRadius   *dotRadius;
    
    UIView      *dotFirst;
    UIView      *dotSecond;
    
}
@property(nonatomic,nullable,strong)    NSLayoutConstraint      *distanceConstraint;
@end
@implementation Spark

- (instancetype)initWithRadius:(CGFloat)radius firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor angle:(CGFloat)angle dotRadius:(DotRadius *)dotRadius{
    if(self = [super init]){
        radius      = radius;
        firstColor  = firstColor;
        secondColor = secondColor;
        angle       = angle;
        dotRadius   = dotRadius;
        
        [self applyInit];
    }
    return self;
}

- (void)applyInit{
    dotFirst    = [self createDotView:[dotRadius.firstObject doubleValue] fillColor:firstColor];
    dotSecond   = [self createDotView:[dotRadius.lastObject doubleValue] fillColor:secondColor];
    
    NSLayoutConstraint *width1Constraint = [NSLayoutConstraint constraintWithItem:dotFirst attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2 * [dotRadius.firstObject doubleValue]];
    NSLayoutConstraint *height1Constraint = [NSLayoutConstraint constraintWithItem:dotFirst attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2 * [dotRadius.firstObject doubleValue]];
    NSLayoutConstraint *trailing1Constraint = [NSLayoutConstraint constraintWithItem:dotFirst attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:1];
    NSLayoutConstraint *bottom1Constraint = [NSLayoutConstraint constraintWithItem:dotFirst attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:dotSecond attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *width2Constraint = [NSLayoutConstraint constraintWithItem:dotSecond attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2 * [dotRadius.lastObject doubleValue]];
    NSLayoutConstraint *height2Constraint = [NSLayoutConstraint constraintWithItem:dotSecond attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2 * [dotRadius.lastObject doubleValue]];
    NSLayoutConstraint *leading2Constraint = [NSLayoutConstraint constraintWithItem:dotSecond attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:1];
    NSLayoutConstraint *top2Constraint = [NSLayoutConstraint constraintWithItem:dotSecond attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:2 * [dotRadius.firstObject doubleValue] + 4.0];
    width1Constraint.identifier     = dotSizeKey;
    height1Constraint.identifier    = dotSizeKey;
    width2Constraint.identifier     = dotSizeKey;
    height2Constraint.identifier    = dotSizeKey;
    self.distanceConstraint = bottom1Constraint;
    
    [dotFirst addConstraints:@[width1Constraint,height1Constraint]];
    [dotSecond addConstraints:@[width2Constraint,height2Constraint]];
    [self addConstraints:@[trailing1Constraint,bottom1Constraint,leading2Constraint,top2Constraint]];
    
    self.transform = CGAffineTransformMakeRotation(angle * M_PI / 180);  //
}

- (UIView *)createDotView:(CGFloat)radius fillColor:(UIColor *)fillColor {
    UIView *dot = [[UIView alloc] init];
    dot.translatesAutoresizingMaskIntoConstraints = NO;
    dot.backgroundColor     = fillColor;
    dot.layer.cornerRadius  = radius;
    [self addSubview:dot];
    return dot;
}

+ (instancetype)createSpark:(FaveButton *)faveButton radius:(CGFloat)radius firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor angle:(CGFloat)angle dotRadius:(DotRadius *)dotRadius{
    Spark *spark = [[Spark alloc] initWithRadius:radius firstColor:firstColor secondColor:secondColor angle:angle dotRadius:dotRadius];
    spark.translatesAutoresizingMaskIntoConstraints  = NO;
    spark.backgroundColor    = [UIColor clearColor];
    spark.layer.anchorPoint  = CGPointMake(0.5, 1);
    spark.alpha              = 0;
    
    [faveButton.superview insertSubview:spark belowSubview:faveButton];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:faveButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:2 * [dotRadius.firstObject doubleValue] + 2 * [dotRadius.lastObject doubleValue]];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:spark attribute:NSLayoutAttributeHeight     relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:radius + 2 * [dotRadius.firstObject doubleValue] + 2 * [dotRadius.lastObject doubleValue]];
    heightConstraint.identifier = expandKey;
    
    
    [spark addConstraints:@[widthConstraint,heightConstraint]];
    [faveButton addConstraints:@[centerXConstraint,centerYConstraint]];
    return spark;
}
#pragma mark - animation
- (void)animateIgniteShow:(CGFloat)radius duration:(CGFloat)duraton delay:(CGFloat)delay{
    [self layoutIfNeeded];
    
    CGFloat diameter = [dotRadius.firstObject doubleValue] * 2.0 + [dotRadius.lastObject doubleValue] * 2.0;
    CGFloat height   = radius + diameter + 4;
    
    for(NSLayoutConstraint *constraint in self.constraints){
        if([constraint.identifier isEqualToString:expandKey]){
            constraint.constant = height;
        }
    }
    
    [UIView animateWithDuration:0 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1.f;
    } completion:nil];
    [UIView animateWithDuration:duraton * 0.7 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)animateIgniteHide:(CGFloat)duration delay:(CGFloat)delay{
    [self layoutIfNeeded];
    self.distanceConstraint.constant = - 4;
    
    [UIView animateWithDuration:duration * 0.5 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        dotSecond.backgroundColor = firstColor;
        dotFirst.backgroundColor = secondColor;
    } completion:nil];
    
    for(UIView *view in @[dotFirst,dotSecond]){
        [view setNeedsLayout];
        for(NSLayoutConstraint *constraint in view.constraints){
            if([constraint.identifier isEqualToString:dotSizeKey]){
                constraint.constant = 0;
            }
        }
    }
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [dotSecond layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:duration * 1.7 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [dotFirst layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
