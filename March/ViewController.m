//
//  ViewController.m
//  March
//
//  Created by Dzkami on 2018/6/28.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ViewController.h"
#import "SqliteUtil.h"
#import "MenuViewController.h"
#import "MainViewController.h"
#import "User.h"

static const CGFloat criticalValue = 320/3.0;
@interface ViewController () {
    SqliteUtil *sqlite;
}

@property (nonatomic, assign) CGPoint startTouchPoint;
@property (nonatomic, strong) MenuViewController *vc_menu;
@property (nonatomic, strong) MainViewController *vc_main;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    sqlite = [[SqliteUtil alloc] init];
//    [sqlite open_db];
    
    [self.navigationController setNavigationBarHidden:true];
    
    _vc_menu = [[MenuViewController alloc] init];
    [self.view addSubview:_vc_menu.view];
    
    _vc_main = [[MainViewController alloc] init];
    [self.view addSubview:_vc_main.view];
//    [_vc_main goToMenu:_vc_menu];
    
    [self transferToMenu];
//    
//    
//    NSString *sql = @"SELECT * FROM UserInfo;";
//    FMResultSet *result = [sqlite search_db:sql];
//    
//    while([result next]) {
//        NSString *userId = [result stringForColumn:@"userId"];
//        NSString *userName = [result stringForColumn:@"userName"];
//        NSLog(@"id:%@  name:%@",userId,userName);
//    }
    
}



- (void)transferToMenu {
    self.startTouchPoint = CGPointZero;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.vc_main.view addGestureRecognizer:pan];
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    CGPoint touchPoint = [pan locationInView:[[UIApplication sharedApplication]keyWindow]];
    
    if(pan.state == UIGestureRecognizerStateBegan) {
        self.startTouchPoint = touchPoint;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat touchPointDefrence = touchPoint.x - self.startTouchPoint.x;
        
        if(touchPointDefrence < 0) { //返回
            touchPointDefrence = 0;
        }
        
        [self.vc_main.view setFrame:CGRectMake(touchPointDefrence, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
    } else if(pan.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.2 animations:^{
            if(self.vc_main.view.frame.origin.x < criticalValue) {
                 [self.vc_main.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            } else {
                [self.vc_main.view setFrame:CGRectMake(320, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
