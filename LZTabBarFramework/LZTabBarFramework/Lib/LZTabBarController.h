//
//  LZTabBarController.h
//  LZTabBarFramework
//
//  Created by 刘梓颖 on 16/5/1.
//  Copyright © 2016年 LZING. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const LZTabBarItemTitle;
FOUNDATION_EXTERN NSString *const LZTabBarItemImage;
FOUNDATION_EXTERN NSString *const LZTabBarItemSelectedImage;
FOUNDATION_EXTERN NSString *const LZTabBarItemWidthDidChangeNotification;
FOUNDATION_EXTERN NSUInteger LZTabbarItemsCount;
FOUNDATION_EXTERN NSUInteger LZPlusButtonIndex;
FOUNDATION_EXTERN CGFloat LZPlusButtonWidth;
FOUNDATION_EXTERN CGFloat LZTabBarItemWidth;

@interface LZTabBarController : UITabBarController

/*!
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, readwrite, copy) NSArray<UIViewController *> *viewControllers;

/*!
 * The Attributes of items which is displayed on the tab bar.
 */
@property (nonatomic, readwrite, copy) NSArray<NSDictionary *> *tabBarItemsAttributes;

/*!
 * Judge if there is plus button.
 */
+ (BOOL)havePlusButton;

/*!
 * Include plusButton if exists.
 */
+ (NSUInteger)allItemsInTabBarCount;

- (id<UIApplicationDelegate>)appDelegate;
- (UIWindow *)rootWindow;

@end

@interface NSObject (LZTabBarController)

/**
 * If `self` is kind of `UIViewController`, this method will return the nearest ancestor in the view controller hierarchy that is a tab bar controller. If `self` is not kind of `UIViewController`, it will return the `rootViewController` of the `rootWindow` as long as you have set the `LZTabBarController` as the  `rootViewController`. Otherwise return nil. (read-only)
 */
@property (nonatomic, readonly) LZTabBarController *lz_tabBarController;

@end
