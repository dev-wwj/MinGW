//
//  ZFTabBarViewController.h
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTabBar.h"

typedef NS_ENUM(NSInteger,BDDTabBarIndex) {
    BDDTabBarIndexWalk,
    BDDTabBarIndexTK,
    BDDTabBarIndexMine,
    BDDTabBarIndexSpecial,
    BDDTabBarIndexCommunity,
    BDDTabBarIndexTabBarDance,
    BDDTabBarIndexMessage,
    BDDTabBarIndexActivity ///中间活动为按钮 1: 活动 2: 小剧场
};

typedef NS_ENUM(NSInteger,BDDWalkTabBar) {
    BDDWalkTabBarActivity = 1,
    // 1=活动 2=健走 3=健身 4=跑步
    BDDWalkTabBarWalk = 2,
    BDDWalkTabBarFitness = 3,
    BDDWalkTabBarRun = 4,
    BDDWalkTabBarDance,
    BDDWalkTabBarClasses = 6, //课堂
    BDDWalkTabBarMsg= 7 //聊聊
};

@interface ZFTabBarViewController : UITabBarController

@property (nonatomic, strong, readonly) ZFTabBar *customtabBar;
@property (nonatomic, strong, readonly) UIView *tabBarSnapShot;
@property (nonatomic, strong) NSMutableArray *tabbarIndexArr;  //存放当前的TabbarIndex

- (void)takeTabBarSnapshot;

@property (nonatomic, weak  , readonly) ZFTabBarButton *walkTabButton;
@property (nonatomic, weak  , readonly) ZFTabBarButton *specialTabButton;
@property (nonatomic, weak  , readonly) ZFTabBarButton *taskTabButton;
@property (nonatomic, weak  , readonly) ZFTabBarButton *mineTabButton;
@property (nonatomic, weak  , readonly) ZFTabBarButton *communityTabButton;
@property (nonatomic, weak  , readonly) ZFTabBarButton *messageTabButton;
@end


#pragma mark - UIViewController 自定义TabBar分类
@interface UIViewController (UIViewControllerCustomTabBarItem)

// 对应的tabBarButton
@property(nonatomic, strong, readonly) ZFTabBarButton * _Nullable customTabBarItem;
- (void)resetCustomTabBarItem:(ZFTabBarButton *_Nullable)customTabBarItem;

// 对应的title
@property (nonatomic, copy) NSString * _Nullable custom_tabBarItemTitle;


@end
