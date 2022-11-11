//
//  DLTranslationEntity.h
//  TranslationDemo
//
//  Created by admin on 16/3/11.
//  Copyright © 2016年 songheng. All rights reserved.
//


/**
 *  .动画控制器(Animation Controller)：
 */
#import <UIKit/UIKit.h>


// 转场类型
typedef NS_ENUM(NSUInteger ,DLTranslationType) {
    
    DLTranslationTypeWithNavgationPush = 1,
    DLTranslationTypeWithNavgationPop,
    DLTranslationTypeWithPresent,
    DLTranslationTypeWithDismiss
};

/**
 如果需要自定义转场动画，请subClass此类
 */
@interface DLTranslationEntity : NSObject<UIViewControllerAnimatedTransitioning>
/**
 *  动画执行时间， 默认0.35s
 */
@property (nonatomic, assign) NSTimeInterval  transitionDuration;

/**  这里记录 相对应的手势驱动对象 */
@property (nonatomic) UIPercentDrivenInteractiveTransition *dl_InteractiveTransition;


/**  初始化 */
- (instancetype)initWithTranslationType:(DLTranslationType)type
                               duration:(NSTimeInterval)duration;


/**  选择性的重写下列方法 - 实现动画效果 */
- (void)push_AnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                                 contenView:(UIView *)contenView
                                   fromView:(UIView *)fromView
                                     toView:(UIView *)toView
                                     fromVC:(UIViewController *)fromVC
                                       toVC:(UIViewController *)toVC;
- (void)pop_AnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                                 contenView:(UIView *)contenView
                                   fromView:(UIView *)fromView
                                    toView:(UIView *)toView
                                    fromVC:(UIViewController *)fromVC
                                      toVC:(UIViewController *)toVC;
- (void)show_AnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                                 contenView:(UIView *)contenView
                                   fromView:(UIView *)fromView
                                     toView:(UIView *)toView
                                     fromVC:(UIViewController *)fromVC
                                       toVC:(UIViewController *)toVC;
- (void)dismiss_AnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                                 contenView:(UIView *)contenView
                                   fromView:(UIView *)fromView
                                     toView:(UIView *)toView
                                        fromVC:(UIViewController *)fromVC
                                          toVC:(UIViewController *)toVC;
@end
