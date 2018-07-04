//
//  ProjectCell.h
//  March
//
//  Created by Dzkami on 2018/7/1.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "MyItem.h"

@interface ProjectCell : BasicTableViewCell
+(instancetype)createCellWithTableView:(UITableView *)tableView;
@property (nonatomic, retain) MyItem *item;
- (void)setLabel;
@end
