//
//  MenuView.m
//  March
//
//  Created by Dzkami on 2018/6/30.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "MenuView.h"
#import "RATreeView.h"

@implementation MenuView
- (id)init {
    self = [super init];
    if(self) {
        [self setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        [self createTopFuncView];
        [self createProjectTreeView];
    }
    return self;
}

//tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

- (void)createTopFuncView {
    _topFuncView = [[UIView alloc] init];
    _topFuncView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_topFuncView];
    
    _lb_userName = [[UILabel alloc] init];
    [_lb_userName setFont:[UIFont systemFontOfSize:30]];
    [self.topFuncView addSubview:_lb_userName];
    
    _lb_userId = [[UILabel alloc] init];
    [_lb_userId setFont:[UIFont systemFontOfSize:17]];
    [_lb_userId setAlpha:0.5];
    [self.topFuncView addSubview:_lb_userId];
    
    _bt_add = [[UIButton alloc] init];
    [_bt_add setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [self.topFuncView addSubview:_bt_add];
    
    _bt_search = [[UIButton alloc] init];
    [_bt_search setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [self.topFuncView addSubview:_bt_search];
    
    _bt_message = [[UIButton alloc] init];
    [_bt_message setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    [self addSubview:_bt_message];
}

- (void)createProjectTreeView {
    _projectTreeView = [[UIView alloc] init];
    [self addSubview:_projectTreeView];
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    
    // --- remake/update constraints here
    
    [self.topFuncView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.size.equalTo(@(CGSizeMake(self.frame.size.width, 100)));
    }];
    
    [self.projectTreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topFuncView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.lb_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topFuncView.mas_top).offset(20);
        make.bottom.equalTo(self.lb_userId.mas_top).offset(5);
        make.left.equalTo(self.topFuncView.mas_left).offset(10);
        make.right.equalTo(self.bt_add.mas_left).offset(-15);
    }];
    
    [self.lb_userId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topFuncView.mas_bottom).offset(10);
        make.left.equalTo(self.topFuncView.mas_left).offset(10);
        make.right.equalTo(self.bt_add.mas_left).offset(-15);
    }];
    
    [self.bt_add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(25, 25)));
        make.centerY.equalTo(self.topFuncView);//垂直居中
        make.right.equalTo(self.bt_search.mas_left).offset(-10);
    }];
    
    [self.bt_search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.bt_add);
        make.centerY.equalTo(self.bt_add);
        make.right.equalTo(self.bt_message.mas_left).offset(-10);
    }];
    
    [self.bt_message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.bt_add);
        make.centerY.equalTo(self.bt_add);
        make.right.equalTo(self.topFuncView.mas_right);
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}



@end
