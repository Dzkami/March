//
//  ProjectInfoDateCell.m
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ProjectInfoDateCell.h"

@interface ProjectInfoDateCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
//@property (nonatomic, copy) NSString *key;
@property (nonatomic, retain) CreateProjectModel *model;

@end

@implementation ProjectInfoDateCell

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"ProjectInfoDateCell";
    ProjectInfoDateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectInfoDateCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _timeTextField.delegate = self;
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];//设置时区
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
//     [_datePicker setDate:[NSDate date] animated:true];//设置为今日时间
//    _timeTextField.text = [Util transDateToString:_datePicker.date];
    _timeTextField.inputView = _datePicker;
//    [_timeTextField addTarget:self action:@selector(textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)refreshContentFromModel:(CreateProjectModel *)model {
    if(!model) {
        return;
    }
    _model = model;
    _label.text = model.title;
    _timeTextField.placeholder = model.placeholder;
    
    if([model.key isEqualToString:@"startDate"]) {
        _datePicker.date = [NSDate date];
        _timeTextField.text = [Util transDateToString:[NSDate date]];
    }
    
    if(model.date) {
        _datePicker.date = model.date;
        _timeTextField.text = [Util transDateToString: model.date];
    }
    
}

- (void)dateChange:(UIDatePicker *)datePicker {
    _timeTextField.text = [Util transDateToString:datePicker.date];

    if([_model.key isEqualToString: @"EEndDate"]) {
        NSComparisonResult compare = [datePicker.date compare:self.startDate];
        if(compare == NSOrderedAscending) { //小于开始时间
            datePicker.date = self.startDate;
            _timeTextField.text = [Util transDateToString:datePicker.date];
        } else {
            self.dateBlock(self.model.key, datePicker.date);
        }
    } else {
        self.dateBlock(self.model.key, datePicker.date);
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


//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return false;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_timeTextField resignFirstResponder];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
