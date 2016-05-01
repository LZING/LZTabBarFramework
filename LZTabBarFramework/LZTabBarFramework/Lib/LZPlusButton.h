//
//  LZPlusButton.h
//  LZTabBarFramework
//
//  Created by 刘梓颖 on 16/5/1.
//  Copyright © 2016年 LZING. All rights reserved.
//

@import UIKit;

@protocol LZPlusButtonSubclassing

@required
+ (id)plusButton;
@optional

/*!
 用来自定义加号按钮的位置，如果不实现默认居中，但是如果 tabbar 的个数是奇数则必须实现该方法，否则 LZTabBarController 会抛出 exception 来进行提示。
 
 @return CGFloat 用来自定义加号按钮在tabbar中的位置
 *
 */
+ (NSUInteger)indexOfPlusButtonInTabBar;

/*!
 该方法是为了调整自定义按钮中心点Y轴方向的位置，建议在按钮超出了 tabbar 的边界时实现该方法。
 
 @return CGFloat 返回值是自定义按钮中心点Y轴方向的坐标除以 tabbar 的高度，如果不实现，会自动进行比对，预设一个较为合适的位置，如果实现了该方法，预设的逻辑将失效。
 *
 */
+ (CGFloat)multiplerInCenterY;

/*!
 实现该方法后，能让 PlusButton 的点击效果与跟点击其他 UITabBarButton 效果一样，跳转到该方法指定的 UIViewController 。
 @attention 必须同时实现 `+indexOfPlusButtonInTabBar` 来指定 PlusButton 的位置。
 @return UIViewController 指定 PlusButton 点击后跳转的 UIViewController。
 *
 */
+ (UIViewController *)plusChildViewController;

@end

@class LZTabBar;

FOUNDATION_EXTERN UIButton<LZPlusButtonSubclassing> *LZExternPlusButton;
FOUNDATION_EXTERN UIViewController *LZPlusChildViewController;

@interface LZPlusButton : UIButton

+ (void)registerSubclass;

- (void)plusChildViewControllerButtonClicked:(UIButton<LZPlusButtonSubclassing> *)sender;

@end
