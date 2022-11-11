//
//  UIView+GradientColor.h
//  TinySweet
//
//  Created by zhazhenwang on 2020/8/28.
//  Copyright © 2020 xinmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GradientColor)

- (void)addVerticalGradientLayerByColors:(NSArray *)colors;

- (void)addVerticalGradientLayerByColors:(NSArray *)colors frame:(CGRect)frame;

- (void)addHorizontalGradientLayerByColors:(NSArray *)colors frame:(CGRect)frame;
@end
