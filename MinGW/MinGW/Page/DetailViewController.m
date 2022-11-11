//
//  DetailViewController.m
//  MinGW
//
//  Created by wangwenjian on 2022/11/11.
//

#import "DetailViewController.h"
#import "CurveLineView.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *lineBox;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view bringSubviewToFront:_container];
    
    CurveLineView *lineView = [[CurveLineView alloc]initWithFrame:CGRectMake(0, 20, 300, 100)];
    [_lineBox addSubview:lineView];
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
