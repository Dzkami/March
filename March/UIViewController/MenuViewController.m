//
//  MenuViewController.m
//  March
//
//  Created by Dzkami on 2018/6/29.
//  Copyright © 2018 Dzkami. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuView.h"
#import "MenuData.h"
#import "PGCell.h"
#import "ProjectCell.h"
#import "MyItem.h"
#import "AddProjectViewController.h"


@interface MenuViewController() <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>{
    NSUserDefaults *userDefault;
    MenuView *vw_menu;
    NSString *userName;
    NSString *userId;
    UITapGestureRecognizer *tap;
    UIAlertController *alertController;
}

@property (nonatomic, retain) MenuData *menuData;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMenu];
}

- (void)initMenu {
    [self.view setFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    userId = [userDefault objectForKey:@"userId"];
    
    vw_menu = [[MenuView alloc] init];
    [vw_menu.bt_userName addTarget:self action:@selector(toUserCenter) forControlEvents:UIControlEventTouchUpInside];
    
    [vw_menu.bt_add addTarget:self action:@selector(addProjectOrGroup) forControlEvents:UIControlEventTouchUpInside];
    
    self.menuData = [[MenuData alloc] init];
    [self loadMenuData:userId];
    [self initTopFuncView];
    [self initMenuTreeView];
}

- (void)loadMenuData:(NSString *)userId {
    SqliteUtil *sqlite = [[SqliteUtil alloc] init];
    [sqlite open_db];
    NSLog(@"%@",userId);
    NSString *searchName = [NSString stringWithFormat:@"SELECT * FROM userInfo WHERE userId = '%@'",userId];
    FMResultSet *uName = [sqlite search_db:searchName];
    while([uName next]) {
        userName = [uName stringForColumn:@"userName"];
    }
    
    NSString *searchPG = [NSString stringWithFormat:@"SELECT * FROM ProjectGroup WHERE userId = '%@';", userId];
    FMResultSet *pGroup = [sqlite search_db:searchPG];
    
    while([pGroup next]) {
        NSString *pGId = [pGroup stringForColumn:@"PGId"];
        NSString *pGName = [pGroup stringForColumn:@"PGName"];
        NSLog(@"%@",pGName);
        
        MyItem *root = [[MyItem alloc] init];
        root.title = pGName;
        root.itemId = pGId;
        root.subItems = [NSMutableArray array];
        root.level = 0;
        
        NSString *searchProject = [NSString stringWithFormat:@"SELECT * FROM Project WHERE PGId = '%@'",pGId];
        FMResultSet *projects = [sqlite search_db:searchProject];
        while([projects next]) {
            NSString *pId = [projects stringForColumn:@"projectId"];
            NSString *pName = [projects stringForColumn:@"projectName"];
            MyItem *subItem = [[MyItem alloc] init];
            subItem.title = pName;
            subItem.itemId = pId;
            subItem.level = 1;
            NSLog(@"%@",pName);
            [root.subItems addObject:subItem];
        }
        [self.menuData.tableViewData addObject:root];
    }
    [sqlite close_db];
    
}

- (void)initTopFuncView {
    [vw_menu.bt_userName setTitle:userName forState:UIControlStateNormal];
    [vw_menu.lb_userId setText:userId];
    [self.view addSubview:vw_menu];
}

- (void)initMenuTreeView {
    vw_menu.tv_menuTree.dataSource = self;
    vw_menu.tv_menuTree.delegate = self;
    vw_menu.tv_menuTree.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_menuData.tableViewData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyItem *item = [_menuData.tableViewData objectAtIndex:indexPath.row];
    
    if(item.level == 0) {
        PGCell *cell = [PGCell createCellWithTableView:tableView];
        cell.item = item;
        NSLog(@"%@",item.title);
        [cell setLabel];
        return cell;
    } else {
        ProjectCell *cell = [ProjectCell createCellWithTableView:tableView];
        cell.item = item;
        [cell setLabel];
        return cell;
    }
}

#pragma mark -- Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PGCell *cell = (PGCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.item.isSubItemOpen) {
        NSArray *arr = [_menuData deleteMenuIndexPaths:cell.item];
        if([arr count] > 0) {
            [tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        NSArray *arr = [_menuData insertMenuIndexPaths:cell.item];
        if([arr count] > 0) {
            [tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark -- ButtonActions
- (void)toUserCenter {
    //跳个人中心
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userId"];
}

- (void)addProjectOrGroup {
    alertController = [[UIAlertController alloc] init];
    NSString *addProjectBtTitle = @"添加项目";
    NSString *addGroupBtTitle = @"添加项目族";
    NSString *cancelTitle = @"取消";
    
    UIAlertAction *addProjectAction = [UIAlertAction actionWithTitle:addProjectBtTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentViewController:[[AddProjectViewController alloc] init] animated:true completion:nil];
    }];
    
    UIAlertAction *addGroupAction = [UIAlertAction actionWithTitle:addGroupBtTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    
    
    [alertController addAction:addProjectAction];
    [alertController addAction:addGroupAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark -- reload

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self initMenu];
}
@end
