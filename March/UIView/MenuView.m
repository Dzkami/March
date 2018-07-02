//
//  MenuView.m
//  March
//
//  Created by Dzkami on 2018/6/30.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "MenuView.h"
//
//@interface MenuView() {
//    UITableView *tv_menuTree;
//}
//@end

@implementation MenuView
- (id)init {
    self = [super init];
    if(self) {
        [self setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        [self createTopFuncView];
        [self createMenuTreeView];
    }
    return self;
}

//tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

- (void)createTopFuncView {
    _topFuncView = [[UIView alloc] init];
    [self addSubview:_topFuncView];
    
    _bt_userName = [[UIButton alloc] init];
    [_bt_userName setTitle:@"点击登录" forState:UIControlStateNormal];
    [_bt_userName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _bt_userName.titleLabel.font = [UIFont systemFontOfSize:30];
    _bt_userName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.topFuncView addSubview:_bt_userName];
    
    _lb_userId = [[UILabel alloc] init];
    [_lb_userId setFont:[UIFont systemFontOfSize:17]];
    [_lb_userId setAlpha:0.5];
    [_lb_userId setText:@""];
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

- (void)createMenuTreeView {
    _tv_menuTree = [[UITableView alloc] init];
    [self addSubview:_tv_menuTree];
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
    
    [self.tv_menuTree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topFuncView.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.bt_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topFuncView.mas_top).offset(25);
        make.bottom.equalTo(self.lb_userId.mas_top).offset(3);
        make.left.equalTo(self.topFuncView.mas_left).offset(10);
        make.right.equalTo(self.bt_add.mas_left).offset(-15);
    }];
    
    [self.lb_userId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topFuncView.mas_bottom).offset(10);
        make.left.equalTo(self.topFuncView.mas_left).offset(10);
        make.right.equalTo(self.topFuncView.mas_right);
    }];
    
    [self.bt_add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(25, 25)));
        make.centerY.equalTo(self.topFuncView.mas_centerY);//垂直居中
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
