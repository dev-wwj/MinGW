//
//  CustomNaviViewController.m
//  NativeEastNews
//
//  Created by admin on 15/10/8.
//  Copyright © 2015年 Gaoxin. All rights reserved.
//

#import "CustomNaviViewController.h"
#import "DLPercentDrivenInteractiveTransition.h"
#import "BaseViewController.h"
#import "UINavigationController+DLTranslation.h"
#import "ZFTabBarViewController.h"
#import "DLTranslationEntity.h"

@interface CustomNaviViewController ()<UINavigationControllerDelegate>
{
    BOOL  _flag; // iOS 9以下 有个bug 在主线程阻塞的时候 ，执行多次push  back的时候会崩溃
    BOOL _isHaveAnimation;

    UIImageView *_shadowImage;
    
    __weak UIViewController *_weakToVCWithPop;
    __weak UIView *_insertView;
    __weak UIView *_innerTransitionView;
}
@end

@implementation CustomNaviViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (self.interfaceOrientationMask) {
        return self.interfaceOrientationMask;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.interfaceOrientation) {
        return self.interfaceOrientation;
    }
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (BOOL)shouldAutorotate{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 记录手势驱动对象
    self.dl_InteractiveTransition = [DLPercentDrivenInteractiveTransition interactiveTransitionWithViewController:self gestureDirection:DLPopGestureDirectionWithRight];
    WEAK_Self
    [self.dl_InteractiveTransition setPanActionBlk:^(UIPanGestureRecognizer *panGesture, DLPopGestureDirectionType direction) {
    
        [weakSelf pan:panGesture nowDirection:direction];
    }];

    
//    // 获取系统自带滑动手势的target对象
//    id target = self.interactivePopGestureRecognizer.delegate;
//    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    // 设置手势代理，拦截手势触发
//    pan.delegate = self;
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
    

    self.delegate              = self;
    self.transitioningDelegate = self;
    self.navigationBarHidden   = YES;

    _shadowImage       = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touying"]];
    _shadowImage.frame = CGRectMake(-9, 0, 9, SCREEN_SIZE_MAX);
    [self.view addSubview:_shadowImage];
}

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (self.viewControllers.count <= 1) {
//        return NO;
//    }
//
//    // 直播页面关闭滑动返回
//    if ([self.topViewController isKindOfClass:[watchViewController class]]) {
//        return NO;
//    }
//    if ([self.topViewController isKindOfClass:[GXBackPlayViewController class]]) {
//        return NO;
//    }
//    // Ignore pan gesture when the navigation controller is currently in transition.
//    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
//        return NO;
//    }
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
////******************  原文修改  ****************
//    //pan手势,没有方向,  此判断 避免 左滑的时候 触发此效果
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        UIPanGestureRecognizer *panges = (UIPanGestureRecognizer *)gestureRecognizer;
//        if ([panges translationInView:panges.view].x > 0) {
////            NSLog(@" > 0 ,是右滑");
//        }else{
////            NSLog(@" < 0 ,是左滑");
//            return NO;
//        }
//    }
//    return YES;
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 防止 vc为 nil
    if (_flag || !viewController) {
        return;
    }
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
        _flag = YES;
    }
    
    viewController.hidesBottomBarWhenPushed = self.childViewControllers.count;

    if (self.tabBarController.tabBar && !self.tabBarController.tabBar.isHidden && viewController.hidesBottomBarWhenPushed) {
        [(ZFTabBarViewController *)self.tabBarController takeTabBarSnapshot];
    }
    
    [super pushViewController:viewController animated:animated];
    
    if (TARGET_IPHONE_X) {
        self.tabBarController.tabBar.y = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *ctrl = [super popViewControllerAnimated:animated];
    if (!animated) {
        [self.tabBarController.view setNeedsLayout];
        [self.tabBarController.view layoutIfNeeded];
    }
    return ctrl;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (@available(iOS 14.0, *)) {
        if (self.viewControllers.count > 1) {
               self.topViewController.hidesBottomBarWhenPushed = NO;
           }
           NSArray<UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
           return viewControllers;
    }else{
        return [super popToRootViewControllerAnimated:animated];
    }
}

- (void)pan:(UIPanGestureRecognizer *)panGesture nowDirection:(DLPopGestureDirectionType)nowDirection {
  
    CGFloat transX = 0;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.dl_InteractiveTransition.panTransitionState = DLPopGestureTransitionStateBegin;
            [self startTransition];
            break;
        case UIGestureRecognizerStateChanged:
            self.dl_InteractiveTransition.panTransitionState = DLPopGestureTransitionStateTransition;
            transX = [panGesture translationInView:panGesture.view].x;
            [self updateTransition:transX];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.dl_InteractiveTransition.panTransitionState = DLPopGestureTransitionStateEnd;
            transX = [panGesture translationInView:panGesture.view].x;
            [self endTransition:transX];
            break;
        default:
            break;
    }
}


