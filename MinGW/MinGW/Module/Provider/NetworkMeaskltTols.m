//
//  NetworkMeaskltTols.m
//  AppDemo
//
//  Created by 丁冬冬 on 2022/11/9.
//

#import "NetworkMeaskltTols.h"

#define urlString_PWBXCK @"https://cnmobile.s3.cn-north-1.amazonaws.com.cn/mshop-android-pcgatewayqrcode550505-cn-23.apk?ref_=footer_app_android"

@interface NetworkMeaskltTols ()
{
    cg_PWBXCK   infoBlock_PWBXCK;
    ch_PWBXCK   fcg_PWBXCK;
    int                           _second_PWBXCK;
    NSMutableData*                _connectData_PWBXCK;
    NSMutableData*                cf_PWBXCK;
    NSURLConnection *             _connect_PWBXCK;
    NSTimer*                      _timer_PWBXCK;
}

@property (copy, nonatomic) void (^faildBlock_PWBXCK) (NSError *error_PWBXCK);

@end

@implementation NetworkMeaskltTols

/**
 *  初始化测速方法
 *
 *  @param cg_PWBXCK       实时返回测速信息
 *  @param ch_PWBXCK 最后完成时候返回平均测速信息
 *
 *  @return MeasurNetTools对象
 */
- (instancetype)initWithblock_PWBXCK:(cg_PWBXCK)cg_PWBXCK ch_PWBXCK:(ch_PWBXCK)ch_PWBXCK ci_PWBXCK:(void (^) (NSError *error_PWBXCK))ci_PWBXCK {
    self = [super init];
    if (self) {
        infoBlock_PWBXCK = cg_PWBXCK;
        fcg_PWBXCK = ch_PWBXCK;
        _faildBlock_PWBXCK = ci_PWBXCK;
        _connectData_PWBXCK = [[NSMutableData alloc] init];
        cf_PWBXCK = [[NSMutableData alloc] init];
    }
    return self;
}

/**
 *  开始测速
 */
-(void)startMeasur_PWBXCK
{
    [self meausurNet_PWBXCK];
}

/**
 *  停止测速，会通过block立即返回测试信息
 */
-(void)stopMeasur_PWBXCK
{
    [self finishMeasure_PWBXCK];
}

-(void)meausurNet_PWBXCK
{
    _timer_PWBXCK = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime_PWBXCK) userInfo:nil repeats:YES];
    NSURL    *url_PWBXCK = [NSURL URLWithString:urlString_PWBXCK];
    NSURLRequest *request_PWBXCK = [NSURLRequest requestWithURL:url_PWBXCK];
    
    _connect_PWBXCK = [[NSURLConnection alloc] initWithRequest:request_PWBXCK delegate:self startImmediately:YES];
    [_timer_PWBXCK fire];
    _second_PWBXCK = 0;

}

-(void)countTime_PWBXCK{
    ++_second_PWBXCK;
    if (_second_PWBXCK == 16) {
        [self finishMeasure_PWBXCK];
        return;
    }
    float bd_PWBXCK = cf_PWBXCK.length;
//    if(speed==0.0f){
//        NSLog(@"acde");
//    }
    infoBlock_PWBXCK(bd_PWBXCK);
    
    //清空数据
    [cf_PWBXCK resetBytesInRange:NSMakeRange(0, cf_PWBXCK.length)];
    [cf_PWBXCK setLength:0];
}

/**
 * 测速完成
 */
-(void)finishMeasure_PWBXCK{
    [_timer_PWBXCK invalidate];
    _timer_PWBXCK = nil;
    if(_second_PWBXCK!=0){
        float finishbd_PWBXCK = _connectData_PWBXCK.length / _second_PWBXCK;
        fcg_PWBXCK(finishbd_PWBXCK);
    }
    
    [_connect_PWBXCK cancel];
    _connectData_PWBXCK = nil;
    _connect_PWBXCK = nil;
}



#pragma mark - urlconnect delegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.faildBlock_PWBXCK) {
        self.faildBlock_PWBXCK(error);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_connectData_PWBXCK appendData:data];
    [cf_PWBXCK appendData:data];
//    NSLog(@"cf_PWBXCK:%lu  data:%lu",(unsigned long)cf_PWBXCK.length,(unsigned long)data.length);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading");
    [self finishMeasure_PWBXCK];
}


- (void)dealloc {
    NSLog(@"MeasurNetTools dealloc");
}

@end
