//
//  SetCell.m
//  MinGW
//
//  Created by wangwenjian on 2022/11/11.
//

#import "SetCell.h"

@implementation SetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *container = [[UIView alloc] init];
    [self.contentView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [container addSubview:label];
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(container);
    }];
    _label = label;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"双右_double-right"]];
    [container addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.equalTo(container);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
