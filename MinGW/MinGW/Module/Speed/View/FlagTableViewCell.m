//
//  FlagTableViewCell.m
//  MinGW
//
//  Created by songxin on 2022/11/11.
//

#import "FlagTableViewCell.h"

@interface FlagTableViewCell(){
    UIImageView *_iamge;
    UIImageView *_arraw;
}

@end

@implementation FlagTableViewCell

- (void)setInfo:(NSString *)info {
    _iamge.image = [UIImage imageNamed:info];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {

    UIImageView *img = [[UIImageView alloc] init];
    img.hidden = YES;
    [self.contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.centerY.equalTo(self.contentView);
    }];
    _iamge = img;
    
    UIImageView *arraw = [[UIImageView alloc] init];
    [self.contentView addSubview:arraw];
    [arraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.centerY.equalTo(self.contentView);
    }];
    _arraw = arraw;
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColor.blackColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img);
        make.right.equalTo(arraw);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _arraw.image = [UIImage imageNamed:@"校验-小_check-small"];
    }else{
        _arraw.image = [UIImage imageNamed:@"切换_app-switch"];
    }
}
@end
