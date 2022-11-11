//
//  UINavigationController+DLTranslation.h
//  TranslationDemo
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 songheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLPercentDrivenInteractiveTransition.h"

@interface UINavigationController (DLTranslation)

@property (nonatomic) UINavigationControllerOperation dl_TransitionOperation;

/**  交互驱动对象 */
@property (nonatomic) DLPercentDrivenInteractiveTransition *dl_InteractiveTransition;

@end


@interface UIViewController (DLTranslation)

/**  关闭 某个页面的滑动返回 */
@property (nonatomic, assign) BOOL dl_unAblePopTransitonInteractive;
// 对应DLPopGestureDirectionType,假转场用,比如某个页面需要支持其它方向滑动pop(默认只有右划返回 DLPopGestureDirectionWithRight)
@property (nonatomic, assign) NSUInteger dl_fakeTransitionGesDirection;
// 对应DLPopGestureDirectionType 真转场用
@property (nonatomic, assign) NSUInteger dl_realTransitionGesDirection;

/**  在push的时候 留存一个 tabbar的截图，pop时需要用 */
@property (nonatomic) UIView *dl_tabBarSnapshotView;
/** 导航控制器是被哪个控制器presente出来的 */
@property (nonatomic, strong) UIViewController *stt_presentController;

// 当前控制器即将被pop (手势返回)
@property (nonatomic, copy) void (^dismissByCommonGesture)(void);

@end
