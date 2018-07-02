//
//  RegisterViewController.m
//  March
//
//  Created by Dzkami on 2018/7/1.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"


@interface RegisterViewController ()<UITextFieldDelegate> {
    SqliteUtil *sqlite;
    NSString *email;
    NSString *name;
    NSString *password;
    BOOL *isEmailRight, *isNameRight, *isPasswordRight;
}

@property (weak, nonatomic) IBOutlet UITextField *tf_email;
@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sqlite = [[SqliteUtil alloc] init];
    
    _tf_email.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tf_email.delegate = self;
    _tf_email.tag = 0;
    
    _tf_name.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tf_name.delegate = self;
    _tf_name.tag = 1;
    
    _tf_password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_tf_password setSecureTextEntry:true];//设置密码框
    _tf_password.delegate = self;
    _tf_password.tag = 2;
    
    isEmailRight = false;
    isNameRight = false;
    isPasswordRight = false;
}

- (IBAction)registerAction:(id)sender {
    if(isEmailRight && isNameRight && isPasswordRight) {
        //写入数据库/转登录
        [sqlite open_db];
        NSString *insertUser = [NSString stringWithFormat:@"INSERT INTO userInfo(userId, userName, password) VALUES(:userId, :userName, :password)"];
        
        NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:email, @"userId", name, @"userName", password, @"password", nil];
        
        BOOL success = [sqlite add_db:insertUser withParamterDic:infoDic];
        if(success) {
            NSLog(@"注册存储成功");
        } else {
            NSLog(@"注册存储失败");
        }
        [sqlite close_db];
        [self toLoginViewAction:nil];
    }
}


- (IBAction)toLoginViewAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *vc_login = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    [self presentViewController:vc_login animated:true completion:nil];
}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.text.length == 0) {
        [Util shake:textField];
        return;
    }
    
    if((textField.tag == 0) && [self emailCheck]) {
        //邮箱判断
        email = _tf_email.text;
        isEmailRight = true;
    } else if ((textField.tag == 1) && [self nameCheck]) {
        //用户名判断
        name = _tf_name.text;
        isNameRight = true;
    } else if((textField.tag == 2) && [self passwordCheck]) {
        //密码判断
        password = _tf_password.text;
        isPasswordRight = true;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark -- CheckInput
-(BOOL)emailCheck {
    //正确性check
    BOOL isRight = [self checkEmailForm];
    if(isRight) {
        return ![self checkIdExist];
    }
    return false;
}

- (BOOL)checkEmailForm {
    //正则表达式
    return true;
}

- (BOOL)checkIdExist{
    [sqlite open_db];
    NSString *searchId = [NSString stringWithFormat:@"SELECT * FROM userInfo WHERE userId = '%@'", _tf_email.text];
    FMResultSet *users = [sqlite search_db:searchId];
    BOOL isExist = false;
    while([users next]) {
        NSString *ID = [users stringForColumn:@"userId"];
        if([ID isEqualToString:_tf_email.text]) {
            [self showAlertMessage:@"该ID已注册"];
            isExist = true;
            break;
        }
    }
    [sqlite close_db];
    return isExist;
}

- (BOOL)nameCheck {
//    if ([_tf_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0){
//        [self showAlertMessage:@"名字不能包含空格"];
//        return false;
//    }else {
//        return true;
//    }
    return true;
}

- (BOOL)passwordCheck {
    //    NSString *inputPassword = _tf_password.text;
    //    if(inputPassword.length < 6) {
    //        [self showAlertMessage:@"密码长度为6~30个字符"];
    //        return false;
    //    }
    return true;
}

#pragma mark -- Alert
- (void)showAlertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}


@end
