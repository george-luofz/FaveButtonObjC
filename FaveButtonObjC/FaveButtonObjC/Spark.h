//
//  Spark.h
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NSArray<NSNumber *> DotRadius;

@class FaveButton;
@interface Spark : UIView

- (void)animateIgniteShow:(CGFloat)radius duration:(CGFloat)duraton delay:(CGFloat)delay;

- (void)animateIgniteHide:(CGFloat)duration delay:(CGFloat)delay;

+ (instancetype)createSpark:(FaveButton *)faveButton radius:(CGFloat)radius firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor angle:(CGFloat)angle dotRadius:(DotRadius *)dotRadius;
@end
