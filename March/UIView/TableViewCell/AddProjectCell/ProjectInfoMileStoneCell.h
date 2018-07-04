//
//  ProjectInfoMailStoneCell.h
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "CreateProjectModel.h"

@interface ProjectInfoMileStoneCell : BasicTableViewCell
@property (nonatomic, copy) void(^nameBlock)(NSString *, NSString *);

@property (nonatomic, copy) void(^dateBlock)(NSString *, NSDate *);
@property(nonatomic, strong) UIDatePicker *datePicker;

+(instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)refreshContentFromModel:(CreateProjectModel *)model;
@end
