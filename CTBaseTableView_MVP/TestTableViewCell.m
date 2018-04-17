//
//  TestTableViewCell.m
//  CTBaseTableView_MVP
//
//  Created by 陈腾 on 2018/4/17.
//  Copyright © 2018年 腾. All rights reserved.
//

#import "TestTableViewCell.h"
#import "TestCellModel.h"

@implementation TestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//单元格数据处理和界面布局《单元格实现该方法》
- (void)processCellData:(id <CTBaseTableViewCellModelProtocol>)data
              indexPath:(NSIndexPath *)indexPath{
    TestCellModel *model = (TestCellModel *)data;
    self.textLabel.text = model.contactName;
    self.detailTextLabel.text = model.contactNumber;
}
@end
