//
//  HHBaseTableViewController.h
//  BaseTabBar
//
//  Created by yufeng on 2017/6/22.
//  Copyright © 2017年 yufeng. All rights reserved.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHBaseTableViewController : HHBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;

//need to override
- (NSArray *)modelArray;
- (NSArray<Class> *)registerReusableCell;
- (nullable NSString *)reusableIdentifier;

@end

NS_ASSUME_NONNULL_END
