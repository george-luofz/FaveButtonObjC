//
//  FaveButton.h
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBA(a,b,c,p) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:p]
typedef NSArray<UIColor *> DotColors;

@class FaveButton;
@protocol FaveButtonDelegate <NSObject>

- (void)faveButton:(nullable FaveButton *)faveButton didSelected:(BOOL)selected;

- (nullable NSArray<DotColors *> *)faveButtonDotColors:(nullable FaveButton *)faveButton;

@end

@interface FaveButton : UIButton

@property (nonatomic, nullable, weak) id<FaveButtonDelegate>        delegate;

@property (nonatomic, strong) IBInspectable UIColor *normalColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedColor;
@property (nonatomic, strong) IBInspectable UIColor *dotFirstColor;
@property (nonatomic, strong) IBInspectable UIColor *dotSecondColor;
@property (nonatomic, strong) IBInspectable UIColor *circleFromColor;
@property (nonatomic, strong) IBInspectable UIColor *circleToColor;

//- (nullable instancetype)initWithFrame:(CGRect)frame faveIconNormal:(nullable UIImage *)faveIconNormal;

@end
