//
//  DLPercentDrivenInteractiveTransition.m
//  TranslationDemo
//
//  Created by admin on 2017/1/23.
//  Copyright © 2017年 songheng. All rights reserved.
//

#import "DLPercentDrivenInteractiveTransition.h"

#import "UINavigationController+DLTranslation.h"
#import "CustomNaviViewController.h"
@interface DLPercentDrivenInteractiveTransition () <UIGestureRecognizerDelegate>

/**  添加了手势的ctl */
@property (nonatomic, weak) UIViewController *panGestureViewController;
/**  允许的手势方向 */
@property (nonatomic, assign) DLPopGestureDirectionType allDirection;


/**  当前的手势方向 */
@property (nonatomic, assign) DLPopGestureDirectionType direction;
/**  记录是否开始手势，判断pop操作是手势触发还是返回键触发 */
@property (nonatomic, assign) BOOL popGestureDidChange;

@property (nonatomic, assign) CGPoint beginPoint;

@property (nonatomic, assign) BOOL useCustomTransition;
@end
@implementation DLPercentDrivenInteractiveTransition
+ (instancetype)interactiveTransitionWithViewController:(UIViewController *)vc
                                       gestureDirection:(DLPopGestureDirectionType)direction {
    DLPercentDrivenInteractiveTransition *interective = [[DLPercentDrivenInteractiveTransition alloc] initWithGestureDirection:direction];
    [interective addGestureToViewController:vc];
    return interective;
}
- (instancetype)initWithGestureDirection:(DLPopGestureDirectionType)direction{
    self = [super init];
    if (self) {
        _allDirection = direction;
        _minProgress  = 0.3;
        self.completionCurve = UIViewAnimationCurveLinear;
        self.completionSpeed = 1;
    }
    return self;
}


// MARK:------------- 添加交互驱动 - 手势
- (void)addGestureToViewController:(UIViewController *)vc {
    
    if (!vc) {
        return;
    }
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    self.panGestureViewController = vc;
    pan.delegate                  = self;
    pan.maximumNumberOfTouches    = 1;      // 限制手指个数
    [vc.view addGestureRecognizer:pan];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if ([self isTransitioning] || [self interactiveUnEnable] || self.animationLock) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch locationInView:touch.view].x > 80) {
        return NO;
    }
    return  YES;
}