- (void)startTransition {
    self.topViewController.view.userInteractionEnabled = NO;
    _innerTransitionView   = [self innerTransitionView];
    UIViewController *toVc = self.viewControllers[self.viewControllers.count - 2];

    UIView *insertView = nil;
    if (!toVc.tabBarController.tabBarController.tabBar.isHidden && !toVc.hidesBottomBarWhenPushed) {
        insertView = [[UIView alloc] initWithFrame:CGRectMake(-(SCREEN_WIDTH / 3), 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [insertView addSubview:toVc.view];
        [insertView addSubview:[(ZFTabBarViewController *)self.tabBarController tabBarSnapShot]];
    } else {
        insertView = toVc.view;
        _weakToVCWithPop = toVc;
    }
    [self.view addSubview:insertView];
    [self.view sendSubviewToBack:insertView];
    _insertView = insertView;
}

- (void)updateTransition:(CGFloat)transX {
    transX          = MAX(MIN(transX, SCREEN_WIDTH), 0);
    CGFloat percent = transX / SCREEN_WIDTH;
    [_innerTransitionView setX:transX];
    [_shadowImage setX:(transX - 9)];
    [_insertView setX:-(SCREEN_WIDTH / 3) * (1 - percent)];
}

- (UIView *)innerTransitionView {
    for (UIView *transitionView in self.view.subviews) {
        if ([transitionView isMemberOfClass:NSClassFromString(@"UINavigationTransitionView")]) {
            return transitionView;
        }
    }
    return nil;
}

- (void)endTransition:(CGFloat)transX {
    self.dl_InteractiveTransition.animationLock = YES;
    if (transX > 100) {
        if ([self.topViewController respondsToSelector:@selector(dismissByCommonGesture)]) {
            BLOCK_EXEC(self.topViewController.dismissByCommonGesture);
        }
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self->_innerTransitionView setX:SCREEN_WIDTH];
            [self->_shadowImage setX:SCREEN_WIDTH];
            [self->_insertView setX:0];
        } completion:^(BOOL finished) {
            [self.topViewController.view setUserInteractionEnabled:YES];
            [self popViewControllerAnimated:NO];
            [self->_shadowImage setX:-9];
            [self->_innerTransitionView setX:0];
            if (self->_insertView != self->_weakToVCWithPop.view) {
                //  如果 == ， 会出现短暂白屏（特别是包换webView时）
                [self->_insertView removeFromSuperview];
            }
            self.dl_InteractiveTransition.animationLock = NO;
        }];
    } else {
        [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self->_innerTransitionView setX:0];
            [self->_shadowImage setX:-9];
            [self->_insertView setX:-(SCREEN_WIDTH / 3)];
        } completion:^(BOOL finished) {
            [self->_insertView setX:0];
            [self->_insertView removeFromSuperview];
            [self.topViewController.view setUserInteractionEnabled:YES];
            self.dl_InteractiveTransition.animationLock = NO;
        }];
    }
    self.dl_InteractiveTransition.panTransitionState = DLPopGestureTransitionStateNone;
}

#pragma mark - UINavigationControllerDelegate
// 暂定 关闭逻辑  rootVC - VC2 - VC3(关闭)
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (TARGET_IPHONE_X && (self.tabBarController.tabBar.height != TAB_BAR_HEIGHT)) {
        self.tabBarController.tabBar.height = TAB_BAR_HEIGHT;
    }
}
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
        _flag = NO;
    }
}



#pragma makr - ==============
#pragma mark - 自定义转场
#pragma makr - ==============
// : 提供动画控制器
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{

    // 记录类型，转场驱动 要用
    self.dl_TransitionOperation = operation;
    _isHaveAnimation = YES;
    DLPopGestureDirectionType type = DLPopGestureDirectionWithRight;
    
    if (operation == UINavigationControllerOperationPush) {
        // 保留截图 -pop时用
        UITabBar *tabBar = fromVC.navigationController.tabBarController.tabBar;
        if (tabBar.isHidden == NO && toVC.hidesBottomBarWhenPushed == YES)
        {
             fromVC.dl_tabBarSnapshotView = [tabBar snapshotViewAfterScreenUpdates:NO];
        }
    }else if (operation == UINavigationControllerOperationPop){
        //&& self.dl_InteractiveTransition.popGestureDidChange) {
        // 只替换交互驱动的 pop动画
        
        DLPopGestureDirectionType interactiveTransitionDirection = [self.dl_InteractiveTransition nowGesDirection];
        if((interactiveTransitionDirection & type) == DLPopGestureDirectionWithRight && self.dl_InteractiveTransition.popGestureDidChange){
            DLTranslationEntity *animationer = [[DLTranslationEntity alloc] initWithTranslationType:DLTranslationTypeWithNavgationPop duration:0.35];
            return animationer;
        }
    }
    _isHaveAnimation = NO;
    return nil;
}

// : 提供交互控制器
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if (!_isHaveAnimation) {
        return nil;
    }
    
    // 手势驱动
    BOOL enableInteractive = self.dl_TransitionOperation == UINavigationControllerOperationPop && self.dl_InteractiveTransition.popGestureDidChange;
    if (enableInteractive ) {
        return self.dl_InteractiveTransition;
    }
    return nil;
}

@end
