//
//  ViewController.m
//  FaveButtonObjCDemo
//
//  Created by 罗富中 on 2018/1/23.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "ViewController.h"
#import "Easing.h"
#import "FaveButton.h"

@interface ViewController () <FaveButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    FaveButton *faveButton1 = [[FaveButton alloc] initWithFrame:CGRectMake(10, 100, 44, 44)];
//    faveButton1.delegate = self;
//
//    [self.view addSubview:faveButton1];
    
    
}

#pragma mark -- faveButton delegate
- (NSArray<DotColors *> *)faveButtonDotColors:(FaveButton *)faveButton{
    return nil;
}

- (void)faveButton:(FaveButton *)faveButton didSelected:(BOOL)selected{
    
}
@end
