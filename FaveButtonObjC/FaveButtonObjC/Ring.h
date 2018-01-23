//
//  Ring.h
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ring : UIView

+ (nullable instancetype)createRing:(UIView *)onView radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth fillColor:(UIColor *)fillColor;

- (void)animateToRadius:(CGFloat)radius toColor:(UIColor *)toColor duration:(CGFloat)duration;

- (void)animateColapse:(CGFloat)radius duration:(CGFloat)duraton delay:(CGFloat)delay;
@end
