//
//  CurveLineView.m
//  MinGW
//
//  Created by wangwenjian on 2022/11/11.
//

#import "CurveLineView.h"

@interface CurveLineView()

@property (strong, nonatomic) UIBezierPath * bezierPath;
@end

@implementation CurveLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
//    [UIColor.redColor set];
//    [_bezierPath stroke];
}

- (void)setupUI {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:CGPointMake(20, 60)];
    CGFloat x = 20;
    CGFloat y = 50;
    while (x < 250) {
        CGFloat temp = y;
        x += 40;
        CGFloat random = 20 + arc4random() % 10;
        if (y < 50) {
            y += random;
        } else {
            y -= random;
        }
        [path addCurveToPoint:CGPointMake(x, y) controlPoint1:CGPointMake(x - 25, temp) controlPoint2:CGPointMake(x - 25, y)];
    }
    
    CAShapeLayer * shapeLayer =  [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.lineWidth = 5;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = UIColor.redColor.CGColor;
    [self.layer addSublayer:shapeLayer];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:60/255.0 green:229/255.0 blue:253/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:48/255.0 green:49/255.0 blue:57/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    gl.mask = shapeLayer;
    [self.layer addSublayer:gl];
  
}


@end
