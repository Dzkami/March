//
//  SqliteUtil.h
//  March
//
//  Created by Dzkami on 2018/6/28.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface SqliteUtil : NSObject
-(void)open_db;
-(BOOL)add_db:(NSString *)sql withParamterDic:(NSDictionary *)paraDic;
-(FMResultSet *)search_db:(NSString *)sql;
-(BOOL)update_db:(NSString *)sql;
-(void)close_db;

@end
