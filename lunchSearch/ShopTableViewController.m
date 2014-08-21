//
//  ShopTableViewController.m
//  lunchSearch
//
//  Created by 小林堂太 on 2014/08/17.
//  Copyright (c) 2014年 dota.kobayashi. All rights reserved.
//

#import "ShopTableViewController.h"

@implementation ShopTableViewController

//アラート画面のタグを宣言
static const NSInteger firstAlertTag = 1;
static const NSInteger secondAlertTag = 2;
NSTimer *myTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // デリゲートメソッドをこのクラスで実装する
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // カスタマイズしたセルをテーブルビューにセット
    UINib *nib = [UINib nibWithNibName:@"TableViewCustomCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

/*
    myTimer =
    [NSTimer scheduledTimerWithTimeInterval:0.1f //タイマーを発生させる間隔
                                     target:self //タイマー発生時に呼び出すメソッドがあるターゲット
                                   selector:@selector(timerCall:) //タイマー発生時に呼び出すメソッド
                                   userInfo:nil //selectorに渡す情報(NSDictionary)
                                    repeats:YES //リピート
     ];
    
    UIAlertView *firstAlert = [[UIAlertView alloc] initWithTitle:@"AlertView"
                                                         message:@"とめる"
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"stop", nil];
    firstAlert.tag = firstAlertTag;
    [firstAlert show];
*/
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == firstAlertTag)
    {
        [self otherButtonPushed];
    }
    else if (alertView.tag == secondAlertTag)
    {
        // 特になにもなし
    }
}

- (void)otherButtonPushed
{
    [myTimer invalidate];
    
    // 余韻を持たす
    CGPoint point = CGPointMake(0, self.tableView.contentOffset.y - 300);
    [self.tableView setContentOffset:point animated:YES];
    
    
    // 止まる位置の店を取得 現在のスクロール位置をセルの高さで割って対象のセルを取得する
    NSInteger idx = self.tableView.contentOffset.y / 80;
    NSString *name = self.dataShopList[idx];
    
    UIAlertView *secondAlert = [[UIAlertView alloc] initWithTitle:@"AlertView"
                                                          message:name
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil, nil];
    secondAlert.tag = secondAlertTag;
    [secondAlert show];
    
}

-(void)timerCall:(NSTimer*)timer
{
    CGPoint point = CGPointMake(0, self.tableView.contentOffset.y - 300);
    [self.tableView setContentOffset:point animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataShopList.count;
}

/**
 テーブルに表示するセクション（区切り）の件数を返します。（オプション）
 
 @return NSInteger : セクションの数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 *  テーブルに表示するセルを返します。
 *
 *  @param tableView テーブルビュー
 *  @param indexPath セクション番号・行番号の組み合わせ
 *
 *  @return セル
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary* shopItem = self.dataShopList[indexPath.row];
    NSLog(@"index:%d", indexPath.row);
    
    
//    cell.shopImage.image = [self getShopImg:shopItem];
    cell.shopName.text = [self getShopName:shopItem];
    cell.shopURL = [shopItem objectForKey:@"url"];
    
    return cell;
}

- (NSString *)getShopName:(NSDictionary*)shopItem
{
    NSString *shopName = [shopItem objectForKey:@"name"];
    NSArray *tmp = [shopName componentsSeparatedByString:@" "];
    shopName = @"";
    NSInteger loopCnt = 0;
    for (NSString *str in tmp)
    {
        shopName = [NSString stringWithFormat:@"%@ %@",shopName,str];
        loopCnt++;
        if (loopCnt > 1)
            break;
    }
    
    NSLog(@"%@", shopName);
    return shopName;
}

- (UIImage *)getShopImg:(NSDictionary*)shopItem
{
    // NSString型だと認識させる
    NSString *shopImgUrl = [NSString stringWithFormat:@"%@", [[shopItem objectForKey:@"image_url"] objectForKey:@"shop_image1"]];
    // shopImgUrlにhttpが含まれている場合、画像が存在する
    NSRange range = [shopImgUrl rangeOfString:@"http"];
    if (range.location == NSNotFound)
        // NoImage画像を表示する
        return [UIImage imageNamed:@"ios1-100x100"];
    else
    {
        NSLog(@"%@", [shopItem objectForKey:@"url"] );
        // URLから画像を表示する TODO:高速化
        NSData *dt = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://apicache.gnavi.co.jp//image//rest//index.php?img=g064207v.jpg&sid=g064207"]];
        return [[UIImage alloc] initWithData:dt];
    }
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CustomTableViewCell rowHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // totalRowで÷
    NSDictionary* shopItem = self.dataShopList[indexPath.row % 10];
    NSString *shopURL = [NSString stringWithFormat:@"%@", [shopItem objectForKey:@"url"]];
    NSRange range = [shopURL rangeOfString:@"http"];
    if (range.location == NSNotFound)
        return;
        
    // UIWebViewのインスタンス化
    CGRect rect = self.view.frame;
    UIWebView *webView = [[UIWebView alloc]initWithFrame:rect];
    
    // Webページの大きさを自動的に画面にフィットさせる
    webView.scalesPageToFit = YES;
    
    // デリゲートを指定
    webView.delegate = self;
    
    // URLを指定
    NSURL *url = [NSURL URLWithString:shopURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // リクエストを投げる
    [webView loadRequest:request];
    
    // UIWebViewのインスタンスをビューに追加
    [self.view addSubview:webView];
    
}

@end