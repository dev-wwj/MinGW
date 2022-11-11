//
//  ZFTabBar.h
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import "ZFTabBarButton.h"

@class ZFTabBar;
@protocol ZFTabBarDelegate <NSObject>
@optional
- (void)tabBar:(ZFTabBar *)tabBar didClickBtnIndex:(NSInteger)newIdx oldIndex:(NSInteger)oldIdx;
- (void)tabBar:(ZFTabBar *)tabBar didDoubleClickBtnIndex:(NSInteger)newIdx oldIndex:(NSInteger)oldIdx;

@end

@interface ZFTabBar : UIView

// setup
@property (nonatomic, weak) id<ZFTabBarDelegate> delegate;
- (void)config_insertTabBarBtn:(ZFTabBarButton *)item toIndex:(NSInteger)index;
- (void)config_updateWithIndex:(NSInteger)index toTabBarBtn:(ZFTabBarButton *)item;
- (void)config_removeTabBarItemAtIndex:(NSInteger)idx;

// 更新选中tabBarBtn
- (void)updateTabButtonToSelectIdx:(NSInteger)selectIdx;

- (ZFTabBarButton *)tabItemAtIdx:(NSInteger)idx;

- (void)lineColor:(UIColor *)color;
@end
