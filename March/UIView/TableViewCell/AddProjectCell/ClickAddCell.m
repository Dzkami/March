//
//  ClickAddCell.m
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ClickAddCell.h"
@interface ClickAddCell()
@property (weak, nonatomic) IBOutlet UILabel *lb_addMileStone;

@end

@implementation ClickAddCell

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"ClickAddMileStoneCell";
    ClickAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClickAddCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)refreshContentFromModel:(CreateProjectModel *)model {
    if(!model) {
        return;
    }
    _lb_addMileStone.text = model.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
