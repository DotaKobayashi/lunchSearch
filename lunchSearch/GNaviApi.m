//
//  GNaviApi.m
//  lunchSearch
//
//  Created by 小林堂太 on 2014/08/17.
//  Copyright (c) 2014年 dota.kobayashi. All rights reserved.
//

#import "GNaviApi.h"


@implementation GNaviApi

/**
 * 初期化
 */
- (id)init {
    self=[super init];
    if (self) {
        // 検索範囲のデフォルト TODO:設定画面の検索範囲にする
        self.range = 2;
        self.latitude = 0;
        self.longitude = 0;
    }
    return self;
}

@end
