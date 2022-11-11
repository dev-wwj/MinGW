//
//  DLPercentDrivenInteractiveTransition.h
//  TranslationDemo
//
//  Created by admin on 2017/1/23.
//  Copyright © 2017年 songheng. All rights reserved.
//

#import <UIKit/UIKit.h>

// 手势的方向
typedef NS_ENUM(NSUInteger, DLPopGestureDirectionType) {
    DLPopGestureDirectionWithNone    = 0, //禁用手势
    DLPopGestureDirectionWithLeft    = 1 << 0,
    DLPopGestureDirectionWithRight   = 1 << 1,
    DLPopGestureDirectionWithUp      = 1 << 2,
    DLPopGestureDirectionWithDown    = 1 << 3,
    DLPopGestureTouchUpInside        = 1 << 4
};

typedef NS_ENUM(NSUInteger, DLPopGestureTransitionState) {
    DLPopGestureTransitionStateNone           = 0, //还未进行侧滑手势
    DLPopGestureTransitionStateBegin          = 1, //开始进行侧滑手势
    DLPopGestureTransitionStateTransition     = 2, //侧滑手势进行中
    DLPopGestureTransitionStateEnd            = 3  //侧滑手势结束
};

@interface DLPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

/**  记录是否开始手势，判断pop操作是手势触发还是返回键触发 */
@property (nonatomic, readonly, assign) BOOL popGestureDidChange;

/**  0 - 1 的系数值，标识 转场的成功 的最小进度 default 0.35 */
@property (nonatomic, assign) CGFloat minProgress;

@property (nonatomic, assign) BOOL animationLock;

/**
 侧滑手势状态
 */
@property (nonatomic, assign) DLPopGestureTransitionState panTransitionState;

@property (nonatomic, copy  ) void (^panActionBlk)(UIPanGestureRecognizer *panGesture, DLPopGestureDirectionType direction);



/**
 *  初始化 类方法
 *
 *  @param type      转场类型
 *
 *  @return
 */
+ (instancetype)interactiveTransitionWithViewController:(UIViewController *)vc
                                       gestureDirection:(DLPopGestureDirectionType)direction;
-(void)addGestureToViewController:(UIViewController *)vc;
- (DLPopGestureDirectionType)nowGesDirection;
@end
