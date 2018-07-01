//
//  MainViewController.m
//  March
//
//  Created by Dzkami on 2018/6/29.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
 
@interface MainViewController () {
    MenuViewController *vc_menu;
    MainView *vw_main;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
   
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"进行中项目"];
    [bar pushNavigationItem:navigationItem animated:true];
    [self.view addSubview:bar];
    
    UIBarButtonItem *menuBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStylePlain target:self action:@selector(goToMenu)];
    [navigationItem setLeftBarButtonItem:menuBtnItem];
    
}

- (void)goToMenu:(MenuViewController *)menu {
    vc_menu = menu;
}

- (void)goToMenu {
//    [self presentModalViewController:vc_menu animated:YES];
}

@end
