//
//  ProjectInfoMailStoneCell.m
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ProjectInfoMileStoneCell.h"

@interface ProjectInfoMileStoneCell()<UITextFieldDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UITextField *tf_msName;
@property (weak, nonatomic) IBOutlet UITextField *tf_msDate;
@property (nonatomic, copy) NSString *key;

@end

@implementation ProjectInfoMileStoneCell

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"ProjectInfoMileStoneCell";
    ProjectInfoMileStoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectInfoMileStoneCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _tf_msName.delegate = self;
    _tf_msName.tag = 0;
    _tf_msDate.delegate = self;
    _tf_msDate.tag = 1;
    
     [_tf_msName addTarget:self action:@selector(textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];

    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];//设置时区
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker setDate:[NSDate date] animated:true];
    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    
    
    _tf_msDate.inputView = _datePicker;
}

- (void)refreshContentFromModel:(CreateProjectModel *)model {
    if(!model)
        return;
    
    _key = model.key; //记录是第几个里程碑
    
    if(model.text.length) {
        _tf_msName.text = model.text;
    }
    
    if(model.date) {
        _datePicker.date = model.date;
        _tf_msDate.text = [Util transDateToString:model.date];
    }
    
    

}

- (void)dateChange:(UIDatePicker *)datePicker {
    NSDate *newDate = datePicker.date;
    _tf_msDate.text = [Util transDateToString:newDate];
    self.dateBlock(self.key, newDate);
}

- (void)textFieldTextDidChange{
    self.nameBlock(self.key, self.tf_msName.text);
}

//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == 1)
        return false;
    else
        return true;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_tf_msDate resignFirstResponder];
    [_tf_msName resignFirstResponder];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
