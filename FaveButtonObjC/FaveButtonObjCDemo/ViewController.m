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
@property (weak, nonatomic) IBOutlet FaveButton *heartButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.heartButton.delegate = self;
    
    // test use frame
    [self test1];
}

#pragma mark - test use frame
- (void)test1{
    FaveButton *faveTestButton = [[FaveButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-88)/2, 88, 88, 88) normalImage:[UIImage imageNamed:@"heart"]];
    faveTestButton.delegate = self;
    [self.view addSubview:faveTestButton];
}

#pragma mark -- faveButton delegate
- (NSArray<DotColors *> *)faveButtonDotColors:(FaveButton *)faveButton{
    NSArray *colorArr1 = @[RGBA(125, 194, 244, 1),RGBA(226, 38, 47, 1)];
    NSArray *colorArr2 = @[RGBA(248, 204, 100, 1),RGBA(155, 223, 186, 1)];
    NSArray *colorArr3 = @[RGBA(125, 100, 244, 1),RGBA(56, 38, 23, 1)];
    NSArray *colorArr4 = @[RGBA(248, 200, 100, 1),RGBA(2, 14, 186, 1)];
    NSArray *colorArr5 = @[RGBA(15, 10, 34, 1),RGBA(56, 45, 90, 1)];
    NSArray *colorArr6 = @[RGBA(23, 34, 100, 1),RGBA(2, 45, 49, 1)];
    return @[colorArr1,colorArr2,colorArr3,colorArr4,colorArr5,colorArr6];
}

- (void)faveButton:(FaveButton *)faveButton didSelected:(BOOL)selected{
    // do something after selected
}
@end
