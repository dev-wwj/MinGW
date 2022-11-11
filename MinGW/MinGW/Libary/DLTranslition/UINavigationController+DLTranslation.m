//
//  UINavigationController+DLTranslation.m
//  TranslationDemo
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 songheng. All rights reserved.
//

#import "UINavigationController+DLTranslation.h"
#import <objc/runtime.h>

static void *kDismissByCommonGestureKey = &kDismissByCommonGestureKey;

@implementation UINavigationController (DLTranslation)

- (UINavigationControllerOperation)dl_TransitionOperation {

    return [objc_getAssociatedObject(self, @selector(dl_TransitionOperation)) integerValue];
}
- (void)setDl_TransitionOperation:(UINavigationControllerOperation)dl_TransitionOperation {
    objc_setAssociatedObject(self, @selector(dl_TransitionOperation), @(dl_TransitionOperation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (DLPercentDrivenInteractiveTransition *)dl_InteractiveTransition {
    return objc_getAssociatedObject(self, @selector(dl_InteractiveTransition));
}

- (void)setDl_InteractiveTransition:(DLPercentDrivenInteractiveTransition *)dl_InteractiveTransition {
    objc_setAssociatedObject(self, @selector(dl_InteractiveTransition), dl_InteractiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UIViewController (DLTranslation)

- (BOOL)dl_unAblePopTransitonInteractive {
    return [objc_getAssociatedObject(self, @selector(dl_unAblePopTransitonInteractive)) boolValue];
}

- (void)setDl_unAblePopTransitonInteractive:(BOOL)dl_unAblePopTransitonInteractive {
    objc_setAssociatedObject(self, @selector(dl_unAblePopTransitonInteractive), @(dl_unAblePopTransitonInteractive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)dl_fakeTransitionGesDirection {
    return [objc_getAssociatedObject(self, @selector(dl_fakeTransitionGesDirection)) unsignedIntegerValue];
}
- (void)setDl_fakeTransitionGesDirection:(NSUInteger)dl_fakeTransitionGesDirection {
    objc_setAssociatedObject(self, @selector(dl_fakeTransitionGesDirection), @(dl_fakeTransitionGesDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)dl_realTransitionGesDirection {
    return [objc_getAssociatedObject(self, @selector(dl_realTransitionGesDirection)) unsignedIntegerValue];
}
- (void)setDl_realTransitionGesDirection:(NSUInteger)dl_realTransitionGesDirection {
    objc_setAssociatedObject(self, @selector(dl_realTransitionGesDirection), @(dl_realTransitionGesDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIView *)dl_tabBarSnapshotView {
    return objc_getAssociatedObject(self, @selector(dl_tabBarSnapshotView));
}
- (void)setDl_tabBarSnapshotView:(UIView *)dl_tabBarSnapshotView {
    objc_setAssociatedObject(self, @selector(dl_tabBarSnapshotView), dl_tabBarSnapshotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setStt_presentController:(UIViewController *)stt_presentController {
   objc_setAssociatedObject(self, @selector(stt_presentController), stt_presentController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIViewController*)stt_presentController {
   return objc_getAssociatedObject(self, @selector(stt_presentController));
}

- (void)setDismissByCommonGesture:(void (^)(void))dismissByCommonGesture {
    objc_setAssociatedObject(self, kDismissByCommonGestureKey, dismissByCommonGesture, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))dismissByCommonGesture {
    return objc_getAssociatedObject(self, kDismissByCommonGestureKey);
}

@end
