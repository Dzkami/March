//
//  PGCell.h
//  March
//
//  Created by Dzkami on 2018/7/1.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "MyItem.h"

@interface PGCell : BasicTableViewCell

@property (nonatomic, retain) MyItem *item;
@property (nonatomic) BOOL isOpen;

+(instancetype)createCellWithTableView:(UITableView *)tableView;
- (void)setLabel;
//- (void)setLevel:(NSInteger) level;

@end
