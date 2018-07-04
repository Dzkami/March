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
    BOOL isSlide;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
   
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"项目"];
    [bar pushNavigationItem:navigationItem animated:true];
    [self.view addSubview:bar];
    
    UIBarButtonItem *menuBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单"] style:UIBarButtonItemStylePlain target:self action:@selector(transferSlideMenu)];
    [navigationItem setLeftBarButtonItem:menuBtnItem];
    
}

//- (void)goToMenu:(MenuViewController *)menu {
//    vc_menu = menu;
//}

- (void)transferSlideMenu {
//    [self presentModalViewController:vc_menu animated:YES];
    
//收起
    if(isSlide) {
//        animationPlaying = true;
        isSlide = !isSlide;
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
//            self.animationPlaying = false;
        }];
//展开
    } else if(!isSlide){
//        animationPlaying = true;
        isSlide = !isSlide;
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = CGRectMake(320 , 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
//            animationPlaying = false;
        }];
    }
}
    
@end
