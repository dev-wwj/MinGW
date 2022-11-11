//
//  UIButton+extentedButton.h
//  BeautySite
//
//  Created by BeautySite on 30/3/16.
//  Copyright © 2016年 NingPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleTop, // image在上，label在下
    ButtonEdgeInsetsStyleLeft, // image在左，label在右
    ButtonEdgeInsetsStyleBottom, // image在下，label在上
    ButtonEdgeInsetsStyleRight // image在右，label在左
};
@interface UIButton (extentedButton)

/**
 *  button样式：左侧文字，右侧图片
 *
 *  @param title     button的title
 *  @param imageName button右侧的image
 */
-(void)setButtonTitle:(NSString *)title
   withRightImageName:(NSString *)imageName;

/**
 *  <#Description#>
 *
 *  @param style button样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;


/**
 * 调整button 图片和文字位置
 *
 *  @param style button样式
 *  @param space titleLabel和imageView的间距
 *  上面的方法 只是修改了图片和文字的相对位置，不会改变UIButton的内部大小
 */
- (void)resetButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                       imageTitleSpace:(CGFloat)space;


/**
 
 修改相应区域
 */
- (void)setEnlargeEdge:(CGFloat)size;

@end
