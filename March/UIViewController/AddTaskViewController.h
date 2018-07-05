//
//  AddTaskViewController.h
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "BasicViewController.h"
#import "Task.h"

@protocol DataCallBackDelegate <NSObject>
-(void)willDismissModalView:(id)sender;
@end

@interface AddTaskViewController : BasicViewController

@property (weak, nonatomic) id<DataCallBackDelegate> dataDelegate;
@property (nonatomic, retain)Task *task;
@end
