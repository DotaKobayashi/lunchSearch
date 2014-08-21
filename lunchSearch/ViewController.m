//
//  ViewController.m
//  lunchSearch
//
//  Created by 小林堂太 on 2014/08/16.
//  Copyright (c) 2014年 dota.kobayashi. All rights reserved.
//

#import "ViewController.h"
#import "ShopTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // ロケーションマネージャの初期化
    self.locationManager.delegate = nil;
    self.locationManager = nil;

    self.gNavi = [GNaviApi new];
    
    // ロケーションマネージャ作成
    self.locationManager = [[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled])
    {
        self.locationManager.delegate = self;
        // 位置情報取得開始
        [self.locationManager startUpdatingLocation];
    } else {
        // 位置情報サービスが使えない
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"位置情報サービスが使えません"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSearch:(id)sender
{
    // 店検索 → 一覧画面へ遷移
    [self getShopList:self.gNavi];
}


#pragma mark GuruNaviAPI
/**
 * 店のリストを取得する
 */
- (void)getShopList:(GNaviApi *)gNavi
{

    NSString *api = [NSString stringWithFormat:ApiURL, AccessKey, gNavi.latitude, gNavi.longitude, gNavi.range];
    NSLog(@"url:%@",api);
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // リクエストを送信する。非同期版
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSArray* shopList = [jsonDictionary objectForKey:@"rest"];
         if (shopList == nil)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"HITしたお店が0件です"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
             return;
         }
         ShopTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShopList"];
         vc.dataShopList = shopList;
         [self presentViewController:vc animated:YES completion:nil];
     }];
}

#pragma mark -
#pragma mark CLLocationDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // もっとも最近の位置情報を得る
    CLLocation *recentLocation = locations.lastObject;
    self.gNavi.latitude = recentLocation.coordinate.latitude;
    self.gNavi.longitude = recentLocation.coordinate.longitude;
    NSLog(@"latitude:%f, longtiude:%f",self.gNavi.latitude, self.gNavi.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager Error %@", error);
}


@end
