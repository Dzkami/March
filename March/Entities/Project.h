//
//  Project.h
//  March
//
//  Created by Dzkami on 2018/6/29.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject
@property (nonatomic) NSInteger projectId;
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *projectGoal;
@property (nonatomic) NSInteger pTId;
@property (nonatomic) NSInteger pGId;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *eEndDate;
@property (nonatomic, retain) NSDate *aEndDate;
@property (nonatomic) NSInteger pStateId;
@property (nonatomic) NSInteger margin;
@property (nonatomic, retain) NSMutableArray *milestone;

@end
