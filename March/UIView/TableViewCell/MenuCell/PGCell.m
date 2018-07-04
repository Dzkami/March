//
//  PGCell.m
//  March
//
//  Created by Dzkami on 2018/7/1.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "PGCell.h"
@interface PGCell()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation PGCell
@synthesize item = _item;
@synthesize  isOpen = _isOpen;

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"projectGroupCell";
    PGCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PGCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setLabel {
    _label.text = _item.title;
    if([_item.subItems count] > 0) {
        _detailLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_item.subItems count]];
    } else {
        _detailLabel.text = @"-";
    }
}

- (void)setLevel:(NSInteger) level {
    if(self.item) {
        //        if(!label) {
        //            label = [[UILabel alloc] init];
        //        }
        _label.text = _item.title;
        
        //        if(!detailLabel) {
        //            detailLabel = [[UILabel alloc] init];
        //        }
        if([_item.subItems count] > 0) {
            _detailLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_item.subItems count]];
        } else {
            _detailLabel.text = @"-";
        }
    }
    
//    CGRect rect;
//    rect = _label.frame;
//    rect.origin.x = level * 20;
//    _label.frame = rect;
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
