//
//  CreateProjectModel.h
//  March
//
//  Created by Dzkami on 2018/7/2.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"
//typedef enum : NSInteger {
//    CreateProjectCellType_TF = 0,
//    CreateProjectCellType_DPK,
//    CreateProjectCellType_PK,
//    CreateProjectCellType_CA,
//    CreateProjectCellType_MS
//} CreateProjectCellType;

@interface CreateProjectModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) CreateProjectCellType cellType;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;

@end
