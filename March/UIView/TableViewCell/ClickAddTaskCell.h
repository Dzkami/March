//
//  ClickAddTaskCell.h
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"

@interface ClickAddTaskCell : BasicTableViewCell
+(instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)setDateText:(NSString *)dateStr;
@end
