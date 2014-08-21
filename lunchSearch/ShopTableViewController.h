//
//  ShopTableViewController.h
//  lunchSearch
//
//  Created by 小林堂太 on 2014/08/17.
//  Copyright (c) 2014年 dota.kobayashi. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "ShopTableView.h"
#import <UIKit/UIKit.h>

@interface ShopTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet ShopTableView *tableView;
@property (nonatomic, strong) NSArray *dataShopList;

@end
