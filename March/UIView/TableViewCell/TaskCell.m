//
//  TaskCell.m
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell()
@property (weak, nonatomic) IBOutlet UIImageView *img_taskState;
@property (weak, nonatomic) IBOutlet UILabel *lb_taskName;



@end

@implementation TaskCell

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"TaskCell";
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setTaskStateImgHidden:(BOOL)isHidden {
    [_img_taskState setHidden:isHidden];
}

- (void)setTaskStateImg:(UIImage *)img {
    self.img_taskState.image = img;
}

- (void)setTaskName:(NSString *)taskName {
    self.lb_taskName.text = taskName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [_img_taskState setHidden:true];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
