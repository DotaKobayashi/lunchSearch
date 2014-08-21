//
//  ViewController.h
//  lunchSearch
//
//  Created by 小林堂太 on 2014/08/16.
//  Copyright (c) 2014年 dota.kobayashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GNaviApi.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate,NSURLSessionDataDelegate>

// ロケーションマネージャ
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) GNaviApi *gNavi;


- (IBAction)btnSearch:(id)sender;
@end
