//
//  DLTranslationEntity.m
//  TranslationDemo
//
//  Created by admin on 16/3/11.
//  Copyright © 2016年 songheng. All rights reserved.
//

#import "DLTranslationEntity.h"
#import "UINavigationController+DLTranslation.h"

@interface DLTranslationEntity ()
/**
 *  转场类型
 */
@property (nonatomic, assign) DLTranslationType translationType;

@end

@implementation DLTranslationEntity


- (instancetype)init
{
    self = [super init];
    if (self) {
        //默认 动画时间 0.5s
        _transitionDuration = 0.35;
    }
    return self;
}
- (instancetype)initWithTranslationType:(DLTranslationType)type
                               duration:(NSTimeInterval)duration {
    
    if (self = [super init]) {
        _transitionDuration = duration > 0 ? duration : _transitionDuration;
        _translationType =  type;
    }
    return self;
}


#pragma mark - 转场动画代理
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return _transitionDuration ;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *fromView = nil;
    UIView *toView = nil;
    UIView *contentView = transitionContext.containerView;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    if (!fromView || !toView) {
        // model转场必然 走到 这里，因为上面的方法必然拿到nil
        fromView = fromVC.view;
        toView = toVC.view;
    }
    
    
    switch (_translationType) {
        case DLTranslationTypeWithNavgationPush:
        {
            [self push_AnimationWithTransitionContext:transitionContext
                                          contenView:contentView
                                            fromView:fromView
                                              toView:toView
                                               fromVC:fromVC
                                                 toVC:toVC];
        }
            break;
        case DLTranslationTypeWithNavgationPop:
        {
            [self pop_AnimationWithTransitionContext:transitionContext
                                         contenView:contentView
                                           fromView:fromView
                                             toView:toView
                                              fromVC:fromVC
                                                toVC:toVC];
            
        }
            break;
        case DLTranslationTypeWithPresent:
        {
            [self show_AnimationWithTransitionContext:transitionContext
                                           contenView:contentView
                                             fromView:fromView
                                               toView:toView
                                               fromVC:fromVC
                                                 toVC:toVC];
        }
            break;
        case DLTranslationTypeWithDismiss:
        {
            [self dismiss_AnimationWithTransitionContext:transitionContext
                                              contenView:contentView
                                                fromView:fromView
                                                  toView:toView
                                                  fromVC:fromVC
                                                    toVC:toVC];
        }
            break;
        default:
            break;
    }
}



