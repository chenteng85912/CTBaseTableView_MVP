//
//  TableViewCell.m
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "TableViewCell.h"
#import "TestCellModel.h"

@interface TableViewCell ()

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)processCellData:(id <CT_TableViewCellModelProtocol>)data{
    self.textLabel.text = [(TestCellModel *)data DEPTNAME];
    self.detailTextLabel.text = [(TestCellModel *)data SXZXNAME];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
