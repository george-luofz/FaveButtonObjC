//
//  FaveIcon.h
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaveIcon : UIView

+ (nullable instancetype)createFaveIcon:(UIView *)onView icon:(UIImage *)icon color:(UIColor *)color;

- (void)ainmateSelect:(BOOL)isSelected fillColor:(UIColor *)fillColor duration:(CGFloat) duration delay:(CGFloat)delay;
@end
