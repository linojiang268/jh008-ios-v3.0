//
//  UIScrollView+XBRefreshExtension.m
//  XBRefreshExtension
//
//  Created by XIAOBAI on 15/4/20.
//  Copyright (c) 2015年 XBRefreshExtension. All rights reserved.
//

#import "UIScrollView+XBRefreshExtension.h"
#import "MJRefresh.h"
#import <objc/runtime.h>
#import "UIView+XBHintViewExtension.h"

@implementation UIScrollView (XBRefreshExtend)

static char XBWhenNoDataHideLoadMoreControlKey;
/**
 *  @brief whenNoDataHideLoadMoreControl set 方法
 *
 *  @param whenNoDataHideLoadMoreControl 是否隐藏
 */
- (void)setWhenNoDataHideLoadMoreControl:(BOOL)whenNoDataHideLoadMoreControl {
    if (whenNoDataHideLoadMoreControl != self.whenNoDataHideLoadMoreControl) {
        objc_setAssociatedObject(self, &XBWhenNoDataHideLoadMoreControlKey,[NSNumber numberWithBool:whenNoDataHideLoadMoreControl],OBJC_ASSOCIATION_ASSIGN);
    }
}

/**
 *  @brief whenNoDataHideLoadMoreControl get 方法
 *
 *  @return 是否隐藏
 */
- (BOOL)whenNoDataHideLoadMoreControl {
    return [objc_getAssociatedObject(self, &XBWhenNoDataHideLoadMoreControlKey) boolValue];
}


static char XBRefreshDelegateKey;
/**
 *  @brief refreshDelegate set 方法
 *
 *  @param refreshDelegate 代理对象
 */
- (void)setRefreshDelegate:(id<XBTableViewRefreshDelegate>)refreshDelegate {
    if (refreshDelegate != self.refreshDelegate) {
        objc_setAssociatedObject(self, &XBRefreshDelegateKey,refreshDelegate,OBJC_ASSOCIATION_ASSIGN);
    }
}

/**
 *  @brief refreshDelegate get 方法
 *
 *  @return 代理对象
 */
- (id<XBTableViewRefreshDelegate>)refreshDelegate {
    return objc_getAssociatedObject(self, &XBRefreshDelegateKey);
}

static char XBTotalPageKey;
/**
 *  @brief totalPage set 方法
 *
 *  @param page 页数
 */
- (void)setTotalPage:(NSUInteger)totalPage {
    objc_setAssociatedObject(self, &XBTotalPageKey,[NSNumber numberWithUnsignedInteger:totalPage],OBJC_ASSOCIATION_ASSIGN);
    
    if (totalPage == 0) {
        [self checkIsHideFooter];
    }else if (self.page >= totalPage) {
        [self setHasMore:NO];
    }else {
        [self setHasMore:YES];
    }
}

/**
 *  @brief totalPage get 方法
 *
 *  @return totalPage
 */
- (NSUInteger)totalPage {
    return [objc_getAssociatedObject(self, &XBTotalPageKey) unsignedIntegerValue];
}

static char XBPageKey;
/**
 *  @brief page set 方法
 *
 *  @param page 页数
 */
- (void)setPage:(NSUInteger)page {
    objc_setAssociatedObject(self, &XBPageKey,[NSNumber numberWithUnsignedInteger:page],OBJC_ASSOCIATION_ASSIGN);
}

/**
 *  @brief page get 方法
 *
 *  @return page
 */
- (NSUInteger)page {
    return [objc_getAssociatedObject(self, &XBPageKey) unsignedIntegerValue];
}

static char XBIsSilentLoadKey;
/**
 *  @brief isSilentLoad set 方法
 *
 *  @param isSilentLoad
 */
- (void)setIsSilentLoad:(BOOL)isSilentLoad {
    objc_setAssociatedObject(self, &XBIsSilentLoadKey,[NSNumber numberWithBool:isSilentLoad],OBJC_ASSOCIATION_ASSIGN);
}

/**
 *  @brief isIsSilentLoad get 方法
 *
 *  @return isIsSilentLoad
 */
