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
    ProjectStateType_EndOfDelay
}ProjectStateType;

typedef enum : NSInteger {
    MilestoneStateType_NotArrive = 1,
    MilestoneStateType_ArrivePrematurely,
    MilestoneStateType_ArriveOnTime,
    MilestoneStateType_ArriveOfDelay
}MilestoneStateType;


typedef enum : NSInteger {
    UPRelationType_Manage = 1,
    UPRelationType_Participate
}UPRelationType;

typedef enum : NSInteger {
    AthorityType_Edit = 1,
    AthorityType_Excute,
    AthorityType_Browse
}AthorityType;


@interface Util : NSObject
+ (void)shake:(UITextField *)field;
+ (NSString *)transDateToString:(NSDate *)date;
@end
