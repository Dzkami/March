//
//  MenuViewController.m
//  March
//
//  Created by Dzkami on 2018/6/29.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuView.h"

@interface MenuViewController () {
    MenuView *vw_menu;
    NSString *userName;
    NSString *userId;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    
    userName = @"text拖拖拖";
    userId = @"1233444@qq.com";
    [self initTopFuncView];
}

- (void)getUserInfo {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    userName = [userDefault objectForKey:@"userName"];
    userId = [userDefault objectForKey:@"userId"];
}

- (void)initTopFuncView {
    vw_menu = [[MenuView alloc] init];
    [vw_menu.lb_userName setText:userName];
    [vw_menu.lb_userId setText:userId];
    [self.view addSubview:vw_menu];
}
@end
