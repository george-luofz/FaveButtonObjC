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

@interface FaveButton(){
    CGFloat duration;
    CGFloat expandDuration;
    CGFloat collapseDuration;
    CGFloat faveIconShowDelay;
    NSArray *dotRadiusFactors;
    NSInteger sparkGroupCount;
    
    UIImage     *faveIconImage;
    FaveIcon    *faveIcon;
}
@end

@implementation FaveButton

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self applyInit];
}

- (instancetype)initWithFrame:(CGRect)frame normalImage:(UIImage *)normalImage{
    if(self = [super initWithFrame:frame]){
        [self setImage:normalImage forState:UIControlStateNormal];
        [self applyInit];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self animateSelect:self.isSelected duration:duration];
}

#pragma mark - configure
- (void)applyInit{
    duration            = 1.0;
    expandDuration      = 0.1298;
    collapseDuration    = 0.1089;
    faveIconShowDelay   = expandDuration + collapseDuration / 2.0;
    dotRadiusFactors    = @[@(0.0633),@(0.04)];
    sparkGroupCount     = 7;
    
    _normalColor         = RGBA(137, 156, 127, 1);
    _selectedColor       = RGBA(226, 38, 77, 1);
    _dotFirstColor       = RGBA(152, 219, 236, 1);
    _dotSecondColor      = RGBA(247, 188, 48, 1);
    _circleFromColor     = RGBA(221, 70, 136, 1);
    _circleToColor       = RGBA(205, 143, 246, 1);
    
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
    return [FaveIcon createFaveIcon:self icon:faveIconImage color:_normalColor];
}

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
    NSMutableArray *sparks = [NSMutableArray array];
    CGFloat        step    = 360.0 / sparkGroupCount;
    CGFloat        base    = self.bounds.size.width;
    NSArray        *dotRadius = @[@(base * [dotRadiusFactors.firstObject doubleValue]),@(base * [dotRadiusFactors.lastObject doubleValue])];
    CGFloat        offSet  = 10.f;
    
    for(int index = 0; index < sparkGroupCount ;index++){
        CGFloat theta = step * index + offSet;
        DotColors *colors = [self dotColors:index];
        
        Spark *spark = [Spark createSpark:self radius:radius firstColor:colors.firstObject secondColor:colors.lastObject angle:theta dotRadius:dotRadius];
        [sparks addObject:spark];
    }
    return sparks;
}

- (DotColors *)dotColors:(int) index{
    if(self.delegate && [self.delegate respondsToSelector:@selector(faveButtonDotColors:)]){
        NSArray *colors = [self.delegate faveButtonDotColors:self];
        int colorIndex = index < colors.count? index :index % colors.count;
        return colors[colorIndex];
    }
    return @[_dotFirstColor,_dotSecondColor];
}
#pragma mark - animation
- (void)animateSelect:(BOOL)isSelected duration:(CGFloat)duration{
    UIColor *color = isSelected? _selectedColor : _normalColor;
    [faveIcon ainmateSelect:isSelected fillColor:color duration:duration delay:faveIconShowDelay];
    
    if(isSelected){
        CGFloat radius = self.bounds.size.width * 1.3 / 2;
        CGFloat igniteFromRadius = radius * 0.8;
        CGFloat igniteToRadius   = radius * 1.1;
        
        Ring *ring = [Ring createRing:self radius:0.01 lineWidth:3 fillColor:_circleFromColor];
        NSArray *sparks = [self createSparks:igniteFromRadius];
        
        [ring animateToRadius:radius toColor:_circleToColor duration:expandDuration delay:0];
        [ring animateColapse:radius duration:collapseDuration delay:expandDuration];
        
        for (Spark *spark in sparks) {
            [spark animateIgniteShow:igniteToRadius duration:0.4 delay:collapseDuration / 3.0];
            [spark animateIgniteHide:0.7 delay:0.2];
        }
    }
}
@end
