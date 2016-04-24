//
//  UIScrollView+XBRefreshExtension.h
//  XBRefreshExtension
//
//  Created by XIAOBAI on 15/4/20.
//  Copyright (c) 2015年 XBRefreshExtension. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 刷新类型
 */
typedef NS_ENUM(NSUInteger, XBRefreshType){
    /**
     *  刷新
     */
    XBRefreshTypeRefresh  = 1,
    /**
     *  加载更多
     */
    XBRefreshTypeLoadMore = 2,
};

/**
 *  @brief 刷新，加载更多的代理
 */
@protocol XBTableViewRefreshDelegate <NSObject>

@optional
- (void)req:(XBRefreshType)refreshType page:(NSUInteger)page tableView:(UIScrollView *)tableView;

@end

@interface UIScrollView (XBRefreshExtend)

/**
 *  @brief 当没有数据时隐藏加载更多控件,默认为YES（根据DataSources判断）
 */
@property (nonatomic, assign) BOOL whenNoDataHideLoadMoreControl;

/// 设置该属性，获取刷新事件
@property (nonatomic, weak) id<XBTableViewRefreshDelegate> refreshDelegate;

/// totalPage
@property (nonatomic, assign) NSUInteger totalPage;

/// page
@property (nonatomic, assign) NSUInteger page;

/// 是否是静默加载，通常用于第一次加载
@property (nonatomic, assign) BOOL isSilentLoad;

/**
 *  @brief 添加刷新和加载更多控件
 */
- (void)addRefreshAndLoadMore;

/**
 *  @brief 添加顶部刷新控件
 */
- (void)addRefreshControl;

/**
 *  @brief 添加底部加载更多控件
 */
- (void)addLoadMoreControl;

/**
 *  @brief 立即刷新
 */
- (void)refresh;

/**
 *  @brief 静默加载,全局菊花，加载完成后需隐藏
 */
- (void)silentLoad;

/**
 *  @brief 结束静默加载
 */
- (void)endSilentLoad;

/**
 *  @brief 设置是否还有更多数据，为NO时底部将显示没有更多，不显示加载更多视图
 *
 *  @param hasMore 是否还有更多
 */
- (void)setHasMore:(BOOL)hasMore;

/**
 *  @brief 刷新完成后调用，关闭刷新视图
 */
- (void)didRefreshFinished;

/**
 *  @brief 加载更多完成后调用，关闭加载更多视图
 */
- (void)didLoadMoreFinished;

/**
 *  @brief 结束所有刷新事件
 */
- (void)endAllRefresh;

@end
