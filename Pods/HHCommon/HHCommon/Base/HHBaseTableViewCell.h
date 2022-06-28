//
//  HHBaseTableViewCell.h
//  HHCommon
//
//  Created by yufeng on 2022/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHBaseTableViewCell : UITableViewCell

@property (nonatomic, weak) id delegate;

//need to override
- (void)updateCellWithModel:(_Nullable id)model;

@end

NS_ASSUME_NONNULL_END
