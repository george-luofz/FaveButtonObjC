//
//  Easing.m
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "Easing.h"

@implementation Easing

+ (CGFloat)EaseIn:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d{
    if(t == 0) return b;
    t /= d;
    if(t == 1) return b + c;
    
    CGFloat p = d * 0.3;
    CGFloat a = c;
    CGFloat s = p / 4;
    
    t -= 1;
    return - (a*pow(2, 10*t) * sin((t * d - s) * (2 * (CGFloat)(M_PI / p)))) + b;
}

+ (CGFloat)EaseOut:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d{
    if(t == 0) return b;
    t /= d;
    if(t == 1) return b + c;
    
    CGFloat p = d * 0.3;
    CGFloat a = c;
    CGFloat s = p / 4;
    
    return (a*pow(2, -10*t) * sin((t * d - s) * (2 * (CGFloat)(M_PI / p)))) + b + c;
}

+ (CGFloat)EaseInOut:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d{
    if(t == 0) return b;
    t = t / (d/2);
    if(t == 2) return b + c;
    
    CGFloat p = d * (0.3 * 1.5);
    CGFloat a = c;
    CGFloat s = p / 4;
    
    if(t < 1){
        t -= 1;
        return -0.5*(a * pow(2,10 * t) * sin((t*d-s)*(2 * (CGFloat)(M_PI))/p)) + b;
    }
    t -= 1;
    return a * pow(2,-10*t) * sin((t*d-s)*(2*(CGFloat)(M_PI))/p )*0.5 + c + b;
}

+ (CGFloat)ExtendedEaseIn:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d a:(CGFloat)a p:(CGFloat)p{
    CGFloat s = 0.0;
    
    if(t == 0) return b;
    
    t /= d;
    if(t == 1) return b + c;
    
    if (a < fabs(c)) {
        a = c;
        s = p/4;
    }else {
        s = p/(2* (CGFloat)(M_PI)) * asin(c/a);
    }
    
    t -= 1;
    return -(a* pow(2,10*t) * sin((t*d-s)*(2*(CGFloat)(M_PI))/p )) + b;
}

+ (CGFloat)ExtendedEaseOut:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d a:(CGFloat)a p:(CGFloat)p{
    CGFloat s = 0.0;

    if (t==0) return b;
    
    t /= d;
    if (t==1) return b+c;
    
    if (a < fabs(c)) {
        a = c;
        s = p/4;
    }else {
        s = p/(2* (CGFloat)(M_PI)) * asin(c/a);
    }
    return (a*pow(2,-10*t) * sin((t*d-s)*(2*(CGFloat)(M_PI))/p ) + c + b);
}

+ (CGFloat)ExtendedEaseInOut:(CGFloat)t b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d a:(CGFloat)a p:(CGFloat)p{
    CGFloat s = 0.0;
    
    if (t==0) return b;
    
    t /= d/2;
    
    if (t==2) return b+c;
    
    if (a < fabs(c)) {
        a=c;
        s=p/4;
    }else {
        s = p/(2*(CGFloat)(M_PI)) * asin (c/a);
    }
    
    if (t < 1) {
        t -= 1;
        return -0.5*(a*pow(2,10*t) * sin( (t*d-s)*(2*(CGFloat)(M_PI))/p )) + b;
    }
    t -= 1;
    return a*pow(2,-10*t) * sin((t*d-s)*(2*(CGFloat)(M_PI))/p )*0.5 + c + b;
}

@end
