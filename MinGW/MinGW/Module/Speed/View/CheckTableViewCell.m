//
//  CheckTableViewCell.m
//  MinGW
//
//  Created by songxin on 2022/11/11.
//

#import "CheckTableViewCell.h"

@interface CheckTableViewCell()
{
    UILabel *_title;
}
@end

@implementation CheckTableViewCell

- (void)setInfo:(NSDictionary *)info {
    _title.text = info[@"title"];
    _subtitle.text = info[@"subtitle"];
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
    
    
    UILabel *title = [UILabel new];
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(20);
    }];
    _title = title;
    
    UILabel *subtitle = [UILabel new];
    subtitle.textColor = UIColor.whiteColor;
    subtitle.font = [UIFont systemFontOfSize:10];
    subtitle.hidden = YES;
    [self.contentView addSubview:subtitle];
    [subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(4);
        make.left.equalTo(title);
    }];
    _subtitle = subtitle;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_选中"]];
    img.hidden = YES;
    [self.contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.contentView);
    }];
    _image = img;
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColor.blackColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title);
        make.right.equalTo(img);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
