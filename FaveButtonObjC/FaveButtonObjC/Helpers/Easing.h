//
//  Easing.h
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Easing : NSObject

+ (CGFloat)EaseIn:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d;

+ (CGFloat)EaseOut:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d;

+ (CGFloat)EaseInOut:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d;

+ (CGFloat)ExtendedEaseIn:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d a:(CGFloat)a p:(CGFloat)p;

+ (CGFloat)ExtendedEaseOut:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d a:(CGFloat)a p:(CGFloat)p;

+ (CGFloat)ExtendedEaseInOut:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d a:(CGFloat)a p:(CGFloat)p;
@end
