//
//  AddTaskViewController.m
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "AddTaskViewController.h"
#import "Task.h"

@interface AddTaskViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    double hour;
    double minute;
    NSString *taskAddDate;
}
@property (weak, nonatomic) IBOutlet UITextField *tf_taskName;
@property (weak, nonatomic) IBOutlet UITextField *tf_taskType;
@property (weak, nonatomic) IBOutlet UITextField *tf_eFhour;

@property (nonatomic, retain) NSArray *ds_taskType;
@property (nonatomic, retain) NSMutableArray *ds_eFHours;
@property (nonatomic, retain) NSMutableArray *ds_eFMinutes;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    taskAddDate = [userDefaults objectForKey:@"taskAddDate"];
    
    _ds_taskType = [[NSArray alloc] initWithObjects:@"--选择任务类型--", @"简单的任务", @"略复杂的任务", @"极其复杂的任务", nil];
    
    _ds_eFHours = [NSMutableArray array];
    _ds_eFMinutes = [NSMutableArray array];
    for (int i = 0; i <= 24; i++) {
        [_ds_eFHours addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i <= 60; i++) {
        [_ds_eFMinutes addObject:[NSNumber numberWithInt:i]];
    }
    
    _tf_taskName.tag = 0;
    _tf_taskName.delegate = self;
    
    
    _tf_taskType.tag = 1;
    _tf_taskType.delegate = self;
    UIPickerView *pv_typePick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 414, 200)];
    pv_typePick.tag = 10;
    pv_typePick.delegate = self;
    pv_typePick.dataSource = self;
    pv_typePick.showsSelectionIndicator = true;
    _tf_taskType.inputView = pv_typePick;
    
    _tf_eFhour.tag = 2;
    _tf_eFhour.delegate = self;
    UIPickerView *pv_timePick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 414, 200)];
    pv_timePick.tag = 20;
    pv_timePick.delegate = self;
    pv_timePick.dataSource = self;
    pv_timePick.showsSelectionIndicator = true;
    _tf_eFhour.inputView = pv_timePick;
    
}

#pragma mark -- BarButton Action
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)finishAction:(id)sender {
    if(_tf_taskName.text.length > 0 && _tf_taskType.text.length > 0 && _tf_eFhour.text.length > 0 && ([_ds_taskType indexOfObject:_tf_taskType.text] > 0)) {
        Task *task = [[Task alloc] init];
        task.taskName = _tf_taskName.text;
        task.TTId = [_tf_taskType.text integerValue];
        task.EFHour = [_tf_eFhour.text doubleValue];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        task.userId = [userDefaults objectForKey:@"userId"];
        task.projectId = [[userDefaults objectForKey:@"presentProjectId"] integerValue];
        task.TSateId = TaskStateType_NotFinish;
        task.TTId = [_ds_taskType indexOfObject:_tf_taskType.text];
        task.createDate = taskAddDate;
        self.task = task;
        [self saveTask:task];
        [self dismissViewControllerAnimated:true completion:^{
            [self.dataDelegate willDismissModalView:self];
        }];
    }
}

- (void)saveTask:(Task *)task {
    SqliteUtil *sqlite = [[SqliteUtil alloc] init];
    [sqlite open_db];
    
    NSString *insertTaskStr = [NSString stringWithFormat:@"INSERT INTO Task(taskName, projectId, userId, TTId, createDate, EFHour, TStateId) VALUES(:taskName, :projectId, :userId, :TTId, :createDate, :EFHour, :TStateId)"];
    
    NSDictionary *insertTaskDic = [[NSDictionary alloc] initWithObjectsAndKeys:
    task.taskName, @"taskName",
    [NSNumber numberWithInteger:task.projectId],@"projectId",
    task.userId, @"userId",
    [NSNumber numberWithInteger:task.TTId], @"TTId",
    task.createDate,@"createDate",
    [NSNumber numberWithDouble:task.EFHour], @"EFHour",
    [NSNumber numberWithInteger:task.TSateId], @"TStateId",
    nil];
    
    [sqlite add_db:insertTaskStr withParamterDic:insertTaskDic];
    [sqlite close_db];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.text.length == 0) {
        [Util shake:textField];
    }
    
    if(textField.tag == 1) {
        if([_ds_taskType indexOfObject:textField.text] == 0) {
            [Util shake:textField];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消当前键盘输入响应
    return true;
}

//禁止用户输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == 0)
        return true;
    else
        return false;
}

#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(pickerView.tag == 10)
        return 1;
    else
        return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView.tag == 10) {
        return [_ds_taskType count];
    } else {
        if(component == 0)
            return 24;
        else
            return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView.tag == 10)
        return _ds_taskType[row];
    else {
        
        if(component == 0)
            return [NSString stringWithFormat:@"%@", _ds_eFHours[row]];
        else
            return [NSString stringWithFormat:@"%@", _ds_eFMinutes[row]];;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView.tag == 10) {
        _tf_taskType.text = _ds_taskType[row];
    } else {
        
        if(component == 0) {
            hour = [_ds_eFHours[row] doubleValue];
        }else {
            minute = [_ds_eFMinutes[row] doubleValue] / 60.0;
        }
        _tf_eFhour.text = [NSString stringWithFormat:@"%.2lf 小时",hour + minute];
//        if(component == 0) {
//            hour = 0;
//        } else {
//            minute = 0;
//        }
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_tf_taskType resignFirstResponder];
    [_tf_taskName resignFirstResponder];
    [_tf_eFhour resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    // Configure the view for the selected state
}

@end
