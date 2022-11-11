//
//  UIView+GradientColor.m
//  TinySweet
//
//  Created by zhazhenwang on 2020/8/28.
//  Copyright © 2020 xinmeng. All rights reserved.
//

#import "UIView+GradientColor.h"

@implementation UIView (GradientColor)

- (void)addVerticalGradientLayerByColors:(NSArray *)colors {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = colors;
    layer.startPoint = CGPointMake(0.5, 1);
    layer.endPoint = CGPointMake(0.5, 0);
    [self.layer addSublayer:layer];
}

- (void)addVerticalGradientLayerByColors:(NSArray *)colors frame:(CGRect)frame{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.colors = colors;
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 0.2);
    self.layer.mask = layer;
}

- (void)addHorizontalGradientLayerByColors:(NSArray *)colors frame:(CGRect)frame{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.colors = colors;
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1.0, 0.5);
    [self.layer insertSublayer:layer atIndex:0];
}
@end
