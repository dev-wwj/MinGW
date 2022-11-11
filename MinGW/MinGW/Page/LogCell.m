//
//  LogCell.m
//  MinGW
//
//  Created by wangwenjian on 2022/11/11.
//

#import "LogCell.h"
#import "CurveLineView.h"

@implementation LogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CurveLineView *lineView = [[CurveLineView alloc]initWithFrame:CGRectMake(0, 60, 300, 100)];
    [_container addSubview:lineView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
