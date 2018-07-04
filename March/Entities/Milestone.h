//
//  Milestone.h
//  March
//
//  Created by Dzkami on 2018/7/4.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Milestone : NSObject

@property(nonatomic) NSInteger milestoneId;
@property(nonatomic) NSInteger projectId;
@property(nonatomic, copy) NSString *milestoneName;
@property(nonatomic) NSInteger mStateId;
@property(nonatomic, retain) NSDate *eArriveDate;
@property(nonatomic, retain) NSDate *aArriveDate;
@property(nonatomic) NSInteger margin;
@end
