//
//  ProjectInfoCell.m
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ProjectInfoTextCell.h"

@interface ProjectInfoTextCell() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) NSString *key;
@end

@implementation ProjectInfoTextCell

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"ProjectInfoTextCell";
    ProjectInfoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectInfoTextCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)refreshContentFromModel:(CreateProjectModel *)model {
    if(!model) {
        return;
    }
    _label.text = model.title;
    _textField.placeholder = model.placeholder;
    _key = model.key;
    
    if(model.text.length) {
        _textField.text = model.text;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.text.length == 0) {
        [Util shake:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消当前键盘输入响应
    return true;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextDidChange {
    self.block(self.key, self.textField.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
