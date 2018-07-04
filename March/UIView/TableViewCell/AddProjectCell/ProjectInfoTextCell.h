//
//  ProjectInfoCell.h
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "CreateProjectModel.h"

@interface ProjectInfoTextCell : BasicTableViewCell

@property (nonatomic, copy) void(^block)(NSString *, NSString *);

+ (instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)refreshContentFromModel:(CreateProjectModel *)model;



@end
