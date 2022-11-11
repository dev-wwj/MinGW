//
//  CompassView.m
//  Test
//
//  Created by songxin on 2022/11/11.
//

#import "CompassView.h"
#import "Masonry.h"
#import <CoreLocation/CoreLocation.h>

@interface CompassView()<CLLocationManagerDelegate> {
    UIImageView *_imageV;
    UILabel *_angleLa;
    UILabel *_locationLa;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation CompassView
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        // 每隔多少度更新一次
        _locationManager.headingFilter = 2;
        _locationManager.distanceFilter = 1;
    }
    return _locationManager;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        [self.locationManager startUpdatingHeading];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)setUI {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"组 20"]];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(30);
    }];
    _imageV = imageV;
    
    UILabel *angleLa = [UILabel new];
    angleLa.font = [UIFont systemFontOfSize:25];
    angleLa.textColor = [UIColor whiteColor];
    [self addSubview:angleLa];
    [angleLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(imageV.mas_bottom).offset(30);
    }];
    _angleLa = angleLa;
    
    UILabel *locationLa = [UILabel new];
    locationLa.font = [UIFont systemFontOfSize:18];
    locationLa.textColor = [UIColor whiteColor];
    [self addSubview:locationLa];
    [locationLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(angleLa.mas_bottom).offset(30);
    }];
    _locationLa = locationLa;
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    /**
    *  CLHeading
    *  magneticHeading : 磁北角度
    *  trueHeading : 真北角度
    */

    NSLog(@"%f", newHeading.magneticHeading);

    CGFloat angle = newHeading.magneticHeading;
    
    // 把角度转弧度
    CGFloat angleR = angle / 180.0 * M_PI;

    // 旋转图片
    [UIView animateWithDuration:0.25 animations:^{
        _imageV.transform = CGAffineTransformMakeRotation(-angleR);
    }];
    
    if (newHeading.magneticHeading > 80 && newHeading.magneticHeading < 100) {
        _angleLa.text = [NSString stringWithFormat:@"east %.0f°",newHeading.magneticHeading];
    }else if (newHeading.magneticHeading > 100 && newHeading.magneticHeading < 170) {
        _angleLa.text = [NSString stringWithFormat:@"southeast %.0f°",newHeading.magneticHeading];
    }else if (newHeading.magneticHeading > 170 && newHeading.magneticHeading < 190) {
        _angleLa.text = [NSString stringWithFormat:@"south %.0f°",newHeading.magneticHeading];
    }else if (newHeading.magneticHeading > 190 && newHeading.magneticHeading < 260) {
        _angleLa.text = [NSString stringWithFormat:@"southwest %.0f°",newHeading.magneticHeading];
    }else if (newHeading.magneticHeading > 260 && newHeading.magneticHeading < 280) {
        _angleLa.text = [NSString stringWithFormat:@"west %.0f°",newHeading.magneticHeading];
    }else if (newHeading.magneticHeading > 280 && newHeading.magneticHeading < 350) {
        _angleLa.text = [NSString stringWithFormat:@"northwest %.0f°",newHeading.magneticHeading];
    }else if (newHeading.magneticHeading > 250) {
        _angleLa.text = [NSString stringWithFormat:@"north %.0f°",newHeading.magneticHeading];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    CLGeocoder *gecoder = [CLGeocoder new];
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = placemarks.firstObject;
        _locationLa.text = [NSString stringWithFormat:@"%@,%@",place.subLocality,place.locality];
    }];
    [self.locationManager stopUpdatingLocation];
}
@end
