//
//  ClickAddTaskCell.m
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ClickAddTaskCell.h"
@interface ClickAddTaskCell()
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UIButton *bt_addTask;


@end

@implementation ClickAddTaskCell

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"ClickAddTaskCell";
    ClickAddTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClickAddTaskCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setDateText:(NSString *)dateStr {
    self.lb_date.text = dateStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
