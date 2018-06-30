//
//  MenuView.h
//  March
//
//  Created by Dzkami on 2018/6/30.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicView.h"

@interface MenuView : BasicView
@property (nonatomic, strong) UIView *topFuncView;
@property (nonatomic, strong) UIView *projectTreeView;
@property (nonatomic, strong) UILabel *lb_userName;
@property (nonatomic, strong) UILabel *lb_userId;
@property (nonatomic, strong) UIButton *bt_add;
@property (nonatomic, strong) UIButton *bt_search;
@property (nonatomic, strong) UIButton *bt_message;

- (id)init;
@end
