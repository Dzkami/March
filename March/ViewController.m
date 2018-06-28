//
//  ViewController.m
//  March
//
//  Created by Dzkami on 2018/6/28.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "ViewController.h"
#import "SqliteUtil.h"

@interface ViewController () {
    SqliteUtil *sqlite;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sqlite = [[SqliteUtil alloc] init];
    [sqlite open_db];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
