//
//  CompassViewController.m
//  MinGW
//
//  Created by wangwenjian on 2022/11/11.
//

#import "CompassViewController.h"
#import "CompassView.h"

@interface CompassViewController ()

@end

@implementation CompassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CompassView *com = [CompassView new];
    com.backgroundColor = UIColorHex(0x414141);
    com.layer.cornerRadius = 16;
    com.layer.masksToBounds = YES;
    [self.view addSubview:com];
    [com mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(320, 330));
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
