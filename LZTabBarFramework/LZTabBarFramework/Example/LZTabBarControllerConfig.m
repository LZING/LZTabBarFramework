//
//  LZTabBarControllerConfig.m
//  LZTabBarFramework
//
//  Created by 刘梓颖 on 16/5/1.
//  Copyright © 2016年 LZING. All rights reserved.
//
#import "LZTabBarControllerConfig.h"

@interface LZBaseNavigationController : UINavigationController


@end

@implementation LZBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end

//View Controllers
#import "LZHomeViewController.h"
#import "LZPurseViewController.h"
#import "LZStatementViewController.h"
#import "LZMineViewController.h"

@interface LZTabBarControllerConfig ()

@property (nonatomic, readwrite, strong) LZTabBarController *tabBarController;

@end

@implementation LZTabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return LZTabBarController
 */
- (LZTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        LZHomeViewController *firstViewController = [[LZHomeViewController alloc] init];
        UIViewController *firstNavigationController = [[LZBaseNavigationController alloc]
                                                       initWithRootViewController:firstViewController];
        
        LZPurseViewController *secondViewController = [[LZPurseViewController alloc] init];
        UIViewController *secondNavigationController = [[LZBaseNavigationController alloc]
                                                        initWithRootViewController:secondViewController];
        
        LZStatementViewController *thirdViewController = [[LZStatementViewController alloc] init];
        UIViewController *thirdNavigationController = [[LZBaseNavigationController alloc]
                                                       initWithRootViewController:thirdViewController];
        
        LZMineViewController *fourthViewController = [[LZMineViewController alloc] init];
        UIViewController *fourthNavigationController = [[LZBaseNavigationController alloc]
                                                        initWithRootViewController:fourthViewController];
        LZTabBarController *tabBarController = [[LZTabBarController alloc] init];
        
        // 在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
        [self setUpTabBarItemsAttributesForController:tabBarController];
        
        [tabBarController setViewControllers:@[
                                               firstNavigationController,
                                               secondNavigationController,
                                               thirdNavigationController,
                                               fourthNavigationController
                                               ]];
        // 更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

/**
 *  在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
 */
- (void)setUpTabBarItemsAttributesForController:(LZTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            LZTabBarItemTitle : @"明细",
                            LZTabBarItemImage : @"detail_normal",
                            LZTabBarItemSelectedImage : @"detail_highlight",
                            };
    NSDictionary *dict2 = @{
                            LZTabBarItemTitle : @"钱包",
                            LZTabBarItemImage : @"purse_normal",
                            LZTabBarItemSelectedImage : @"purse_highlight",
                            };
    NSDictionary *dict3 = @{
                            LZTabBarItemTitle : @"报表",
                            LZTabBarItemImage : @"statement_normal",
                            LZTabBarItemSelectedImage : @"statement_highlight",
                            };
    NSDictionary *dict4 = @{
                            LZTabBarItemTitle : @"我的",
                            LZTabBarItemImage : @"mine_normal",
                            LZTabBarItemSelectedImage : @"mine_highlight"
                            };
    NSArray *tabBarItemsAttributes = @[
                                       dict1,
                                       dict2,
                                       dict3,
                                       dict4
                                       ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
#warning CUSTOMIZE YOUR TABBAR APPEARANCE
- (void)customizeTabBarAppearance:(LZTabBarController *)tabBarController {
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    //    [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight， remove the comment '//'
    //如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    //    [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"color"]]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    //     UITabBar *tabBarAppearance = [UITabBar appearance];
    //     [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    //remove the bar system shadow image
    //去除 TabBar 自带的顶部阴影
    //    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait){
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:LZTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    UITabBarController *tabBarController = [self lz_tabBarController] ?: [[UITabBarController alloc] init];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    CGSize selectionIndicatorImageSize = CGSizeMake(LZTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self lz_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor grayColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
