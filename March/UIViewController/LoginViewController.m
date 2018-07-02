//
//  LoginViewController.m
//  March
//
//  Created by Dzkami on 2018/7/1.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ViewController.h"

@interface LoginViewController () <UITextFieldDelegate> {
    NSString *email;
    NSString *password;
    BOOL *isEmailRight, *isPasswordRight;
}
@property (weak, nonatomic) IBOutlet UITextField *tf_email;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tf_email.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tf_email.delegate = self;
    _tf_email.tag = 0;
    
    _tf_password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_tf_password setSecureTextEntry:true];//设置密码框
    _tf_password.delegate = self;
    _tf_password.tag = 1;
    
    isEmailRight = false;
    isPasswordRight = false;
}

- (IBAction)loginAction:(id)sender {
    if(isEmailRight && isPasswordRight) {
        if([self checkIdAndPassword]) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:email forKey:@"userId"];
            [self presentViewController:[[ViewController alloc] init] animated:true completion:nil];//登录成功
        }
    }

}

- (IBAction)toRegisterViewAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RegisterViewController *vc_register = [storyboard instantiateViewControllerWithIdentifier:@"registerView"];
    [self presentViewController:vc_register animated:true completion:nil];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.text.length == 0) {
        [Util shake:textField];
    }
  
    if((textField.tag == 0) && [self emailCheck]) {
        email = _tf_email.text;
        isEmailRight = true;
    } else if((textField.tag == 1) && [self passwordCheck]) {
        password = _tf_password.text;
        isPasswordRight = true;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消当前键盘输入响应
    return true;
}

- (BOOL)emailCheck {
//    NSString *inputEmail = _tf_email.text;
//    NSString *pattern = @"(“^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\.\\w+([-.]\\w+)*$”)";
//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
//
//    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:inputEmail options:0 range:NSMakeRange(0, inputEmail.length)];
//    if(result) {
//        for (int i = 0; i < result.count; i++) {
//            NSTextCheckingResult *res = result[i];
//            NSLog(@"str == %@", [inputEmail substringWithRange:res.range]);
//        }
//    } else {
//        NSLog(@"error == %@", error.description);
//        [self showAlertMessage:@"邮箱格式错误"];
//        return false;
//    }
//
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

- (BOOL)checkIdAndPassword {
    SqliteUtil *sqlite = [[SqliteUtil alloc] init];
    [sqlite open_db];
    
    NSString *searchId = [NSString stringWithFormat:@"SELECT * FROM userInfo"];
    FMResultSet *users = [sqlite search_db:searchId];
    BOOL isExist = false;
    while([users next]) {
        NSString *ID = [users stringForColumn:@"userId"];
        if([ID isEqualToString:email]) {
            NSString *pass = [users stringForColumn:@"password"];
            if([pass isEqualToString:password]) {
                isExist = true;
            } else {
                [self showAlertMessage:@"密码错误"];//id存在密码错误
            }
            break;
        }
    }
    if(!isExist) {
        [self showAlertMessage:@"ID不存在"];//id不存在
    }
    [sqlite close_db];
    
    return isExist;
}

#pragma mark -- Alert
- (void)showAlertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}

@end
