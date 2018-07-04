//
//  ProjectHeaderCellTableViewCell.h
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"

@interface ProjectHeaderCell : BasicTableViewCell
@property (nonatomic, retain) MyItem *item;
@property (nonatomic) BOOL isOpen;

+(instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)setProjectGoal:(NSString *)projectGoal;
@end
