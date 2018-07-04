//
//  MilestoneCell.h
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"

@interface MilestoneCell : BasicTableViewCell
@property (nonatomic, retain) MyItem *item;
@property (nonatomic) BOOL isOpen;

+(instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)setMilesoneStateImg:(UIImage *)img;
- (void)setMilestoneName:(NSString *)milestoneName;
@end
