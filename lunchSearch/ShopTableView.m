//
//  ShopTableView.m
//  lunchSearch
//
//  Created by 小林堂太 on 2014/08/16.
//  Copyright (c) 2014年 dota.kobayashi. All rights reserved.
//

#import "ShopTableView.h"
#import "TableViewInterceptor.h"
#import "CustomTableViewCell.h"

#define MORPHED_INDEX_PATH( __INDEXPATH__ ) [self morphedIndexPathForIndexPath:__INDEXPATH__  totalRows:_totalRows]

@interface ShopTableView()
{
    int mTotalCellsVisible;
    TableViewInterceptor *_dataSourceInterceptor;
    NSInteger _totalRows;
}
- (void)resetContentOffsetIfNeeded;
@end

@implementation ShopTableView

#pragma mark Private methods

- (NSIndexPath*)morphedIndexPathForIndexPath:(NSIndexPath*)oldIndexPath totalRows:(NSInteger)totalRows
{
    return [NSIndexPath indexPathForRow:oldIndexPath.row % totalRows inSection:oldIndexPath.section];
}

/*
 無限ループ
 contentOffsetを操作して循環ループにする
 */
- (void)resetContentOffsetIfNeeded
{
    // Rowの数を取得する
    NSArray *indexpaths = [self indexPathsForVisibleRows];
    int totalVisibleCells =[indexpaths count];
    // 画面に表示できる行数と取得した行数を比較してスクロールが必要な行数の場合、以下の処理を行う
    if( mTotalCellsVisible > totalVisibleCells )
    {
        // スクロールが必要ない場合は処理を抜ける
        return;
    }
    // スクロール位置を取得
    CGPoint contentOffset  = self.contentOffset;
    // 上にスクロールして振り切った場合
    if( contentOffset.y <= 0.0)
    {
        // スクロール位置を修正 3で割っているのは Rowの数を3倍にしているから
        contentOffset.y = self.contentSize.height/3.0f;
    }
    // 下にスクロールして振り切った場合
    else if( contentOffset.y >= ( self.contentSize.height - self.bounds.size.height) )
    {
        // スクロール位置を修正 3で割っているのは Rowの数を3倍にしているから
        contentOffset.y = self.contentSize.height/3.0f- self.bounds.size.height;
    }
    [self setContentOffset: contentOffset];
}

#pragma mark Layout

- (void)layoutSubviews
{
    // 表示できる数を設定
    NSLog(@"height:%f, rowHeight:%f", self.frame.size.height, [CustomTableViewCell rowHeight]);
    mTotalCellsVisible = self.frame.size.height / [CustomTableViewCell rowHeight];
    // スクロール位置を修正
    [self resetContentOffsetIfNeeded];
    [super layoutSubviews];
}

#pragma mark Setter/Getter
- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    if( !_dataSourceInterceptor)
    {
        _dataSourceInterceptor = [[TableViewInterceptor alloc] init];
    }
    
    _dataSourceInterceptor.receiver = dataSource;
    _dataSourceInterceptor.middleMan = self;
    
    [super setDataSource:(id<UITableViewDataSource>)_dataSourceInterceptor];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    _totalRows = [_dataSourceInterceptor.receiver tableView:tableView numberOfRowsInSection:section  ];
    return _totalRows * 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSourceInterceptor.receiver tableView:tableView cellForRowAtIndexPath:MORPHED_INDEX_PATH(indexPath)];
}

@end

