//
//  ProjectInfoPickerCell.m
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ProjectInfoPickerCell.h"


@interface ProjectInfoPickerCell() <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *pickerTextView;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, copy) NSString *key;
@end

@implementation ProjectInfoPickerCell

+(instancetype)createCellWithTableView:(UITableView *)tableView {
    NSString *cellId = @"ProjectInfoPickerCell";
    ProjectInfoPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectInfoPickerCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)refreshContentFromModel:(CreateProjectModel *)model {
    if(!model) {
        return;
    }
    
    _label.text = model.title;
    _pickerTextView.placeholder = model.placeholder;
    _dataSource = model.data;
     _key = model.key;
    
    if(model.text.length) {
        _pickerTextView.text = model.text;
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 414, 200)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = true;
    _pickerTextView.inputView = pickerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _pickerTextView.delegate = self;
   
     [_pickerTextView addTarget:self action:@selector(textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextDidChange {
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

#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_dataSource count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _dataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _pickerTextView.text = [_dataSource objectAtIndex:row];
    self.block(self.key, self.pickerTextView.text);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_pickerTextView resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
