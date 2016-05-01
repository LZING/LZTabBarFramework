//
//  LZTabBar.m
//  LZTabBarFramework
//
//  Created by 刘梓颖 on 16/5/1.
//  Copyright © 2016年 LZING. All rights reserved.
//

#import "LZTabBar.h"
#import "LZPlusButton.h"
#import "LZTabBarController.h"

static void *const LZTabBarContext = (void*)&LZTabBarContext;

@interface LZTabBar ()

/** 发布按钮 */
@property (nonatomic, strong) UIButton<LZPlusButtonSubclassing> *plusButton;
@property (nonatomic, assign) CGFloat tabBarItemWidth;
@end

@implementation LZTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)sharedInit {
    if (LZExternPlusButton) {
        self.plusButton = LZExternPlusButton;
        [self addSubview:(UIButton *)self.plusButton];
    }
    // KVO注册监听
    _tabBarItemWidth = LZTabBarItemWidth;
    [self addObserver:self forKeyPath:@"tabBarItemWidth" options:NSKeyValueObservingOptionNew context:LZTabBarContext];
    return self;
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != LZTabBarContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == LZTabBarContext) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LZTabBarItemWidthDidChangeNotification object:self];
    }
}

- (void)dealloc {
    // KVO移除监听
    [self removeObserver:self forKeyPath:@"tabBarItemWidth"];
}

- (void)setTabBarItemWidth:(CGFloat )tabBarItemWidth {
    if (_tabBarItemWidth != tabBarItemWidth) {
        [self willChangeValueForKey:@"tabBarItemWidth"];
        _tabBarItemWidth = tabBarItemWidth;
        [self didChangeValueForKey:@"tabBarItemWidth"];
    }
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat barWidth = self.bounds.size.width;
    CGFloat barHeight = self.bounds.size.height;
    LZTabBarItemWidth = (barWidth - LZPlusButtonWidth) / LZTabbarItemsCount;
    self.tabBarItemWidth = LZTabBarItemWidth;
    if (!LZExternPlusButton) {
        return;
    }
    
    CGFloat multiplerInCenterY;
    if ([[self.plusButton class] respondsToSelector:@selector(multiplerInCenterY)]) {
        multiplerInCenterY = [[self.plusButton class] multiplerInCenterY];
    } else {
        CGSize sizeOfPlusButton = self.plusButton.frame.size;
        CGFloat heightDifference = sizeOfPlusButton.height - self.bounds.size.height;
        if (heightDifference < 0) {
            multiplerInCenterY = 0.5;
        } else {
            CGPoint center = CGPointMake(self.bounds.size.height / 2.0f, self.bounds.size.height / 2.0f);
            center.y = center.y - heightDifference / 2.0f;
            multiplerInCenterY = center.y / self.bounds.size.height;
        }
    }
    
    self.plusButton.center = CGPointMake(barWidth * 0.5, barHeight * multiplerInCenterY);
    NSUInteger plusButtonIndex;
    if ([[self.plusButton class] respondsToSelector:@selector(indexOfPlusButtonInTabBar)]) {
        if (LZTabbarItemsCount % 2 == 0 && !LZPlusChildViewController) {
            [NSException raise:@"LZTabBarController" format:@"If the count of LZTabbarControllers is not odd, there's no need to realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果LZTabbarControllers的个数不是奇数，会自动居中，你无需在你自定义的plusButton中实现`+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
        }
        plusButtonIndex = [[self.plusButton class] indexOfPlusButtonInTabBar];
        //仅修改self.plusButton的x,ywh值不变
        self.plusButton.frame = CGRectMake(plusButtonIndex * LZTabBarItemWidth,
                                           CGRectGetMinY(self.plusButton.frame),
                                           CGRectGetWidth(self.plusButton.frame),
                                           CGRectGetHeight(self.plusButton.frame)
                                           );
    } else {
        if (LZTabbarItemsCount % 2 != 0) {
            [NSException raise:@"LZTabBarController" format:@"If the count of LZTabbarControllers is odd,you must realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果LZTabbarControllers的个数是奇数，你必须在你自定义的plusButton中实现`+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
        }
        plusButtonIndex = LZTabbarItemsCount / 2.0;
    }
    LZPlusButtonIndex = plusButtonIndex;
    /* NOTE: If the `self.title of ViewController` and `the correct title of tabBarItemsAttributes` are different, Apple will delete the correct tabBarItem from subViews, and then trigger `-layoutSubviews`, therefore subViews will be in disorder. So we need to rearrange them.*/
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * view1, UIView * view2) {
        CGFloat view1_x = view1.frame.origin.x;
        CGFloat view2_x = view2.frame.origin.x;
        if (view1_x > view2_x) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    NSArray *tabBarButtonArray = [NSArray array];
    NSMutableArray *tabBarButtonMutableArray = [NSMutableArray arrayWithCapacity:sortedSubviews.count - 1];
    [sortedSubviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarButtonMutableArray addObject:obj];
        }
    }];
    if (LZPlusChildViewController) {
        [tabBarButtonMutableArray removeObjectAtIndex:LZPlusButtonIndex];
    }
    tabBarButtonArray = [tabBarButtonMutableArray copy];
    
    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
        //调整UITabBarItem的位置
        CGFloat childViewX;
        if (buttonIndex >= plusButtonIndex) {
            childViewX = buttonIndex * LZTabBarItemWidth + LZPlusButtonWidth;
        } else {
            childViewX = buttonIndex * LZTabBarItemWidth;
        }
        //仅修改childView的x和宽度,yh值不变
        childView.frame = CGRectMake(childViewX,
                                     CGRectGetMinY(childView.frame),
                                     LZTabBarItemWidth,
                                     CGRectGetHeight(childView.frame)
                                     );
    }];
    //bring the plus button to top
    [self bringSubviewToFront:self.plusButton];
}

/**
 *  Capturing touches on a subview outside the frame of its superview
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        UIView *result = [super hitTest:point withEvent:event];
        if (result) {
            return result;
        } else {
            for (UIView *subview in self.subviews.reverseObjectEnumerator) {
                CGPoint subPoint = [subview convertPoint:point fromView:self];
                result = [subview hitTest:subPoint withEvent:event];
                if (result) {
                    return result;
                }
            }
        }
    }
    return nil;
}

@end
