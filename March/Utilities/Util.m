//
//  Uitl.m
//  March
//
//  Created by Dzkami on 2018/6/29.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "Util.h"


@implementation Util

#pragma mark -- Shake
+ (void)shake:(UITextField *)field{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:.3f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(field.center.x, field.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(field.center.x-5, field.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(field.center.x+5, field.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(field.center.x, field.center.y)],                      [NSValue valueWithCGPoint:CGPointMake(field.center.x-5, field.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(field.center.x+5, field.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(field.center.x, field.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(field.center.x-5, field.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(field.center.x+5, field.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(field.center.x, field.center.y)],
                      nil];
    [keyAn setValues:array];
    // 添加动画
    [field.layer addAnimation:keyAn forKey:@"text"];
}

+ (NSString *)transDateToString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    return [formatter stringFromDate:date];
}

//+ (NSString *)transDateWithMinuteToString:(NSDate *)date {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    return [formatter stringFromDate:date];
//}


+ (NSDate *)transStringToDate:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSDate *date = [formatter dateFromString:dateStr];
    
    return date;
}


@end
