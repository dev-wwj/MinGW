//
//  DetailViewController.m
//  MinGW
//
//  Created by wangwenjian on 2022/11/11.
//

#import "DetailViewController.h"
#import "CurveLineView.h"
#import "GetIPAddress.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *lineBox;
@property (weak, nonatomic) IBOutlet UILabel *delayLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view bringSubviewToFront:_container];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[_dic[@"time"] doubleValue]];
    _dateLabel.text = [date stringWithFormat:@"MM:ss"];
    _delayLabel.text =  [NSString stringWithFormat:@"%.03f",  [_dic[@"delay"] doubleValue]];
    _uploadLabel.text = [NSString stringWithFormat:@"%.03f",  [_dic[@"upload"] doubleValue]];
    _downloadLabel.text =  [NSString stringWithFormat:@"%.03f",  [_dic[@"download"] doubleValue]];
    
    _addressLabel.text = [GetIPAddress getIPAddress:YES];
    
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
