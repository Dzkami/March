//
//  TaskCell.h
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"

@interface TaskCell : BasicTableViewCell
+(instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)setTaskStateImgHidden:(BOOL)isHidden;
- (void)setTaskStateImg:(UIImage *)img;
- (void)setTaskName:(NSString *)taskName;
@end
