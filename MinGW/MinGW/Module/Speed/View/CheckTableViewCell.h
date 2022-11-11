//
//  CheckTableViewCell.h
//  MinGW
//
//  Created by songxin on 2022/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckTableViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *subtitle;
@end

NS_ASSUME_NONNULL_END
