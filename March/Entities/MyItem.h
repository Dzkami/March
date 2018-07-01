//
//  MyItem.h
//  TreeTableViewDemo
//
//  Created by Dzkami on 2018/6/30.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic) NSInteger level;
@property (nonatomic, retain) NSMutableArray *subItems;
@property (nonatomic) BOOL isSubItemOpen;
@property (nonatomic) BOOL isSubCascadeOpen;

@end
