//
//  UIViewController+LZJumpToOtherTabBarControllerItem.h
//  LZTabBarFramework
//
//  Created by 刘梓颖 on 16/5/1.
//  Copyright © 2016年 LZING. All rights reserved.
//

@import UIKit;

@interface UIViewController (LZJumpToOtherTabBarControllerItem)

/*!
 * This will invoke like this: `-[ClassTypeOject selector:arguments]`.
 */
- (void)lz_jumpToOtherTabBarControllerItem:(Class)ClassType
                            performSelector:(SEL)selector
                                  arguments:(NSArray *)arguments;
/*!
 * This will invoke like this: `-[ClassTypeOject selector:arguments]`.
 */
- (void)lz_jumpToOtherTabBarControllerItem:(Class)ClassType
                            performSelector:(SEL)selector
                                  arguments:(NSArray *)arguments
                                returnValue:(void *)returnValue;

@end
