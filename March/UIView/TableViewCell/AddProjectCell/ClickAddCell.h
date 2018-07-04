//
//  ClickAddCell.h
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "CreateProjectModel.h"

@interface ClickAddCell : BasicTableViewCell
+(instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)refreshContentFromModel:(CreateProjectModel *)model;

@end
