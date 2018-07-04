//
//  Task.h
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject
@property(nonatomic, assign)NSInteger taskId;
@property(nonatomic, copy)NSString *taskName;
@property(nonatomic, assign)NSInteger TTId;
@property(nonatomic, retain)NSDate *createDate;
@property(nonatomic, retain)NSDate *finishDate;
@property(nonatomic, assign)double EFHour;
@property(nonatomic, assign)double AFHour;
@property(nonatomic, copy)NSString *userId;
@property(nonatomic, assign)NSInteger TSateId;

@end
