//
//  FaveButton.h
//  FaveButtonObjC
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray<UIColor *> DotColors;

@class FaveButton;
@protocol FaveButtonDelegate <NSObject>

- (void)faveButton:(nullable FaveButton *)faveButton didSelected:(BOOL)selected;

- (nullable DotColors*)faveButtonDotColors:(nullable FaveButton *)faveButton;

@end

@interface FaveButton : UIButton

@property (nonatomic, nullable, weak) id<FaveButtonDelegate>        delegate;

- (nullable instancetype)initWithFrame:(CGRect)frame faveIconNormal:(nullable UIImage *)faveIconNormal;

//- (instancetype)initWithCoder:(NSCoder *)aDecoder;
@end
