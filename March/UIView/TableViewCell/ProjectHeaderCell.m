//
//  ProjectHeaderCellTableViewCell.m
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ProjectHeaderCell.h"

@interface ProjectHeaderCell()
@property (weak, nonatomic) IBOutlet UILabel *lb_projectGoal;
@property (weak, nonatomic) IBOutlet UIImageView *img_projectState;

@end

@implementation ProjectHeaderCell

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"ProjectHeaderCell";
    ProjectHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectHeaderCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setProjectGoal:(NSString *)projectGoal {
    self.lb_projectGoal.text = projectGoal;
}

- (void)setProjectStateImg:(UIImage *)img {
    [self.img_projectState setImage:img];
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
