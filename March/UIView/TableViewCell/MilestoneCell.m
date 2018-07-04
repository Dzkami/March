//
//  MilestoneCell.m
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "MilestoneCell.h"
@interface MilestoneCell()
@property (weak, nonatomic) IBOutlet UIImageView *img_milestoneState;
@property (weak, nonatomic) IBOutlet UILabel *lb_milestoneName;


@end

@implementation MilestoneCell

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"MilestoneCell";
    MilestoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MilestoneCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setMilesoneStateImg:(UIImage *)img {
    _img_milestoneState.image = img;
}

- (void)setMilestoneName:(NSString *)milestoneName {
    self.lb_milestoneName.text = milestoneName;
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
