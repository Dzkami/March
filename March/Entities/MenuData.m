//
//  MenuData.m
//  TreeTableViewDemo
//
//  Created by Dzkami on 2018/6/30.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "MenuData.h"
#import "MyItem.h"

@interface MenuData() {
    MyItem *rootItem1;
    MyItem *rootItem2;
}
@property (nonatomic, retain)NSMutableArray *treeItemsToRemove;
@property (nonatomic, retain)NSMutableArray *treeItemsToInsert;

@end

@implementation MenuData
- (id)init {
    self = [super init];
    if (self) {
        self.tableViewData = [NSMutableArray array];
        
        self.treeItemsToRemove = [NSMutableArray array];
        self.treeItemsToInsert = [NSMutableArray array];
//        [self initModelData];
    }
    
    return self;
}

//- (void )initModelData {
//    rootItem1 = [[MyItem alloc] init];
//    rootItem1.title = @"项目族1";
//    rootItem1.subItems = [NSMutableArray array];
//    rootItem1.level = 0;
//    
//    NSArray *firstMenuData1 = [NSArray arrayWithObjects:@"项目1",@"项目2",@"项目3", nil];
//    for (int i = 0; i < [firstMenuData1 count]; i++) {
//        MyItem *firstItem = [[MyItem alloc] init];
//        firstItem.title = [firstMenuData1 objectAtIndex:i];
//        firstItem.level = 1;
//        
//        [rootItem1.subItems addObject:firstItem];
//    }
//    
//    rootItem2 = [[MyItem alloc] init];
//    rootItem2.title = @"项目族2";
//    rootItem2.subItems = [NSMutableArray array];
//    rootItem2.level = 0;
//    
//    NSArray *firstMenuData2 = [NSArray arrayWithObjects:@"项目4",@"项目5",@"项目6", nil];
//    for (int i = 0; i < [firstMenuData2 count]; i++) {
//        MyItem *firstItem = [[MyItem alloc] init];
//        firstItem.title = [firstMenuData2 objectAtIndex:i];
//        firstItem.level = 1;
//        
//        [rootItem2.subItems addObject:firstItem];
//    }
//    
//    [_tableViewData addObject:rootItem1];
//    [_tableViewData addObject:rootItem2];
//}

#pragma mark -- insert
- (NSArray *)insertMenuIndexPaths: (MyItem *)item {

    [self.treeItemsToInsert removeAllObjects];
    [self insertMenuObject:item];
    return [self insertIndexPathsOfMenuObject:self.treeItemsToInsert];
    
}

//把子节点插入tableViewData数组中
- (void) insertMenuObject:(MyItem *)item {
    if(!item) {
        return;
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:[_tableViewData indexOfObject:item] inSection:0];
    MyItem *childItem;
    for (int i = 0; i < [item.subItems count]; i++) {
        childItem = [item.subItems objectAtIndex:i];
        [_tableViewData insertObject:childItem atIndex:path.row + i + 1];
        [self.treeItemsToInsert addObject:childItem];
        item.isSubItemOpen = true;
    }
    
    for (int i = 0; i < [item.subItems count]; i++) {
        childItem = [item.subItems objectAtIndex:i];
        if(childItem.isSubCascadeOpen) {
            [self insertMenuObject:childItem];
        }
    }
}

//计算子节点的indexPath,并存在数组中返回
- (NSArray *) insertIndexPathsOfMenuObject: (NSMutableArray *)array {
    NSMutableArray *objectPaths = [NSMutableArray array];
    for (MyItem *item in array) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_tableViewData indexOfObject:item] inSection:0];
        [objectPaths addObject:path];
    }
    
    return objectPaths;
}

#pragma mark -- delete
- (NSArray *)deleteMenuIndexPaths:(MyItem *)item {
    [self.treeItemsToRemove removeAllObjects];
    [self deleteMenuObject:item];
    return [self deleteIndexPathsOfMenuObject:self.treeItemsToRemove];
}

- (void) deleteMenuObject: (MyItem *)item {
    if(!item) {
        return;
    }
    
    MyItem *childItem;
    for (int i = 0; i < [item.subItems count]; i++) {
        childItem = [item.subItems objectAtIndex:i];
        [self deleteMenuObject:childItem]; //子节点中的子节点也删掉
        
        [self.treeItemsToRemove addObject:childItem];
    }
    
    item.isSubItemOpen = false;
}

- (NSArray *) deleteIndexPathsOfMenuObject:(NSMutableArray *) array {
    NSMutableArray *objectPaths = [NSMutableArray array];
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [self.treeItemsToRemove count]; i++) {
        MyItem *item = [self.treeItemsToRemove objectAtIndex:i];
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_tableViewData indexOfObject:item] inSection:0];
        [objectPaths addObject:path];
        [set addIndex:path.row];
    }
    
    [_tableViewData removeObjectsAtIndexes:set];
    
    return objectPaths;
}


@end
