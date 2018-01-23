//
//  FaveButton.m
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "FaveButton.h"
#import "FaveIcon.h"
#import "Ring.h"
#import "Spark.h"

#define RGBA(a,b,c,p) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:p]

@interface FaveButton(){
    CGFloat duration;
    CGFloat expandDuration;
    CGFloat collapseDuration;
    CGFloat faveIconShowDelay;
    NSArray *dotRadiusFactors;
    NSInteger sparkGroupCount;
    
    UIColor     *normalColor;
    UIColor     *selectedColor;
    UIColor     *dotFirstColor;
    UIColor     *dotSecondColor;
    UIColor     *circleFromColor;
    UIColor     *circleToColor;
    
    UIImage     *faveIconImage;
    FaveIcon    *faveIcon;
}

@end

@implementation FaveButton

- (instancetype)init{
    if (self = [super init]){
        duration            = 1.0;
        expandDuration      = 0.1298;
        collapseDuration    = 0.1089;
        faveIconShowDelay   = expandDuration + collapseDuration / 2.0;
        dotRadiusFactors    = @[@(0.0633),@(0.04)];
        sparkGroupCount     = 7;
        
        normalColor         = RGBA(137, 156, 127, 1);
        selectedColor       = RGBA(226, 38, 77, 1);
        dotFirstColor       = RGBA(152, 219, 236, 1);
        dotSecondColor      = RGBA(247, 188, 48, 1);
        circleFromColor     = RGBA(221, 70, 136, 1);
        circleToColor       = RGBA(205, 143, 246, 1);
        
        [self applyInit];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame faveIconNormal:(UIImage *)faveIconNormal{
    if(self = [super initWithFrame:frame]){
        faveIconImage = faveIconNormal;
//        [self applyInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
//        [self applyInit];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
//    self.selected = selected;
    //TODO
    [self animateSelect:self.isSelected duration:duration];
}

#pragma mark - configure
- (void)applyInit{
    if(nil == faveIconImage){
        faveIconImage = [self imageForState:UIControlStateNormal];
    }
    
    [self setImage:[UIImage new] forState:UIControlStateNormal];
    [self setImage:[UIImage new] forState:UIControlStateSelected];
    [self setTitle:nil forState:UIControlStateNormal];
    [self setTitle:nil forState:UIControlStateSelected];
    
    faveIcon = [self createFaveIcon:faveIconImage];
    [self addActions];
}

- (FaveIcon *)createFaveIcon:(UIImage *)faveIconImage{
    return [FaveIcon createFaveIcon:self icon:faveIconImage color:normalColor];
}

//TODO sparks

- (void)addActions{
    [self addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)toggle:(FaveButton *)sender{
    sender.selected = !sender.isSelected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(faveButton:didSelected:)]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate faveButton:sender didSelected:sender.isSelected];
        });
    }
}
#pragma mark - spark
- (NSArray<Spark *> *)createSparks:(CGFloat)radius{
    //TODO:
    return nil;
}
#pragma mark - animation
- (void)animateSelect:(BOOL)isSelected duration:(CGFloat)duration{
    UIColor *color = isSelected? selectedColor : normalColor;
    [faveIcon ainmateSelect:isSelected fillColor:color duration:duration delay:faveIconShowDelay];
    
    if(isSelected){
        CGFloat radius = self.bounds.size.width * 1.3 / 2;
        CGFloat igniteFromRadius = radius * 0.8;
        CGFloat igniteToRadius   = radius * 1.1;
        
        Ring *ring = [Ring createRing:self radius:0.01 lineWidth:3 fillColor:circleFromColor];
        NSArray *sparks = [self createSparks:igniteFromRadius];
        
        [ring animateToRadius:radius toColor:circleToColor duration:expandDuration];
        [ring animateColapse:radius duration:collapseDuration delay:expandDuration];
        
        for (Spark *spark in sparks) {
            [spark animateIgniteShow:igniteToRadius duration:0.4 delay:collapseDuration / 3.0];
            [spark animateIgniteHide:0.7 delay:0.2];
        }
    }
}
@end
