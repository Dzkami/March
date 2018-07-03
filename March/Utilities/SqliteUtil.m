//
//  SqliteUtil.m
//  March
//
//  Created by Dzkami on 2018/6/28.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "SqliteUtil.h"

@interface SqliteUtil () {
    FMDatabase *fmdb;
}

//@property (nonatomic, retain)
@end

@implementation SqliteUtil

-(void)open_db {
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, true) lastObject];
//    NSString *dbPath = [docPath stringByAppendingString:@"march.db"];

    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"Documentationmarch" ofType:@"db"];
    NSLog(@"%@", dbPath);
    fmdb = [FMDatabase databaseWithPath:dbPath];


    if([fmdb open]) {
        NSLog(@"打开成功");
    } else {
        NSLog(@"打开失败");
    }
}

-(BOOL)add_db:(NSString *)sql withParamterDic:(NSDictionary *)paraDic {
    BOOL success = [fmdb executeUpdate:sql withParameterDictionary:paraDic];
    if(success) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
    return success;
}

-(FMResultSet *)search_db:(NSString *)sql {
    FMResultSet *result = [fmdb executeQuery:sql];
    return result;
}

-(BOOL)update_db:(NSString *)sql{
    BOOL success = [fmdb executeUpdate:sql];
    if(success) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
    return success;
}

-(void)close_db {
    BOOL success = [fmdb close];
    if(success) {
        NSLog(@"关闭成功");
    } else {
        NSLog(@"关闭失败");
    }
}


@end
