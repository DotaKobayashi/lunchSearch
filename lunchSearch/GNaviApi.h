//
//  GNaviApi.h
//  lunchSearch
//
//  Created by 小林堂太 on 2014/08/17.
//  Copyright (c) 2014年 dota.kobayashi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNaviApi : NSObject

// apiパラメータ
@property double latitude;          // 緯度
@property double longitude;         // 経度
@property int range;                // 検索範囲 1:300m、2:500m、3:1000m、4:2000m、5:3000m

#define ApiURL @"http://api.gnavi.co.jp/ver1/RestSearchAPI/?keyid=%@&latitude=%f&longitude=%f&range=%d&format=json"
#define AccessKey @"YOUR ACCESS KEY"

@end
