//
//  LZPlusButton.m
//  LZTabBarFramework
//
//  Created by 刘梓颖 on 16/5/1.
//  Copyright © 2016年 LZING. All rights reserved.
//

#import "LZPlusButton.h"
#import "LZTabBarController.h"

CGFloat LZPlusButtonWidth = 0.0f;
UIButton<LZPlusButtonSubclassing> *LZExternPlusButton = nil;
UIViewController *LZPlusChildViewController = nil;

@implementation LZPlusButton

#pragma mark - Private Methods

+ (void)registerSubclass {
    if ([self conformsToProtocol:@protocol(LZPlusButtonSubclassing)]) {
        Class<LZPlusButtonSubclassing> class = self;
        UIButton<LZPlusButtonSubclassing> *plusButton = [class plusButton];
        LZExternPlusButton = plusButton;
        LZPlusButtonWidth = plusButton.frame.size.width;
        if ([[self class] respondsToSelector:@selector(plusChildViewController)]) {
            LZPlusChildViewController = [class plusChildViewController];
            [[self class] addSelectViewControllerTarget:plusButton];
            if ([[self class] respondsToSelector:@selector(indexOfPlusButtonInTabBar)]) {
                LZPlusButtonIndex = [[self class] indexOfPlusButtonInTabBar];
            } else {
                [NSException raise:@"LZTabBarController" format:@"If you want to add PlusChildViewController, you must realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果你想使用PlusChildViewController样式，你必须同时在你自定义的plusButton中实现 `+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
            }
        }
        
    }
}

+ (void)addSelectViewControllerTarget:(UIButton<LZPlusButtonSubclassing> *)plusButton {
    id target = self;
    NSArray<NSString *> *selectorNamesArray = [plusButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    if (selectorNamesArray.count == 0) {
        target = plusButton;
        selectorNamesArray = [plusButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    }
    [selectorNamesArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL selector =  NSSelectorFromString(obj);
        [plusButton removeTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }];
    [plusButton addTarget:plusButton action:@selector(plusChildViewControllerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)plusChildViewControllerButtonClicked:(UIButton<LZPlusButtonSubclassing> *)sender {
    sender.selected = YES;
    [self lz_tabBarController].selectedIndex = LZPlusButtonIndex;
}

@end