// MARK:------------- 手势过渡的过程
- (DLPopGestureDirectionType)nowGesDirection {
    return _direction ? : DLPopGestureDirectionWithNone;
}
- (CGFloat)persentWtihGesture:(UIPanGestureRecognizer *)panGesture {
    
    //手势百分比
    CGFloat persent = 0;
    // 因为panGesture.view 自身会随着手势移送，所以位置点相对于window取值
    CGPoint gesPossion = [panGesture translationInView:panGesture.view];
    switch (_direction) {
        case DLPopGestureDirectionWithLeft:{
            CGFloat transitionX = -gesPossion.x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case DLPopGestureDirectionWithRight:{
            CGFloat transitionX = gesPossion.x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case DLPopGestureDirectionWithUp:{
            CGFloat transitionY = -(gesPossion.y - self.beginPoint.y);
            //NSLog(@"persentWtihGesture:%f",gesPossion.y);
            persent = transitionY / panGesture.view.frame.size.height;
        }
            break;
        case DLPopGestureDirectionWithDown:{
            CGFloat transitionY = gesPossion.y - self.beginPoint.y;
            //if (transitionY == 0.0) {
                //NSLog(@"persentWtihGesture:%f",transitionY);
            //}
            persent = transitionY / panGesture.view.frame.size.height;
        }
            break;
        case DLPopGestureTouchUpInside:
        case DLPopGestureDirectionWithNone:{
            // 不响应 - 禁用手势
            return 0;
        }
            break;
    }
    return persent;
}
- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture
{
    if (self.useCustomTransition) {
        self.panActionBlk(panGesture, _direction);
        if (panGesture.state == UIGestureRecognizerStateCancelled ||
            panGesture.state == UIGestureRecognizerStateEnded) {
            self.useCustomTransition = NO;
        }
        return;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            // 判断手势方向
            CGPoint vel = [panGesture velocityInView:panGesture.view];
            CGFloat x   = fabs(vel.x);
            CGFloat y   = fabs(vel.y);
            if (x > y) {
                if (vel.x < 0) {
                    _direction = DLPopGestureDirectionWithLeft;
                }else if(vel.x > 0){
                    _direction = DLPopGestureDirectionWithRight;
                }
            }else if(x < y){
                if (vel.y < 0) {
                    _direction = DLPopGestureDirectionWithUp;
                }else if(vel.y > 0){
                    _direction = DLPopGestureDirectionWithDown;
                }
            }else{
                // 这种情况只有正好 对角线方向滑动  - 不处理
                _direction = DLPopGestureDirectionWithNone;
                return;
            }
            
            // 默认都支持右划返回 假转场（不支持都通过dl_unAblePopTransitonInteractive在手势代理中过滤掉了）
            if ([self.panGestureViewController isKindOfClass:[UINavigationController class]]) {
                
                if ((_direction & DLPopGestureDirectionWithRight) > 0) {
                    self.useCustomTransition = YES;
                    self.panActionBlk(panGesture, _direction);
                    return;
                }
                
                // 当前方向是否在支持的方向中（fake transition）
                UIViewController *ctl = [(UINavigationController *)self.panGestureViewController topViewController];
                if (ctl.dl_fakeTransitionGesDirection != DLPopGestureDirectionWithNone) {
                    if ((_direction & ctl.dl_fakeTransitionGesDirection) > 0) {
                        self.useCustomTransition = YES;
                        self.panActionBlk(panGesture, _direction);
                        return;
                    }
                }
                
                // real transition
                if (ctl.dl_realTransitionGesDirection != DLPopGestureDirectionWithNone) {
                    if ((_direction & ctl.dl_realTransitionGesDirection) <= 0) {
                        return;
                    }
                }else {
                    return;
                }
            }

            
            // 手势开始的时候标记手势状态
            self.popGestureDidChange = YES;
            self.beginPoint = [panGesture translationInView:panGesture.view];
            
            // 开始Pop转场, 一旦转场开始, VC 将脱离控制器栈，此后 self.navigationController 返回的是 nil。
            [self beginPopTranslation];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            if (self.popGestureDidChange == NO) {
                return;
            }

            CGFloat persent = [self persentWtihGesture:panGesture];
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            if (self.popGestureDidChange == NO) {
                return;
            }
            self.popGestureDidChange = NO;

            // self.completionSpeed; //后续动画的开始速率 = 该参数 * 原来的速率 - 如果 <1 会掉帧
            if (self.percentComplete > self.minProgress ) {
                [self finishInteractiveTransition];
            }else {
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}
// MARK:---------- 手势开始前的判断
- (BOOL)isTransitioning {
    UINavigationController *nav = self.panGestureViewController.navigationController;
    if ([self.panGestureViewController isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)self.panGestureViewController;
    }

    if ([[nav valueForKey:@"_isTransitioning"] boolValue]) {
        return YES;
    }

    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    if (nav.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return YES;
    }

    if ([[nav topViewController] presentedViewController]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)interactiveUnEnable {
    UIViewController *ctl = self.panGestureViewController;
    if ([self.panGestureViewController isKindOfClass:[UINavigationController class]]) {
        
        ctl = [(UINavigationController *)self.panGestureViewController topViewController];
    }
    return ctl.dl_unAblePopTransitonInteractive;
}

- (void)beginPopTranslation {

    if ([self.panGestureViewController isKindOfClass:[UINavigationController class]]) {
        //- 这里支持手势添加在NavigationController上
        [(UINavigationController *)self.panGestureViewController popViewControllerAnimated:YES];
        return;
    }
    self.panGestureViewController.navigationController ? [self.panGestureViewController.navigationController popViewControllerAnimated:YES] : nil;
}
@end
