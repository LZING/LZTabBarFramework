//
//  LZTabBarController.m
//  LZTabBarFramework
//
//  Created by 刘梓颖 on 16/5/1.
//  Copyright © 2016年 LZING. All rights reserved.
//

#import "LZTabBarController.h"
#import "LZTabBar.h"
#import "LZPlusButton.h"
#import <objc/runtime.h>

NSString *const LZTabBarItemTitle = @"LZTabBarItemTitle";
NSString *const LZTabBarItemImage = @"LZTabBarItemImage";
NSString *const LZTabBarItemSelectedImage = @"LZTabBarItemSelectedImage";

NSUInteger LZTabbarItemsCount = 0;
NSUInteger LZPlusButtonIndex = 0;
CGFloat LZTabBarItemWidth = 0.0f;
NSString *const LZTabBarItemWidthDidChangeNotification = @"LZTabBarItemWidthDidChangeNotification";

@interface NSObject (LZTabBarControllerItemInternal)

- (void)lz_setTabBarController:(LZTabBarController *)tabBarController;

@end
@interface LZTabBarController () <UITabBarControllerDelegate>

@end
@implementation LZTabBarController

@synthesize viewControllers = _viewControllers;

#pragma mark -
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 处理tabBar，使用自定义 tabBar 添加 发布按钮
    [self setUpTabBar];
    self.delegate = self;
}

#pragma mark - Private Methods

/**
 *  利用 KVC 把系统的 tabBar 类型改为自定义类型。
 */
- (void)setUpTabBar {
    [self setValue:[[LZTabBar alloc] init] forKey:@"tabBar"];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        if ((!_tabBarItemsAttributes) || (_tabBarItemsAttributes.count != viewControllers.count)) {
            [NSException raise:@"LZTabBarController" format:@"The count of LZTabBarControllers is not equal to the count of tabBarItemsAttributes.【Chinese】设置_tabBarItemsAttributes属性时，请确保元素个数与控制器的个数相同，并在方法`-setViewControllers:`之前设置"];
        }
        
        if (LZPlusChildViewController) {
            NSMutableArray *viewControllersWithPlusButton = [NSMutableArray arrayWithArray:viewControllers];
            [viewControllersWithPlusButton insertObject:LZPlusChildViewController atIndex:LZPlusButtonIndex];
            _viewControllers = [viewControllersWithPlusButton copy];
        } else {
            _viewControllers = [viewControllers copy];
        }
        LZTabbarItemsCount = [viewControllers count];
        LZTabBarItemWidth = ([UIScreen mainScreen].bounds.size.width - LZPlusButtonWidth) / (LZTabbarItemsCount);
        NSUInteger idx = 0;
        for (UIViewController *viewController in _viewControllers) {
            NSString *title = nil;
            NSString *normalImageName = nil;
            NSString *selectedImageName = nil;
            if (viewController != LZPlusChildViewController) {
                title = _tabBarItemsAttributes[idx][LZTabBarItemTitle];
                normalImageName = _tabBarItemsAttributes[idx][LZTabBarItemImage];
                selectedImageName = _tabBarItemsAttributes[idx][LZTabBarItemSelectedImage];
            } else {
                idx--;
            }
            
            [self addOneChildViewController:viewController
                                  WithTitle:title
                            normalImageName:normalImageName
                          selectedImageName:selectedImageName];
            [viewController lz_setTabBarController:self];
            idx++;
        }
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController lz_setTabBarController:nil];
        }
        _viewControllers = nil;
    }
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param normalImageName   图片
 *  @param selectedImageName 选中图片
 */
- (void)addOneChildViewController:(UIViewController *)viewController
                        WithTitle:(NSString *)title
                  normalImageName:(NSString *)normalImageName
                selectedImageName:(NSString *)selectedImageName {
    
    viewController.tabBarItem.title = title;
    if (normalImageName) {
        UIImage *normalImage = [UIImage imageNamed:normalImageName];
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.image = normalImage;
    }
    if (selectedImageName) {
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.selectedImage = selectedImage;
    }
    [self addChildViewController:viewController];
}

+ (BOOL)havePlusButton {
    if (LZExternPlusButton) {
        return YES;
    }
    return NO;
}

+ (NSUInteger)allItemsInTabBarCount {
    NSUInteger allItemsInTabBar = LZTabbarItemsCount;
    if ([LZTabBarController havePlusButton]) {
        allItemsInTabBar += 1;
    }
    return allItemsInTabBar;
}

- (id<UIApplicationDelegate>)appDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (UIWindow *)rootWindow {
    UIWindow *result = nil;
    
    do {
        if ([self.appDelegate respondsToSelector:@selector(window)]) {
            result = [self.appDelegate window];
        }
        
        if (result) {
            break;
        }
    } while (NO);
    
    return result;
}

#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController*)viewController {
    NSUInteger selectedIndex = tabBarController.selectedIndex;
    UIButton *plusButton = LZExternPlusButton;
    if (LZPlusChildViewController) {
        if ((selectedIndex == LZPlusButtonIndex) && (viewController != LZPlusChildViewController)) {
            plusButton.selected = NO;
        } 
    }
    return YES;
}

@end

#pragma mark - NSObject+LZTabBarControllerItem

@implementation NSObject (LZTabBarControllerItemInternal)

- (void)lz_setTabBarController:(LZTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(lz_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation NSObject (LZTabBarController)

- (LZTabBarController *)lz_tabBarController {
    LZTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(lz_tabBarController));
    if (!tabBarController ) {
        if ([self isKindOfClass:[UIViewController class]] && [(UIViewController *)self parentViewController]) {
            tabBarController = [[(UIViewController *)self parentViewController] lz_tabBarController];
        } else {
            id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
            UIWindow *window = delegate.window;
            if ([window.rootViewController isKindOfClass:[LZTabBarController class]]) {
                tabBarController = (LZTabBarController *)window.rootViewController;
            }
        }
    }
    return tabBarController;
}

@end