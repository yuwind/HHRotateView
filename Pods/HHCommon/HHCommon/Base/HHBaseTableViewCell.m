//
//  HHBaseTableViewCell.m
//  HHCommon
//
//  Created by yufeng on 2022/5/12.
//

#import "HHBaseTableViewCell.h"

@implementation HHBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)updateCellWithModel:(id)model {}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