#pragma mark - push / pop Animation
- (void)push_AnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                                contenView:(UIView *)contenView
                                  fromView:(UIView *)fromView
                                    toView:(UIView *)toView
                                     fromVC:(UIViewController *)fromVC
                                       toVC:(UIViewController *)toVC {
    
    // MARK: 留存快照,从rootVC -> push时
    // fromVC.navigationController.viewControllers.count == 2 -> 这个判断有问题
    UIView *snapView = nil;
    UITabBar *tabBar = fromVC.navigationController.tabBarController.tabBar;
    if (tabBar.isHidden == NO && toVC.hidesBottomBarWhenPushed == YES) {
        snapView = fromVC.dl_tabBarSnapshotView = [tabBar snapshotViewAfterScreenUpdates:NO];
    }
    
    // MARK: 注意点1 -> 一定要把目的视图（toView） 添加到容器（containerView）上.
    [contenView addSubview:toView];
    // 横向偏移
    toView.transform = CGAffineTransformMakeTranslation(contenView.bounds.size.width, 0);
    // 添加一个shadow
    toView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    toView.layer.shadowOpacity = 1.0;//阴影透明度，默认0
    
    if (snapView) {
        // 添加个假的
        CGRect snapViewFrame = tabBar.bounds;
        snapViewFrame.origin.x = 0;
        // 这也比较坑 tableviewController == fromVC --> fromView == tableView
        // 有tabBar时，造成了 fromView 的高不等于屏幕高
        if ([fromView isKindOfClass:[UITableView class]]) {
            fromView.clipsToBounds = NO;
            // 坑：要加上偏移量。。。
            snapViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - snapViewFrame.size.height + [(UITableView *)fromView contentOffset].y;
        }else {
            snapViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - snapViewFrame.size.height;
        }
        snapView.frame = snapViewFrame;
        [fromView addSubview:snapView];
        
        tabBar.hidden = YES;
    }
    
    [UIView animateWithDuration:self.transitionDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                            
                         toView.transform = CGAffineTransformIdentity;
                         fromView.transform = CGAffineTransformMakeTranslation(-fromView.bounds.size.width/3, 0);
                        } completion:^(BOOL finished) {
                            // MARK: 注意点2 -> 转场的结果有两种：完成或取消。
                            // 非交互转场 -> finish，交互式转场 -> finish / Cancel。
                            // 通过transitionWasCancelled()方法来获取转场的结果，然后使用completeTransition:来通知系统转场结束，这个方法会检查动画控制器是否实现了animationEnded:方法，如果有，则调用该方法。
                            
                            BOOL isCancel = [transitionContext transitionWasCancelled];
                            // 复位fromView
                            fromView.transform = CGAffineTransformIdentity;
                            if (snapView) {
                                // 显示
                                tabBar.hidden = NO;
                                // 移除
                                [snapView removeFromSuperview];
                            }
                            [transitionContext completeTransition:!isCancel];
                        }];
}
- (void)pop_AnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                               contenView:(UIView *)contenView
                                 fromView:(UIView *)fromView
                                    toView:(UIView *)toView
                                    fromVC:(UIViewController *)fromVC
                                      toVC:(UIViewController *)toVC{
    
    // MARK: 注意点3 -> 这里添加 toview 要在fromview下面， 动画移走的是fromView
    [contenView insertSubview:toView belowSubview:fromView];
    toView.transform = CGAffineTransformMakeTranslation(-fromView.bounds.size.width/3, 0);

//     添加一个shadow
//    fromView.layer.shadowColor = [UIColor blackColor].CGColor;
//    fromView.layer.shadowRadius = 3;
//    fromView.layer.shadowOpacity = 0.9;//阴影透明度，默认0

    UITabBar *tabBar = toVC.navigationController.tabBarController.tabBar;
    UIView *snapView = toVC.dl_tabBarSnapshotView;
    if (!tabBar.hidden && snapView) {
        tabBar.hidden = YES;
        // 添加个假的
        CGRect snapViewFrame = tabBar.bounds;
        snapViewFrame.origin.x = 0;
        // 这也比较坑 tableviewController == fromVC --> fromView == tableView
        // 有tabBar时，造成了 fromView 的高不等于屏幕高
        if ([toView isKindOfClass:[UITableView class]]) {
            toView.clipsToBounds = NO;
            // 坑：要加上偏移量。。。
            snapViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - snapViewFrame.size.height + [(UITableView *)toView contentOffset].y;
        }else {
            snapViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - snapViewFrame.size.height;
        }
        snapView.frame = snapViewFrame;
        [toView addSubview:snapView];
    }
// MARK: 这是个巨坑，UIViewAnimationOptions 如果选为 EaseOut/EaseIn 等非对称选项，会造成 Pop交互驱动百分比和动画的百分比不对应的问题， 可使用 line/EaseInOut
    [UIView animateWithDuration:self.transitionDuration
                     animations:^{
                            
                         fromView.transform = CGAffineTransformMakeTranslation(contenView.bounds.size.width, 0);
                         toView.transform = CGAffineTransformIdentity;
                         
                        } completion:^(BOOL finished) {
                            
                            BOOL isCancel = [transitionContext transitionWasCancelled];
                            // 复位fromView
                            toView.transform = CGAffineTransformIdentity;
                            if (snapView) {
                                // 显示
                                tabBar.hidden = NO;
                                // 移除
                                [snapView removeFromSuperview];
                            }
                            
                            [transitionContext completeTransition:!isCancel];
                        }];
}





#pragma mark - present / disMiss +++++ 下面瞎写的 +++++
- (void)show_AnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                                 contenView:(UIView *)contenView
                                   fromView:(UIView *)fromView
                                     toView:(UIView *)toView
                                     fromVC:(UIViewController *)fromVC
                                       toVC:(UIViewController *)toVC {
    
    
    [contenView addSubview:toView];
    CGRect rect = [UIScreen mainScreen].bounds;
    toView.frame = CGRectMake(0, 0, rect.size.width/2, rect.size.height/2);
    toView.center = contenView.center;
    
    UIView *tempView = [[UIView alloc] initWithFrame:rect];
    tempView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    tempView.tag = 4434;
    [contenView insertSubview:tempView belowSubview:toView];
    
    toView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:self.transitionDuration
                     animations:^{
                            
                            toView.transform = CGAffineTransformIdentity;
                            
                        } completion:^(BOOL finished) {
                            BOOL iscalcel = [transitionContext transitionWasCancelled];
                            [transitionContext completeTransition:!iscalcel];
                        }];
}
- (void)dismiss_AnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
                                    contenView:(UIView *)contenView
                                      fromView:(UIView *)fromView
                                        toView:(UIView *)toView
                                        fromVC:(UIViewController *)fromVC
                                          toVC:(UIViewController *)toVC {
    // MARK: 注意点4 : 在 Custom 模式下的 dismissal 转场中不要像其他的转场那样将 toView(presentingView) 加入 containerView，否则 presentingView 将消失不见，而应用则也很可能假死。而 FullScreen 模式下可以使用与前面的容器类 VC 转场同样的代码。
    if (!([transitionContext presentationStyle] == UIModalPresentationCustom)) {
        [contenView addSubview:toView];
    }
    
    UIView *tempView = [contenView viewWithTag:4434];
    
    [UIView animateWithDuration:self.transitionDuration
                     animations:^{
                            
                            fromView.transform = CGAffineTransformMakeTranslation(0, -800);
                            tempView.alpha = 0;
                            
                        } completion:^(BOOL finished) {
                            [tempView removeFromSuperview];

                            BOOL iscalcel = [transitionContext transitionWasCancelled];
                            [transitionContext completeTransition:!iscalcel];
                        }];
}



@end

