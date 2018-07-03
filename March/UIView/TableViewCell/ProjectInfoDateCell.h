//
//  ProjectInfoDateCell.h
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "CreateProjectModel.h"

@interface ProjectInfoDateCell : BasicTableViewCell

@property (nonatomic, copy) void(^dateBlock)(NSString *, NSDate *);
@property (nonatomic, retain) NSDate *startDate;

+(instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)refreshContentFromModel:(CreateProjectModel *)model;
@end
