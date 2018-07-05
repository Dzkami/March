//
//  Uitl.h
//  March
//
//  Created by Dzkami on 2018/6/29.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

typedef enum : NSInteger {
    CreateProjectCellType_TF = 0,
    CreateProjectCellType_DPK,
    CreateProjectCellType_PK,
    CreateProjectCellType_CA,
    CreateProjectCellType_MS
} CreateProjectCellType;

typedef enum : NSInteger {
    ProjectType_Study = 1,
    ProjectType_Environment,
    ProjectType_Usual,
    ProjectType_Commercial
}ProjectType;

typedef enum : NSInteger {
    ProjectStateType_NotStarted = 1,
    ProjectStateType_InProgress,
    ProjectStateType_EndPrematurely,
    ProjectStateType_EndOnTime,
    ProjectStateType_EndOfDelay,
    ProjectStateType_Delay
}ProjectStateType;

typedef enum : NSInteger {
    MilestoneStateType_NotArrive = 1,
    MilestoneStateType_ArrivePrematurely,
    MilestoneStateType_ArriveOnTime,
    MilestoneStateType_ArriveOfDelay
}MilestoneStateType;

typedef enum : NSInteger {
    TaskStateType_NotFinish = 1,
    TaskStateType_Delay,
    TaskStateType_Faild,
    TaskStateType_FinishPrematurely,
    TaskStateType_FinishOnTime,
    TaskStateType_FinishOfDelay
}TaskStateType;

typedef enum : NSInteger {
    UPRelationType_Manage = 1,
    UPRelationType_Participate
}UPRelationType;

typedef enum : NSInteger {
    AthorityType_Edit = 1,
    AthorityType_Excute,
    AthorityType_Browse
}AthorityType;

typedef enum : NSInteger {
    ShowProjectCellType_Footer = 0,
    ShowProjectCellType_Header,
    ShowProjectCellType_Milestone,
    ShowProjectCellType_AddTask,
    ShowProjectCellType_Task
} ShowProjectCellType;


@interface Util : NSObject
+ (void)shake:(UITextField *)field;
+ (NSString *)transDateToString:(NSDate *)date;
+ (NSString *)transDateWithMinuteToString:(NSDate *)date;
+ (NSDate *)transStringToDate:(NSString *)dateStr;
@end
