//
//  MenuData.h
//  TreeTableViewDemo
//
//  Created by Dzkami on 2018/6/30.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyItem.h"
@interface MenuData : NSObject

@property (nonatomic, retain) NSMutableArray *tableViewData;

- (NSArray *)insertMenuIndexPaths: (MyItem *)item;
- (NSArray *)deleteMenuIndexPaths:(MyItem *)item;

@end
