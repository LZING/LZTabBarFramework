//
//  LZDetailViewController.m
//  LZTabBarFramework
//
//  Created by 刘梓颖 on 16/5/1.
//  Copyright © 2016年 LZING. All rights reserved.
//

#import "LZDetailViewController.h"
#import "LZMineViewController.h"
#import "UIViewController+LZJumpToOtherTabBarControllerItem.h"

@interface LZDetailViewController ()

@end

@implementation LZDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"点击屏幕可跳转到“我的”，执行testPush";
    label.frame = CGRectMake(20, 150, CGRectGetWidth(self.view.frame) - 2 * 20, 20);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self lz_jumpToOtherTabBarControllerItem:[LZMineViewController class] performSelector:@selector(testPush) arguments:nil];
}

@end
