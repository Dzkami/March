//
//  ProjectCell.m
//  March
//
//  Created by Dzkami on 2018/7/1.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ProjectCell.h"
@interface ProjectCell()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ProjectCell
@synthesize item = _item;

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"projectCell";
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setLabel {
    _label.text = _item.title;
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