- (BOOL)isSilentLoad {
    return [objc_getAssociatedObject(self, &XBIsSilentLoadKey) boolValue];
}

/**
 *  @brief 初始化设置
 */
- (void)setup {
    self.whenNoDataHideLoadMoreControl = YES;
    self.header.updatedTimeHidden = YES;
}

/**
 *  @brief 添加顶部刷新控件
 */
- (void)addRefreshControl {
    [self setup];
    [self addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
}

/**
 *  @brief 刷新事件处理方法
 */
- (void)refreshAction {
    [self setIsSilentLoad:NO];
    [self setPage:1];
    if ([self.refreshDelegate respondsToSelector:@selector(req:page:tableView:)]) {
        [self.refreshDelegate req:XBRefreshTypeRefresh page:self.page tableView:self];
    }
}

/**
 *  @brief 添加底部加载更多控件
 */
- (void)addLoadMoreControl {
    [self setup];
    [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    [self.footer setHidden:self.whenNoDataHideLoadMoreControl];
}

/**
 *  @brief 加载更多事件处理方法
 */
- (void)loadMoreAction {
    [self setIsSilentLoad:NO];
    [self setPage:(self.page + 1)];
    if ([self.refreshDelegate respondsToSelector:@selector(req:page:tableView:)]) {
        [self.refreshDelegate req:XBRefreshTypeLoadMore page:self.page tableView:self];
    }
}

/**
 *  @brief 添加刷新和加载更多控件
 */
- (void)addRefreshAndLoadMore
{
    // 去掉分割线
    if ([self isKindOfClass:[UITableView class]]) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [(UITableView *)self setTableFooterView:view];
    }
    
    [self setup];
    // 添加刷新控件
    [self addRefreshControl];
    // 添加加载更多
    [self addLoadMoreControl];
}

/**
 *  @brief 立即刷新
 */
- (void)refresh {
    [self.header setHidden:NO];
    [self.header beginRefreshing];
}

/**
 *  @brief 静默加载,全局菊花，加载完成后需隐藏
 */
- (void)silentLoad {
    [self showHintViewWithType:XBHintViewTypeLoading tapHandler:nil];
    [self setIsSilentLoad:YES];
    [self setPage:1];
}

/**
 *  @brief 结束静默加载
 */
- (void)endSilentLoad {
    [self hideHintView];
}

/**
 *  @brief 设置是否还有更多数据，为NO时底部将显示没有更多，不显示加载更多视图
 *
 *  @param hasMore 是否还有更多
 */
- (void)setHasMore:(BOOL)hasMore {
    [self.footer setHidden:NO];
    if (!hasMore) {
        [self.footer noticeNoMoreData];
    }else {
        [self.footer resetNoMoreData];
    }
}

/**
 *  @brief 刷新完成后调用，关闭刷新视图
 */
- (void)didRefreshFinished {
    [self.header endRefreshing];
}

/**
 *  加载更多完成后调用，关闭加载更多视图
 */
- (void)didLoadMoreFinished {
    [self.footer endRefreshing];
}

/**
 *  @brief 检查是否隐藏底部刷新控件
 */
- (void)checkIsHideFooter {
    if (self.whenNoDataHideLoadMoreControl) {
        if ([self isKindOfClass:[UITableView class]]) {
            if ([((UITableView *)self).dataSource tableView:(UITableView *)self numberOfRowsInSection:0] > 0) {
                [self.footer setHidden:NO];
            }else {
                [self.footer setHidden:YES];
            }
        }else if ([self isKindOfClass:[UICollectionView class]]) {
            if ([((UICollectionView *)self).dataSource collectionView:(UICollectionView *)self numberOfItemsInSection:0] > 0) {
                [self.footer setHidden:NO];
            }else {
                [self.footer setHidden:YES];
            }
        }
    }
}

/**
 *  @brief 结束所有刷新事件
 */
- (void)endAllRefresh {
    if (self.header.state == MJRefreshHeaderStateRefreshing) {
        [self didRefreshFinished];
    }
    if (self.footer.state == MJRefreshFooterStateRefreshing) {
        [self didLoadMoreFinished];
    }
}

@end
